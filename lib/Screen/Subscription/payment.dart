// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../Provider/bank_info_provider.dart';
import '../../Provider/profile_provider.dart';
import '../../const.dart';
import '../../model/subscription_plan_model.dart';
import '../Widgets/Constant Data/constant.dart';
import '../Widgets/Sidebar/sidebar_widget.dart';
import 'package:file_picker/file_picker.dart';

import '../Widgets/TopBar/top_bar_widget.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    super.key,
    this.subscriptionPlanModel,
  });
  final SubscriptionPlanModel? subscriptionPlanModel;

  static const String route = '/pay';

  @override
  // ignore: library_private_types_in_public_api
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  ScrollController mainScroll = ScrollController();
  Future<Uint8List?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        imageController.text = result.files.single.name;
      });
      return result.files.single.bytes;
    } else {
      return null;
    }
  }

  Uint8List? bytesFromPicker;

  Future<String> uploadFile() async {
    try {
      var snapshot = await FirebaseStorage.instance.ref('Subscription Attachment/${DateTime.now().millisecondsSinceEpoch}').putData(bytesFromPicker!);
      var url = await snapshot.ref.getDownloadURL();

      EasyLoading.showSuccess('Upload Successful!');
      return url;
    } catch (e) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
      return '';
    }
  }

  SubscriptionRequestModel data = SubscriptionRequestModel(
    subscriptionPlanModel: SubscriptionPlanModel(
        dueNumber: 0, duration: 0, offerPrice: 0, partiesNumber: 0, products: 0, purchaseNumber: 0, saleNumber: 0, subscriptionName: '', subscriptionPrice: 00),
    transactionNumber: '',
    note: '',
    attachment: '',
    userId: constUserId,
    businessCategory: '',
    companyName: '',
    countryName: '',
    language: '',
    phoneNumber: '',
    pictureUrl: '',
  );
  TextEditingController imageController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data.subscriptionPlanModel = widget.subscriptionPlanModel!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkWhite,
      body: Consumer(builder: (context, ref, __) {
        final userProfileDetails = ref.watch(profileDetailsProvider);
        final bank = ref.watch(bankInfoProvider);
        return Scrollbar(
          controller: mainScroll,
          child: SingleChildScrollView(
            controller: mainScroll,
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 240,
                  child: SideBarWidget(
                    index: 14,
                    isTab: false,
                  ),
                ),
                userProfileDetails.when(data: (details) {
                  data.countryName = details.countryName;
                  data.language = details.language;
                  data.pictureUrl = details.pictureUrl;
                  data.companyName = details.companyName;
                  data.businessCategory = details.businessCategory;
                  data.phoneNumber = details.phoneNumber ?? '';
                  return Container(
                    width: MediaQuery.of(context).size.width < 1275 ? 1275 - 240 : MediaQuery.of(context).size.width - 240,
                    // width: context.width() < 1080 ? 1080 - 240 : MediaQuery.of(context).size.width - 240,
                    decoration: const BoxDecoration(color: kDarkWhite),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          //_______________________________top_bar____________________________
                          const TopBar(),

                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: kWhiteTextColor),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lang.S.of(context).buy,
                                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                  ),
                                  Divider(
                                    thickness: 1.0,
                                    color: kGreyTextColor.withOpacity(0.1),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          lang.S.of(context).bankInformation,
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  ///_________Bank_Info__________________________________
                                  bank.when(
                                    data: (bankData) {
                                      return Column(
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  lang.S.of(context).bankName,
                                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      ':',
                                                      style: kTextStyle.copyWith(color: kGreyTextColor),
                                                    ),
                                                    const SizedBox(width: 20.0),
                                                    Text(
                                                      bankData.bankName,
                                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  lang.S.of(context).branchName,
                                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      ':',
                                                      style: kTextStyle.copyWith(color: kGreyTextColor),
                                                    ),
                                                    const SizedBox(width: 20.0),
                                                    Text(
                                                      bankData.branchName,
                                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  lang.S.of(context).accountName,
                                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      ':',
                                                      style: kTextStyle.copyWith(color: kGreyTextColor),
                                                    ),
                                                    const SizedBox(width: 20.0),
                                                    Text(
                                                      bankData.accountName,
                                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  lang.S.of(context).accountNumber,
                                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      ':',
                                                      style: kTextStyle.copyWith(color: kGreyTextColor),
                                                    ),
                                                    const SizedBox(width: 20.0),
                                                    Text(
                                                      bankData.accountNumber,
                                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  lang.S.of(context).swiftCode,
                                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      ':',
                                                      style: kTextStyle.copyWith(color: kGreyTextColor),
                                                    ),
                                                    const SizedBox(width: 20.0),
                                                    Text(
                                                      bankData.swiftCode,
                                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  lang.S.of(context).bankAccountingCurrecny,
                                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      ':',
                                                      style: kTextStyle.copyWith(color: kGreyTextColor),
                                                    ),
                                                    const SizedBox(width: 20.0),
                                                    Text(
                                                      bankData.bankAccountCurrency,
                                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                    error: (e, stack) {
                                      return Center(
                                        child: Text(e.toString()),
                                      );
                                    },
                                    loading: () {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                  ),

                                  const SizedBox(height: 30),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: TextFormField(
                                          onChanged: (value) {
                                            data.transactionNumber = value;
                                          },
                                          decoration: kInputDecoration.copyWith(
                                              floatingLabelBehavior: FloatingLabelBehavior.always,
                                              labelText: lang.S.of(context).transactionId,
                                              hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                              labelStyle: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: kTitleColor),
                                              hintText: lang.S.of(context).enterTransactionId),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        flex: 1,
                                        child: TextFormField(
                                          onChanged: (value) {
                                            data.note = value;
                                          },
                                          decoration: kInputDecoration.copyWith(
                                              floatingLabelBehavior: FloatingLabelBehavior.always,
                                              hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                              labelText: lang.S.of(context).note,
                                              labelStyle: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: kTitleColor),
                                              hintText: lang.S.of(context).enterNote),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width / 2.6,
                                    child: TextFormField(
                                      controller: imageController,
                                      onTap: () async {
                                        bytesFromPicker = await pickFile();
                                      },
                                      readOnly: true,
                                      decoration: kInputDecoration.copyWith(
                                          floatingLabelBehavior: FloatingLabelBehavior.always,
                                          labelText: lang.S.of(context).uploadDocument,
                                          labelStyle: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: kTitleColor),
                                          hintText: lang.S.of(context).uploadFile,
                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                          suffixIcon: const Icon(
                                            FeatherIcons.upload,
                                            color: kGreyTextColor,
                                          )),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  Center(
                                    child: SizedBox(
                                      height: 40.0,
                                      width: MediaQuery.of(context).size.width < 1080 ? 1080 * .30 : MediaQuery.of(context).size.width * .30,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                                          backgroundColor: kMainColor,
                                          textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                          ),
                                        ),
                                        onPressed: () async {
                                          if (data.transactionNumber == '') {
                                            EasyLoading.showError('Please Enter Transaction Number');
                                          } else {
                                            String? sellerUserRef = await getSaleID(id: await getUserID());
                                            if (sellerUserRef != null) {
                                              data.userId = await getUserID();
                                              EasyLoading.show(status: 'Loading...');
                                              data.attachment = await uploadFile();
                                              final DatabaseReference ref = FirebaseDatabase.instance.ref().child('Admin Panel').child('Subscription Update Request');

                                              await ref.push().set(data.toJson());
                                              EasyLoading.showSuccess('Request has been send');
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            } else {
                                              EasyLoading.showError('You Are Not A Valid User');
                                            }

                                            ///_______________________________
                                            // EasyLoading.show(status: 'Loading...');
                                            // data.attachment = await uploadFile();
                                            // final DatabaseReference ref = FirebaseDatabase.instance.ref().child('Admin Panel').child('Subscription Update Request');
                                            //
                                            // ref.push().set(data.toJson());
                                            // EasyLoading.showSuccess('Request has been send');
                                            // Navigator.pop(context);
                                            // Navigator.pop(context);
                                          }
                                        },
                                        child: Text(
                                          lang.S.of(context).payCash,
                                          style: kTextStyle.copyWith(color: kWhiteTextColor, fontSize: 18.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }, error: (Object error, StackTrace? stackTrace) {
                  return Text(error.toString());
                }, loading: () {
                  return const Center(child: CircularProgressIndicator());
                }),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class SubscriptionRequestModel {
  SubscriptionPlanModel subscriptionPlanModel;
  late String transactionNumber, note, attachment, userId;
  String phoneNumber;
  String companyName;
  String pictureUrl;
  String businessCategory;
  String language;
  String countryName;

  SubscriptionRequestModel({
    required this.subscriptionPlanModel,
    required this.transactionNumber,
    required this.note,
    required this.attachment,
    required this.userId,
    required this.phoneNumber,
    required this.businessCategory,
    required this.companyName,
    required this.pictureUrl,
    required this.countryName,
    required this.language,
  });

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'id': DateTime.now().toString(),
        'userId': userId,
        'subscriptionName': subscriptionPlanModel.subscriptionName,
        'subscriptionDuration': subscriptionPlanModel.duration,
        'subscriptionPrice': subscriptionPlanModel.offerPrice > 0 ? subscriptionPlanModel.offerPrice : subscriptionPlanModel.subscriptionPrice,
        'transactionNumber': transactionNumber,
        'note': note,
        'status': 'pending',
        'approvedDate': '',
        'attachment': attachment,
        'phoneNumber': phoneNumber,
        'companyName': companyName,
        'pictureUrl': pictureUrl,
        'businessCategory': businessCategory,
        'language': language,
        'countryName': countryName,
      };
}
