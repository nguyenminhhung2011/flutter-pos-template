// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nb_utils/nb_utils.dart';
import 'Screen/Subscription/subscription_plan_page.dart';
import 'const.dart';
import 'model/subscription_model.dart';
import 'model/subscription_plan_model.dart';

// class Subscription {
//   CurrentSubscriptionPlanRepo currentSubscriptionPlanRepo = CurrentSubscriptionPlanRepo();
//   static bool isExpiringInFiveDays = false;
//   static bool isExpiringInOneDays = false;
//
//   static SubscriptionModel freeSubscriptionPlan = SubscriptionModel(
//     subscriptionName: 'Free',
//     subscriptionDate: DateTime.now().toString(),
//     saleNumber: 50,
//     purchaseNumber: 50,
//     partiesNumber: 50,
//     dueNumber: 50,
//     duration: 30,
//     products: 50,
//   );
//   static late SubscriptionModel dataModel;
//   static late String subscriptionName;
//   static late int remainingSales;
//   static late int remainingPurchase;
//   static late int remainingParties;
//   static late int remainingDue;
//   static late int remainingProducts;
//   static late Duration remainingTime;
//   static late int subscriptionDuration;
//
//   static Future<void> getUserLimitsData({required BuildContext context, required bool wannaShowMsg}) async {
//
//
//     DatabaseReference ref = FirebaseDatabase.instance.ref('${await getUserID()}/Subscription');
//     final model = await ref.get();
//     var data = jsonDecode(jsonEncode(model.value));
//     dataModel = SubscriptionModel.fromJson(data);
//     remainingTime = DateTime.parse(dataModel.subscriptionDate).difference(DateTime.now());
//
//     subscriptionName = dataModel.subscriptionName;
//     subscriptionDuration = dataModel.duration;
//     remainingSales = dataModel.saleNumber;
//     remainingPurchase = dataModel.purchaseNumber;
//     remainingParties = dataModel.partiesNumber;
//     remainingDue = dataModel.dueNumber;
//     remainingProducts = dataModel.products;
//     if (subscriptionDuration != -202 && wannaShowMsg) {
//       if (remainingTime.inHours.abs().isBetween((subscriptionDuration * 24) - 24, subscriptionDuration * 24)) {
//         isExpiringInOneDays = true;
//         isExpiringInFiveDays = false;
//       } else if (remainingTime.inHours.abs().isBetween((subscriptionDuration * 24) - 120, subscriptionDuration * 24)) {
//         isExpiringInFiveDays = true;
//         isExpiringInOneDays = false;
//       }
//
//       if (isExpiringInFiveDays) {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return Dialog(
//               shape: const CircleBorder(side: BorderSide.none),
//               child: Container(
//                 decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(30))),
//                 child: Padding(
//                   padding: const EdgeInsets.all(30.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Text(
//                         'Your Current Package Will Expire in 5 Day',
//                         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kGreyTextColor),
//                       ),
//                       const SizedBox(height: 20),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         child: const Text(
//                           'Cancel',
//                           style: TextStyle(fontSize: 18, color: Colors.red),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       }
//       if (isExpiringInOneDays) {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return Dialog(
//               shape: const CircleBorder(side: BorderSide.none),
//               child: Container(
//                 decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(30))),
//                 child: Padding(
//                   padding: const EdgeInsets.all(30.0),
//                   child: SizedBox(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         const SizedBox(height: 20),
//                         const Text(
//                           'Your Package Will Expire Today',
//                           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kGreyTextColor),
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 10),
//                         const Text(
//                           'Please Purchase Again',
//                           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kGreyTextColor),
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 20),
//                         TextButton(
//                           onPressed: () {
//                             const SubscriptionPage().launch(context);
//                           },
//                           child: const Text(
//                             'Purchase',
//                             style: TextStyle(fontSize: 18, color: kBlueTextColor),
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         TextButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           child: const Text(
//                             'Cancel',
//                             style: TextStyle(fontSize: 18, color: Colors.red),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       }
//     }
//   }
//
//   static Future<bool> subscriptionChecker({
//     required String item,
//   }) async {
//     final DatabaseReference subscriptionRef = FirebaseDatabase.instance.ref().child(await getUserID()).child('Subscription');
//
//     if (remainingTime.inHours.abs() > subscriptionDuration * 24) {
//       await subscriptionRef.set(freeSubscriptionPlan.toJson());
//     } else if (item == PosSale.route && remainingSales <= 0 && remainingSales != -202) {
//       return false;
//     } else if ((item == SupplierList.route || item == CustomerList.route) && remainingParties <= 0 && remainingParties != -202) {
//       return false;
//     } else if (item == Purchase.route && remainingPurchase <= 0 && remainingPurchase != -202) {
//       return false;
//     } else if (item == Product.route && remainingProducts <= 0 && remainingProducts != -202) {
//       return false;
//     } else if (item == DueList.route && remainingDue <= 0 && remainingDue != -202) {
//       return false;
//     }
//     return true;
//   }
//
//   static void decreaseSubscriptionLimits({required String itemType, required BuildContext context}) async {
//
//     final ref = FirebaseDatabase.instance.ref(await getUserID()).child('Subscription');
//     ref.keepSynced(true);
//     ref.child(itemType).get().then((value) {
//       int beforeAction = int.parse(value.value.toString());
//       if (beforeAction != -202) {
//         int afterAction = beforeAction - 1;
//         ref.update({itemType: afterAction});
//         Subscription.getUserLimitsData(context: context, wannaShowMsg: false);
//       }
//     });
//   }
// }

class Subscription {
  static List<SubscriptionPlanModel> subscriptionPlan = [];

  static SubscriptionModel freeSubscriptionModel = SubscriptionModel(
    dueNumber: 0,
    duration: 0,
    partiesNumber: 0,
    products: 0,
    purchaseNumber: 0,
    saleNumber: 0,
    subscriptionDate: DateTime.now().toString(),
    subscriptionName: 'Free',
  );
  static String selectedItem = 'Year';

  static bool isExpiringInFiveDays = false;
  static bool isExpiringInOneDays = false;
  static Map<String, Map<String, String>> subscriptionPlansService = {
    'Free': {
      'Sales': '50',
      'Purchase': '50',
      'Due Collection': '50',
      'Parties': '50',
      'Products': '50',
      'Duration': '30',
    },
    'Month': {
      'Sales': 'unlimited',
      'Purchase': 'unlimited',
      'Due Collection': 'unlimited',
      'Parties': 'unlimited',
      'Products': 'unlimited',
      'Duration': '30',
    },
    'Year': {
      'Sales': 'unlimited',
      'Purchase': 'unlimited',
      'Due Collection': 'unlimited',
      'Parties': 'unlimited',
      'Products': 'unlimited',
      'Duration': '365',
    },
    'Lifetime': {
      'Sales': 'unlimited',
      'Purchase': 'unlimited',
      'Due Collection': 'unlimited',
      'Parties': 'unlimited',
      'Products': 'unlimited',
      'Duration': 'unlimited',
    },
  };
  static Map<String, Map<String, double>> subscriptionAmounts = {
    'Free': {
      'Amount': 0,
    },
    'Month': {
      'Amount': 9.99,
    },
    'Year': {
      'Amount': 99.99,
    },
    'Lifetime': {
      'Amount': 999.99,
    },
  };

  static SubscriptionModel subscriptionModel = SubscriptionModel(
    subscriptionName: 'Free',
    subscriptionDate: DateTime.now().toString(),
    saleNumber: int.parse(Subscription.subscriptionPlansService['Free']!['Sales']!),
    purchaseNumber: int.parse(Subscription.subscriptionPlansService['Free']!['Purchase']!),
    partiesNumber: int.parse(Subscription.subscriptionPlansService['Free']!['Parties']!),
    dueNumber: int.parse(Subscription.subscriptionPlansService['Free']!['Due Collection']!),
    duration: 30,
    products: int.parse(Subscription.subscriptionPlansService['Free']!['Products']!),
  );
  static late SubscriptionModel dataModel;
  static late String subscriptionName;
  static late int remainingSales;
  static late int remainingPurchase;
  static late int remainingParties;
  static late int remainingDue;
  static late int remainingProducts;
  static late Duration remainingTime;

  static Future<void> getUserLimitsData({required BuildContext context, required bool wannaShowMsg}) async {
    final prefs = await SharedPreferences.getInstance();

    DatabaseReference ref = FirebaseDatabase.instance.ref('${await getUserID()}/Subscription');
    final model = await ref.get();
    var data = jsonDecode(jsonEncode(model.value));
    selectedItem = SubscriptionModel.fromJson(data).subscriptionName;
    dataModel = SubscriptionModel.fromJson(data);
    remainingTime = DateTime.parse(dataModel.subscriptionDate).difference(DateTime.now());

    subscriptionName = dataModel.subscriptionName;
    remainingSales = dataModel.saleNumber;
    remainingPurchase = dataModel.purchaseNumber;
    remainingParties = dataModel.partiesNumber;
    remainingDue = dataModel.dueNumber;
    remainingProducts = dataModel.products;
    if (subscriptionName != 'Lifetime' && wannaShowMsg) {
      if (remainingTime.inHours.abs().isBetween((dataModel.duration * 24) - 24, dataModel.duration * 24)) {
        await prefs.setBool('isFiveDayRemainderShown', false);
        isExpiringInOneDays = true;
        isExpiringInFiveDays = false;
      } else if (remainingTime.inHours.abs().isBetween((dataModel.duration * 24) - 120, dataModel.duration * 24)) {
        isExpiringInFiveDays = true;
        isExpiringInOneDays = false;
      }

      final bool isFiveDayRemainderShown = prefs.getBool('isFiveDayRemainderShown') ?? false;

      if (isExpiringInFiveDays && isFiveDayRemainderShown == false) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: SizedBox(
                height: 200,
                width: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Your Package Will Expire in 5 Day',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () async {
                        await prefs.setBool('isFiveDayRemainderShown', true);
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
      if (isExpiringInOneDays) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Your Package Will Expire Today\n\nPlease Purchase again',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          TextButton(
                            onPressed: () {
                              const SubscriptionPage().launch(context);
                            },
                            child: const Text('Purchase'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
    }
  }

  static Future<void> getUserSubiscriptionData() async {
    final prefs = await SharedPreferences.getInstance();

    DatabaseReference ref = FirebaseDatabase.instance.ref('$constUserId/Subscription');
    final model = await ref.get();
    var data = jsonDecode(jsonEncode(model.value));
    selectedItem = SubscriptionModel.fromJson(data).subscriptionName;
    dataModel = SubscriptionModel.fromJson(data);
    remainingTime = DateTime.parse(dataModel.subscriptionDate).difference(DateTime.now());

    subscriptionName = dataModel.subscriptionName;
    remainingSales = dataModel.saleNumber;
    remainingPurchase = dataModel.purchaseNumber;
    remainingParties = dataModel.partiesNumber;
    remainingDue = dataModel.dueNumber;
    remainingProducts = dataModel.products;
  }

  static Future<bool> subscriptionChecker({
    required String item,
  }) async {
    await getUserDataFromLocal();
    await getUserSubiscriptionData();
    final DatabaseReference subscriptionRef = FirebaseDatabase.instance.ref().child(constUserId).child('Subscription');

    if (subscriptionName == 'Free') {
      if (remainingTime.inHours.abs() > 720) {
        await subscriptionRef.set(subscriptionModel.toJson());
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isFiveDayRemainderShown', true);
      } else if (item == 'Sales' && remainingSales <= 0) {
        return false;
      } else if (item == 'Parties' && remainingParties <= 0) {
        return false;
      } else if (item == 'Purchase' && remainingPurchase <= 0) {
        return false;
      } else if (item == 'Products' && remainingProducts <= 0) {
        return false;
      } else if (item == 'Due List' && remainingDue <= 0) {
        return false;
      }
    } else if (subscriptionName == 'Month') {
      if (remainingTime.inHours.abs() > 720) {
        await subscriptionRef.set(subscriptionModel.toJson());
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isFiveDayRemainderShown', true);
      } else {
        return true;
      }
    } else if (subscriptionName == 'Year') {
      if (remainingTime.inHours.abs() > 8760) {
        await subscriptionRef.set(subscriptionModel.toJson());
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isFiveDayRemainderShown', true);
      } else {
        return true;
      }
      EasyLoading.dismiss();
    } else if (subscriptionName == 'Lifetime') {
      return true;
    }
    return true;
  }

  static void decreaseSubscriptionLimits({required String itemType, required BuildContext context}) async {
    final ref = FirebaseDatabase.instance.ref(constUserId).child('Subscription');
    ref.keepSynced(true);
    ref.child(itemType).get().then((value) {
      print(value.value);
      int beforeAction = int.parse(value.value.toString());
      if (beforeAction != -202) {
        int afterAction = beforeAction - 1;
        ref.update({itemType: afterAction});
      }

      Subscription.getUserLimitsData(context: context, wannaShowMsg: false);
    });
    // var data = await ref.once();
    // int beforeAction = int.parse(data.snapshot.value.toString());
    // int afterAction = beforeAction - 1;
    // FirebaseDatabase.instance.ref('$userId/Subscription').update({itemType: afterAction});
    // Subscription.getUserLimitsData(context: context, wannaShowMsg: false);
  }
}
