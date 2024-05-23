import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Screen/Home/home_screen.dart';

import '../const.dart';
import '../model/user_role_model.dart';

final logInProvider = ChangeNotifierProvider((ref) => LogInRepo());

class LogInRepo extends ChangeNotifier {
  String email = '';
  String password = '';

  Future<void> signIn(BuildContext context) async {
    EasyLoading.show(status: 'Login...');
    try {
      mainLoginEmail = email;
      mainLoginPassword = password;
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value) async {
        // await sendEmailVerification();
        if (await checkSubUser()) {
          EasyLoading.showSuccess('Successful');
          setUserDataOnLocalData(uid: constUserId, subUserTitle: constSubUserTitle, isSubUser: true);
          putUserDataImidiyate(uid: constUserId, title: '', isSubUse: true);
          // printUserData();
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushNamed(MtHomeScreen.route);
        } else {
          EasyLoading.showSuccess('Successful');
          setUserDataOnLocalData(uid: FirebaseAuth.instance.currentUser!.uid, subUserTitle: '', isSubUser: false);
          putUserDataImidiyate(uid: FirebaseAuth.instance.currentUser!.uid, title: '', isSubUse: false);
          // printUserData();
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushNamed(MtHomeScreen.route);
        }
      });

      // // ignore: unnecessary_null_comparison
      // if (userCredential != null) {
      //   EasyLoading.showSuccess('Successful');
      //   // ignore: use_build_context_synchronously
      //   Navigator.of(context).pushNamed(MtHomeScreen.route);
      // }
    } on FirebaseAuthException catch (e) {
      EasyLoading.showError(e.message.toString());
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No user found for that email.'),
            duration: Duration(seconds: 3),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wrong password provided for that user.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      EasyLoading.showError(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }


  Future<bool> checkSubUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isSubUser = false;
    await FirebaseDatabase.instance.ref('Admin Panel').child('User Role').orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = UserRoleModel.fromJson(jsonDecode(jsonEncode(element.value)));

        if (data.email == email) {
          prefs.setString('userPermission', json.encode(data));
          // finalUserRoleModel = data;

          constUserId = data.databaseId;
          constSubUserTitle = data.userTitle;
          isSubUser = true;
          return;
        }
      }
    });
    return isSubUser;
  }

}

Future<void> sendEmailVerification() async {
  User? user = FirebaseAuth.instance.currentUser;

  try {
    await user?.sendEmailVerification();
    print('Email verification link sent');
  } catch (e) {
    print('Error sending email verification link: $e');
  }
}
