// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Repository/paypal_repo.dart';
import 'package:salespro_admin/Screen/Subscription/purchase_plan.dart';
import 'package:salespro_admin/model/subscription_model.dart';
import '../../Provider/subacription_plan_provider.dart';
import '../../Repository/subscriptionPlanRepo.dart';
import '../../const.dart';
import '../../model/subscription_plan_model.dart';
import '../../subscription.dart';
import '../Widgets/Constant Data/constant.dart';
import '../Widgets/Footer/footer.dart';
import '../Widgets/Sidebar/sidebar_widget.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;

import '../Widgets/TopBar/top_bar_widget.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({
    super.key,
  });
  static const String route = '/subscription_plans';

  @override
  // ignore: library_private_types_in_public_api
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  CurrentSubscriptionPlanRepo currentSubscriptionPlanRepo = CurrentSubscriptionPlanRepo();
  String? initialSelectedPackage = 'Free';
  SubscriptionModel subscriptionModel = SubscriptionModel(
    subscriptionName: '',
    subscriptionDate: DateTime.now().toString(),
    saleNumber: 0,
    purchaseNumber: 0,
    partiesNumber: 0,
    dueNumber: 0,
    duration: 0,
    products: 0,
  );
  int? initPackageValue;
  Duration? remainTime;
  List<String>? initialPackageService;

  void checkSubscriptionData() async {
    EasyLoading.show(status: 'Loading');
    DatabaseReference ref = FirebaseDatabase.instance.ref('$constUserId/Subscription');
    final model = await ref.get();
    var data = jsonDecode(jsonEncode(model.value));
    Subscription.selectedItem = SubscriptionModel.fromJson(data).subscriptionName;
    final finalModel = SubscriptionModel.fromJson(data);
    if (finalModel.subscriptionName == 'Free') {
      Subscription.selectedItem = 'Year';
    } else if (finalModel.subscriptionName == 'Month') {
      initPackageValue = 1;
      Subscription.selectedItem = 'Month';
    } else if (finalModel.subscriptionName == 'Year') {
      initPackageValue = 2;
      Subscription.selectedItem = 'Year';
    } else if (finalModel.subscriptionName == 'Lifetime') {
      initPackageValue = 3;
      Subscription.selectedItem = 'Lifetime';
    }

    setState(() {
      initialSelectedPackage = finalModel.subscriptionName;
      subscriptionModel = finalModel;
      initialPackageService = [
        subscriptionModel.saleNumber.toString(),
        subscriptionModel.purchaseNumber.toString(),
        subscriptionModel.dueNumber.toString(),
        subscriptionModel.partiesNumber.toString(),
        subscriptionModel.products.toString(),
      ];
    });
    EasyLoading.dismiss();
  }

  // SubscriptionModel currentSubscriptionPlan = SubscriptionModel(
  //   subscriptionName: 'Free',
  //   subscriptionDate: DateTime.now().toString(),
  //   saleNumber: 0,
  //   purchaseNumber: 0,
  //   partiesNumber: 0,
  //   dueNumber: 0,
  //   duration: 0,
  //   products: 0,
  // );

  // void getCurrentSubscriptionPlan() async {
  //   currentSubscriptionPlan = await currentSubscriptionPlanRepo.getCurrentSubscriptionPlans();
  //   setState(() {
  //     currentSubscriptionPlan;
  //   });
  // }

  @override
  initState() {
    super.initState();
    checkSubscriptionData();
    // getCurrentSubscriptionPlan();
  }

  List<Color> colors = [
    const Color(0xFF06DE90),
    const Color(0xFFF5B400),
    const Color(0xFFFF7468),
  ];
  PaypalRepo paypalRepo = PaypalRepo();
  SubscriptionPlanModel selectedPlan =
      SubscriptionPlanModel(subscriptionName: '', saleNumber: 0, purchaseNumber: 0, partiesNumber: 0, dueNumber: 0, duration: 0, products: 0, subscriptionPrice: 0, offerPrice: 0);
  ScrollController mainScroll = ScrollController();

  List<String> nameList = ['Sales', 'Purchase', 'Due collection', 'Parties', 'Products'];
  List<Color> colorList = [
    const Color(0xffff5722),
    const Color(0xff028a7e),
    const Color(0xff03a9f4),
    const Color(0xffe040fb),
    const Color(0xff4caf50),
  ];

  List<IconData> iconList = [
    Icons.add_shopping_cart_rounded,
    FontAwesomeIcons.solidMoneyBill1,
    Icons.phonelink_outlined,
    FeatherIcons.users,
    FontAwesomeIcons.handHoldingDollar,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkWhite,
      body: Consumer(builder: (context, ref, __) {
        final subscriptionData = ref.watch(subscriptionPlanProvider);
        return Scrollbar(
          controller: mainScroll,
          child: SingleChildScrollView(
            controller: mainScroll,
            scrollDirection: Axis.horizontal,
            child: Row(
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
                subscriptionData.when(data: (data) {
                  return Container(
                    width: MediaQuery.of(context).size.width < 1275 ? 1275 - 240 : MediaQuery.of(context).size.width - 240,
                    // width: context.width() < 1080 ? 1080 - 240 : MediaQuery.of(context).size.width - 240,
                    decoration: const BoxDecoration(color: kDarkWhite),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //_______________________________top_bar____________________________
                        const TopBar(),

                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height-220,
                            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: kWhiteTextColor),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lang.S.of(context).yourPackage,
                                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                  ),
                                  Divider(
                                    thickness: 1.0,
                                    color: kGreyTextColor.withOpacity(0.1),
                                  ),
                                  // const SizedBox(height: 10.0),
                                  // Text(
                                  //   lang.S.of(context).choseAplan,
                                  //   style: kTextStyle.copyWith(color: kGreyTextColor, fontWeight: FontWeight.bold, fontSize: 21.0),
                                  //   textAlign: TextAlign.center,
                                  // ),
                                  // const SizedBox(height: 20.0),
                                  // Center(
                                  //   child: SizedBox(
                                  //     width: context.width() < 1080 ? 1080 - 240 : MediaQuery.of(context).size.width - 240,
                                  //     height: 500,
                                  //     child:
                                  //
                                  //     ListView.builder(
                                  //       physics: const ClampingScrollPhysics(),
                                  //       shrinkWrap: true,
                                  //       scrollDirection: Axis.horizontal,
                                  //       itemCount: data.length,
                                  //       itemBuilder: (BuildContext context, int index) {
                                  //         return Padding(
                                  //           padding: const EdgeInsets.all(8.0),
                                  //           child: Stack(
                                  //             children: [
                                  //               SizedBox(
                                  //                 width: 260,
                                  //                 child: Card(
                                  //                   shape: RoundedRectangleBorder(
                                  //                     borderRadius: BorderRadius.circular(10.0),
                                  //                   ),
                                  //                   child: Column(
                                  //                     crossAxisAlignment: CrossAxisAlignment.start,
                                  //                     children: [
                                  //                       Image.asset(
                                  //                         'images/free.png',
                                  //                         height: 80.0,
                                  //                         width: 80.0,
                                  //                       ),
                                  //                       Padding(
                                  //                         padding: const EdgeInsets.all(20.0),
                                  //                         child: Column(
                                  //                           crossAxisAlignment: CrossAxisAlignment.start,
                                  //                           children: [
                                  //                             Text(
                                  //                               data[index].subscriptionName,
                                  //                               style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 25.0),
                                  //                             ),
                                  //                             const SizedBox(height: 6.0),
                                  //                             Column(
                                  //                               crossAxisAlignment: CrossAxisAlignment.start,
                                  //                               mainAxisSize: MainAxisSize.min,
                                  //                               children: [
                                  //                                 data[index].offerPrice > 0 ?  Text(
                                  //                                   data[index].offerPrice > 0 ? '$currency ${data[index].subscriptionPrice}' : '',
                                  //                                   style: const TextStyle(
                                  //                                     decoration: TextDecoration.lineThrough,
                                  //                                     fontSize: 18,
                                  //                                     color: Colors.grey,
                                  //                                   ),
                                  //                                 ): const SizedBox(height: 0,),
                                  //                                 Row(
                                  //                                   children: [
                                  //                                     Text(
                                  //                                       data[index].offerPrice > 0 ? '$currency${data[index].offerPrice}' : '$currency${data[index].subscriptionPrice}',
                                  //                                       style: kTextStyle.copyWith(color: colors[index % 3], fontSize: 25.0, fontWeight: FontWeight.bold),
                                  //                                     ),
                                  //                                     const SizedBox(width: 4.0),
                                  //                                     Text(
                                  //                                       '/${data[index].duration} Day',
                                  //                                       style: kTextStyle.copyWith(color: kTitleColor),
                                  //                                     ),
                                  //                                   ],
                                  //                                 )
                                  //                               ],
                                  //                             ),
                                  //                             const SizedBox(
                                  //                               height: 6.0,
                                  //                             ),
                                  //                             Text(
                                  //                               lang.S.of(context).allBasicFeatures,
                                  //                               style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 16.0),
                                  //                             ),
                                  //                             const SizedBox(
                                  //                               height: 6.0,
                                  //                             ),
                                  //                             Row(
                                  //                               mainAxisSize: MainAxisSize.min,
                                  //                               children: [
                                  //                                 Icon(
                                  //                                   Icons.check,
                                  //                                   color: colors[index % 3],
                                  //                                 ),
                                  //                                 const SizedBox(
                                  //                                   width: 4.0,
                                  //                                 ),
                                  //                                 currentSubscriptionPlan.subscriptionName == data[index].subscriptionName
                                  //                                     ? Text(
                                  //                                         data[index].saleNumber == -202
                                  //                                             ? 'Unlimited Sales'
                                  //                                             : 'Sales Limit (${currentSubscriptionPlan.saleNumber}/${data[index].saleNumber})',
                                  //                                         style: kTextStyle.copyWith(color: kTitleColor, fontSize: 12.0),
                                  //                                       )
                                  //                                     : Text(
                                  //                                         data[index].saleNumber == -202 ? 'Unlimited Sales' : '${data[index].saleNumber} Sales',
                                  //                                         style: kTextStyle.copyWith(color: kTitleColor, fontSize: 12.0),
                                  //                                       ),
                                  //                               ],
                                  //                             ),
                                  //                             const SizedBox(height: 6.0),
                                  //                             Row(
                                  //                               mainAxisSize: MainAxisSize.min,
                                  //                               children: [
                                  //                                 Icon(
                                  //                                   Icons.check,
                                  //                                   color: colors[index % 3],
                                  //                                 ),
                                  //                                 const SizedBox(width: 4.0),
                                  //                                 currentSubscriptionPlan.subscriptionName == data[index].subscriptionName
                                  //                                     ? Text(
                                  //                                         data[index].partiesNumber == -202
                                  //                                             ? 'Unlimited Purchases'
                                  //                                             : 'Purchases Limit (${currentSubscriptionPlan.partiesNumber}/${data[index].partiesNumber})',
                                  //                                         style: kTextStyle.copyWith(color: kTitleColor, fontSize: 12.0),
                                  //                                       )
                                  //                                     : Text(
                                  //                                         data[index].partiesNumber == -202 ? 'Unlimited Purchases' : '${data[index].partiesNumber} Purchases',
                                  //                                         style: kTextStyle.copyWith(color: kTitleColor, fontSize: 12.0),
                                  //                                       ),
                                  //                               ],
                                  //                             ),
                                  //                             const SizedBox(height: 6.0),
                                  //                             Row(
                                  //                               mainAxisSize: MainAxisSize.min,
                                  //                               children: [
                                  //                                 Icon(
                                  //                                   Icons.check,
                                  //                                   color: colors[index % 3],
                                  //                                 ),
                                  //                                 const SizedBox(
                                  //                                   width: 4.0,
                                  //                                 ),
                                  //                                 currentSubscriptionPlan.subscriptionName == data[index].subscriptionName
                                  //                                     ? Text(
                                  //                                         data[index].partiesNumber == -202
                                  //                                             ? 'Unlimited Parties'
                                  //                                             : 'Parties Limit (${currentSubscriptionPlan.partiesNumber}/${data[index].partiesNumber})',
                                  //                                         style: kTextStyle.copyWith(color: kTitleColor, fontSize: 12.0),
                                  //                                       )
                                  //                                     : Text(
                                  //                                         data[index].partiesNumber == -202 ? 'Unlimited Parties' : '${data[index].partiesNumber} Parties',
                                  //                                         style: kTextStyle.copyWith(color: kTitleColor, fontSize: 12.0),
                                  //                                       ),
                                  //                               ],
                                  //                             ),
                                  //                             const SizedBox(
                                  //                               height: 6.0,
                                  //                             ),
                                  //                             Row(
                                  //                               mainAxisSize: MainAxisSize.min,
                                  //                               children: [
                                  //                                 Icon(
                                  //                                   Icons.check,
                                  //                                   color: colors[index % 3],
                                  //                                 ),
                                  //                                 const SizedBox(
                                  //                                   width: 4.0,
                                  //                                 ),
                                  //                                 currentSubscriptionPlan.subscriptionName == data[index].subscriptionName
                                  //                                     ? Text(
                                  //                                         data[index].dueNumber == -202
                                  //                                             ? 'Unlimited Due Collection'
                                  //                                             : 'Due Collection Limit (${currentSubscriptionPlan.dueNumber}/${data[index].dueNumber})',
                                  //                                         style: kTextStyle.copyWith(color: kTitleColor, fontSize: 12.0),
                                  //                                       )
                                  //                                     : Text(
                                  //                                         data[index].dueNumber == -202 ? 'Unlimited Due Collection' : '${data[index].dueNumber} Due Collection',
                                  //                                         style: kTextStyle.copyWith(color: kTitleColor, fontSize: 12.0),
                                  //                                       ),
                                  //                               ],
                                  //                             ),
                                  //                             const SizedBox(
                                  //                               height: 6.0,
                                  //                             ),
                                  //                             Row(
                                  //                               mainAxisSize: MainAxisSize.min,
                                  //                               children: [
                                  //                                 Icon(
                                  //                                   Icons.check,
                                  //                                   color: colors[index % 3],
                                  //                                 ),
                                  //                                 const SizedBox(width: 4.0),
                                  //                                 Text(
                                  //                                   lang.S.of(context).unlimitedInvoice,
                                  //                                   style: kTextStyle.copyWith(color: kTitleColor, fontSize: 12.0),
                                  //                                 ),
                                  //                               ],
                                  //                             ),
                                  //                             const SizedBox(
                                  //                               height: 6.0,
                                  //                             ),
                                  //                             Row(
                                  //                               mainAxisSize: MainAxisSize.min,
                                  //                               children: [
                                  //                                 Icon(
                                  //                                   Icons.check,
                                  //                                   color: colors[index % 3],
                                  //                                 ),
                                  //                                 const SizedBox(width: 4.0),
                                  //                                 currentSubscriptionPlan.subscriptionName == data[index].subscriptionName
                                  //                                     ? Text(
                                  //                                         data[index].products == -202
                                  //                                             ? 'Unlimited Products'
                                  //                                             : 'Products Limit (${currentSubscriptionPlan.products}/${data[index].products})',
                                  //                                         style: kTextStyle.copyWith(color: kTitleColor, fontSize: 12.0),
                                  //                                       )
                                  //                                     : Text(
                                  //                                         data[index].products == -202 ? 'Unlimited Products' : '${data[index].products} Products',
                                  //                                         style: kTextStyle.copyWith(color: kTitleColor, fontSize: 12.0),
                                  //                                       ),
                                  //                               ],
                                  //                             ),
                                  //                             const SizedBox(
                                  //                               height: 10.0,
                                  //                             ),
                                  //                             Container(
                                  //                               padding: const EdgeInsets.all(6.0),
                                  //                               width: 200.0,
                                  //                               decoration: BoxDecoration(
                                  //                                 borderRadius: BorderRadius.circular(20.0),
                                  //                                 color: colors[index % 3],
                                  //                               ),
                                  //                               child: Row(
                                  //                                 mainAxisSize: MainAxisSize.min,
                                  //                                 mainAxisAlignment: MainAxisAlignment.center,
                                  //                                 children: [
                                  //                                   Text(
                                  //                                     lang.S.of(context).getStarted,
                                  //                                     style: kTextStyle.copyWith(color: white, fontWeight: FontWeight.bold),
                                  //                                   ),
                                  //                                   const SizedBox(
                                  //                                     width: 4.0,
                                  //                                   ),
                                  //                                   const Icon(
                                  //                                     Icons.arrow_forward_rounded,
                                  //                                     color: white,
                                  //                                   ),
                                  //                                 ],
                                  //                               ),
                                  //                             ).onTap(() async {
                                  //                               if (data[index].subscriptionPrice > 0) {
                                  //                                 EasyLoading.show(status: 'Loading');
                                  //                                 var paymentUrl = await paypalRepo.getPaymentUrl(
                                  //                                     data[index].subscriptionName, data[index].subscriptionPrice.toString(), Uri.base.toString());
                                  //                                 html.window.open(paymentUrl, '_self');
                                  //                                 EasyLoading.showSuccess('Done');
                                  //                               } else {
                                  //                                 PaymentSuccess.updateSubscription(await getUserID(), data[index].subscriptionName, context);
                                  //                               }
                                  //                             }).visible(
                                  //                                 currentSubscriptionPlan.subscriptionName != data[index].subscriptionName && data[index].subscriptionName != 'Free')
                                  //                           ],
                                  //                         ),
                                  //                       ),
                                  //                     ],
                                  //                   ),
                                  //                 ),
                                  //               ),
                                  //               ///__________Current Plan__________________________________________________________________________________
                                  //               Positioned(
                                  //                 top: 0,
                                  //                 right: 0,
                                  //                 child: Container(
                                  //                   decoration: const BoxDecoration(
                                  //                       color: kBlueTextColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
                                  //                   child: Center(
                                  //                     child: Padding(
                                  //                       padding: const EdgeInsets.all(10.0),
                                  //                       child: Column(
                                  //                         mainAxisSize: MainAxisSize.min,
                                  //                         children: [
                                  //                            Text(
                                  //                             lang.S.of(context).currentPlan,
                                  //                             style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                  //                           ),
                                  //                           Text(
                                  //                             'Expires in ${(DateTime.parse(currentSubscriptionPlan.subscriptionDate).difference(DateTime.now()).inDays.abs() - currentSubscriptionPlan.duration).abs()} Days',
                                  //                             style: kTextStyle.copyWith(color: kWhiteTextColor),
                                  //                             maxLines: 3,
                                  //                           )
                                  //                         ],
                                  //                       ),
                                  //                     ),
                                  //                   ),
                                  //                 ),
                                  //               ).visible(currentSubscriptionPlan.subscriptionName == data[index].subscriptionName)
                                  //             ],
                                  //           ),
                                  //         );
                                  //       },
                                  //     ),
                                  //   ),
                                  // ),

                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10.0),
                                          height: 80,
                                          decoration: BoxDecoration(color: kMainColor.withOpacity(0.2), borderRadius: const BorderRadius.all(Radius.circular(10))),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    lang.S.of(context).freePlan,
                                                    style: const TextStyle(fontSize: 18),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        lang.S.of(context).yourAreUsing,
                                                        style: const TextStyle(fontSize: 14),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      Text(
                                                        lang.S.of(context).freePackage,
                                                        style: const TextStyle(fontSize: 14, color: kMainColor, fontWeight: FontWeight.bold),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(width: 20.0),
                                              Container(
                                                height: 63,
                                                width: 63,
                                                decoration: const BoxDecoration(
                                                  color: kMainColor,
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(50),
                                                  ),
                                                ),
                                                child: Center(
                                                    child: Text(
                                                  '${(DateTime.parse(subscriptionModel.subscriptionDate).difference(DateTime.now()).inDays.abs() - subscriptionModel.duration).abs()} \nDays Left',
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(fontSize: 12, color: Colors.white),
                                                )),
                                              ),
                                            ],
                                          ),
                                        ).visible(initialSelectedPackage == 'Free'),
                                        Container(
                                          padding: const EdgeInsets.all(10.0),
                                          height: 80,
                                          decoration: BoxDecoration(color: kMainColor.withOpacity(0.2), borderRadius: const BorderRadius.all(Radius.circular(10))),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    lang.S.of(context).premiumPlan,
                                                    style: const TextStyle(fontSize: 18),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        lang.S.of(context).yourAreUsing,
                                                        style: const TextStyle(fontSize: 14),
                                                      ),
                                                      Text(
                                                        '$initialSelectedPackage',
                                                        style: const TextStyle(fontSize: 14, color: kMainColor, fontWeight: FontWeight.bold),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(width: 20.0),
                                              Container(
                                                height: 63,
                                                width: 63,
                                                decoration: const BoxDecoration(
                                                  color: kMainColor,
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(50),
                                                  ),
                                                ),
                                                child: Center(
                                                    child: Text(
                                                  '${(DateTime.parse(subscriptionModel.subscriptionDate).difference(DateTime.now()).inDays.abs() - subscriptionModel.duration).abs()} \nDays Left',
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(fontSize: 12, color: Colors.white),
                                                )),
                                              ).visible(subscriptionModel.subscriptionName != 'Lifetime'),
                                            ],
                                          ),
                                        ).visible(initialSelectedPackage != 'Free'),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  //______________________________________________Package_Features
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      lang.S.of(context).packageFeature,
                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: nameList.length,
                                        padding: const EdgeInsets.all(10.0),
                                        itemBuilder: (_, i) {
                                          return Padding(
                                            padding: const EdgeInsets.only(right: 8.0),
                                            child: Card(
                                              elevation: 1.0,
                                              shadowColor: Colors.grey.shade700,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(2.0),
                                              ),
                                              child: Container(
                                                padding: const EdgeInsets.all(10.0),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8.0),
                                                  color: Colors.white,
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: kDarkWhite,
                                                      spreadRadius: 1.0,
                                                      blurRadius: 7,
                                                      offset: Offset(0, 2),
                                                    )
                                                  ],
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          padding: const EdgeInsets.all(8.0),
                                                          decoration: BoxDecoration(
                                                            color: colorList[i].withOpacity(0.1),
                                                            shape: BoxShape.rectangle,
                                                            borderRadius: BorderRadius.circular(4),
                                                          ),
                                                          child: Icon(iconList[i], color: colorList[i]),
                                                        ),
                                                        const SizedBox(width: 8),
                                                        Text(
                                                          nameList[i],
                                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 10.0),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          lang.S.of(context).remaining,
                                                          style: const TextStyle(color: kGreyTextColor),
                                                        ),
                                                        const SizedBox(width: 20),
                                                        initialSelectedPackage == 'Free'
                                                            ? Text(
                                                          initialPackageService?[i] == '-202' ? 'Unlimited':  '(${initialPackageService?[i] ?? ''}/50)',
                                                                style: const TextStyle(color: Colors.grey),
                                                              )
                                                            : Text(
                                                                lang.S.of(context).unlimited,
                                                                style: const TextStyle(color: Colors.grey),
                                                              ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                  const SizedBox(height: 15),
                                  //______________________________________________Package_Features
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      lang.S.of(context).forUnlimitedUses,
                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                    ),
                                  ).visible(initialSelectedPackage != 'Lifetime'),
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
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const PurchasePlan(
                                                initialSelectedPackage: 'Yearly',
                                                initPackageValue: 0,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          lang.S.of(context).updateNow,
                                          style: kTextStyle.copyWith(color: kWhiteTextColor, fontSize: 18.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Footer(),
                      ],
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
