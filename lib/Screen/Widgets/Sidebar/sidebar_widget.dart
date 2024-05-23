// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Screen/Due%20List/due_list_screen.dart';
import 'package:salespro_admin/Screen/Home/home_screen.dart';
import 'package:salespro_admin/Screen/Inventory%20Sales/inventory_sales.dart';
import 'package:salespro_admin/Screen/Ledger%20Screen/ledger_screen.dart';
import 'package:salespro_admin/Screen/LossProfit/lossProfit_screen.dart';
import 'package:salespro_admin/Screen/POS%20Sale/pos_sale.dart';
import 'package:salespro_admin/Screen/Product/product.dart';
import 'package:salespro_admin/Screen/Purchase/purchase.dart';
import 'package:salespro_admin/Screen/Stock%20List/stock_list_screen.dart';
import 'package:salespro_admin/Screen/daily_tanasaction.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../../Repository/subscriptionPlanRepo.dart';
import '../../../const.dart';
import '../../../model/subscription_model.dart';
import '../../Subscription/subscription_plan_page.dart';
import '../../Customer List/customer_list.dart';
import '../../Expenses/expenses_list.dart';
import '../../Income/income_list.dart';
import '../../Purchase List/purchase_list.dart';
import '../../Quotation List/quotation_list.dart';
import '../../Reports/report_screen.dart';
import '../../Sale List/sale_list.dart';
import '../../Sales Return/sales_returns_list.dart';
import '../../Supplier List/supplier_list.dart';
import '../../User Role System/user_role_screen.dart';
import '../../WareHouse/ware_house_list.dart';
import '../Constant Data/constant.dart';

List<String> getTitleList({required BuildContext context}) {
  List<String> titleList = [
    lang.S.of(context).dashBoard,
    lang.S.of(context).sales,
    lang.S.of(context).purchase,
    lang.S.of(context).product,
    lang.S.of(context).supplierList,
    lang.S.of(context).customerList,
    lang.S.of(context).dueList,
    lang.S.of(context).ledger,
    lang.S.of(context).lossOrProfit,
    lang.S.of(context).expense,
    lang.S.of(context).income,
    lang.S.of(context).transaction,
    lang.S.of(context).reports,
    // 'Warranty',
    // 'SMS',
    "Stock List",
    lang.S.of(context).subciption,
    lang.S.of(context).userRole,
    "Omborlar",
  ];
  return titleList;
}

String selected = 'Dashboard';

List<IconData> iconList = [
  Icons.dashboard,
  Icons.style,
  MdiIcons.cartVariant,
  MdiIcons.packageVariant,
  MdiIcons.accountMultiple,
  MdiIcons.accountMultiple,
  Icons.list_alt,
  Icons.pie_chart,
  Icons.add_chart_outlined,
  MdiIcons.wallet,
  Icons.insert_chart,
  Icons.account_balance_outlined,
  FontAwesomeIcons.fileLines,
  Icons.featured_play_list_rounded,
  // FontAwesomeIcons.screwdriver,
  // Icons.sms,
  MdiIcons.youtubeSubscription,
  FontAwesomeIcons.usersRectangle,
  MdiIcons.stocking,
];

List<String> screenList = [
  MtHomeScreen.route,
  PosSale.route,
  Purchase.route,
  Product.route,
  SupplierList.route,
  CustomerList.route,
  DueList.route,
  LedgerScreen.route,
  LossProfitScreen.route,
  ExpensesList.route,
  IncomeList.route,
  DailyTransactionScreen.route,
  SaleReports.route,
  StockListScreen.route,
  // WarrantyScreen.route,
  // SMSHome.route,
  // NidVerification.route,
  SubscriptionPage.route,
  UserRoleScreen.route,
  WareHouseList.route,
];

class SideBarWidget extends StatefulWidget {
  const SideBarWidget({super.key, required this.index, required this.isTab, this.subManu});
  final int index;
  final bool isTab;

  final String? subManu;

  @override
  State<SideBarWidget> createState() => _SideBarWidgetState();
}

class _SideBarWidgetState extends State<SideBarWidget> {
  CurrentSubscriptionPlanRepo currentSubscriptionPlanRepo = CurrentSubscriptionPlanRepo();

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
  void checkSubscriptionData() async {
    subscriptionModel = await currentSubscriptionPlanRepo.getCurrentSubscriptionPlans();

    setState(() {
      subscriptionModel;
    });
  }

  List<String> titleList = [];

  @override
  void initState() {
    checkSubscriptionData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    titleList = getTitleList(context: context);
    // getUserDataFromLocal();
    return Container(
      height: context.height(),
      decoration: const BoxDecoration(color: kDarkGreyColor),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(color: kDarkGreyColor),
              child: ListTile(
                leading:  CircleAvatar(
                  radius: 16.0,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage(sideBarLogo),
                ),
                title: Text(
                  appsName,
                  style: kTextStyle.copyWith(color: kWhiteTextColor),
                ),
                trailing: const Icon(
                  FeatherIcons.chevronRight,
                  color: Colors.white,
                  size: 18.0,
                ),
              ),
            ),
            const Divider(
              thickness: 1.0,
              color: kGreyTextColor,
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: titleList.length,
                itemBuilder: (_, i) {
                  return titleList[i] == lang.S.of(context).sales || titleList[i] == lang.S.of(context).purchase
                      ? saleExpandedManu(selected: widget.subManu ?? '', manu: titleList[i])
                      : Container(
                          color: widget.index == i ? kMainColor : null,
                          child: ListTile(
                            selectedTileColor: kBlueTextColor,
                            onTap: (() async {
                              if (await checkUserRolePermission(type: screenList[i])) {
                                Navigator.of(context).pushNamed(screenList[i]);
                              }
                            }),
                            leading: Icon(iconList[i], color: kWhiteTextColor),
                            title: Text(
                              titleList[i],
                              style: kTextStyle.copyWith(color: kWhiteTextColor),
                            ),
                            trailing: const Icon(
                              FeatherIcons.chevronRight,
                              color: Colors.white,
                              size: 18.0,
                            ),
                          ),
                        ).visible(!((isSubUser && titleList[i] == 'User Role') || (isSubUser && titleList[i] == 'Subscription')));
                }),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: MediaQuery.of(context).size.width * .50,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: kMainColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.start,
                      children: [
                        const Icon(
                          FontAwesomeIcons.crown,
                          color: kYellowColor,
                          size: 30.0,
                        ),
                        const SizedBox(width: 10.0),
                        Text(
                          'Your are using ${subscriptionModel.subscriptionName} package',
                          style: kTextStyle.copyWith(color: kWhiteTextColor),
                          maxLines: 3,
                        ),
                        Text(
                          'Expires in ${(DateTime.parse(subscriptionModel.subscriptionDate).difference(DateTime.now()).inDays.abs() - subscriptionModel.duration).abs()} Days',
                          style: kTextStyle.copyWith(color: kWhiteTextColor),
                          maxLines: 3,
                        ).visible(subscriptionModel.subscriptionName != 'Lifetime'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          lang.S.of(context).upgradeOnMobileApp,
                          style: kTextStyle.copyWith(color: kYellowColor, fontWeight: FontWeight.bold),
                        ),
                        const Icon(
                          FontAwesomeIcons.arrowRight,
                          color: kYellowColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget saleExpandedManu({required String selected, required String manu}) {
    String selectedItems = selected;
    if (manu == lang.S.of(context).sales) {
      return StatefulBuilder(builder: (context, manuSetState) {
        return ExpansionTile(
          initiallyExpanded: selectedItems == lang.S.of(context).POSSale ||
                  selectedItems == lang.S.of(context).inventorySales ||
                  selectedItems == lang.S.of(context).saleList ||
                  selectedItems == 'Sale Return' ||
                  selectedItems == 'Quotation List'
              ? true
              : false,
          iconColor: Colors.white,
          collapsedIconColor: Colors.white,
          title: Text(
            lang.S.of(context).sales,
            style: const TextStyle(color: Colors.white),
          ),
          leading: const Icon(
            Icons.point_of_sale_sharp,
            color: Colors.white,
          ), //add icon
          childrenPadding: const EdgeInsets.only(left: 20), //children padding
          children: [
            ///_______________POS Sale_________________________________________________
            Container(
              color: selectedItems == lang.S.of(context).sales ? kBlueTextColor : null,
              child: ListTile(
                // leading: const Icon(
                //   Icons.point_of_sale_sharp,
                //   color: Colors.white,
                // ),
                title: Text(
                  lang.S.of(context).POSSale,
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: const Icon(
                  Icons.arrow_right,
                  color: Colors.white,
                ),
                onTap: () {
                  manuSetState(() {
                    selectedItems = lang.S.of(context).POSSale;
                    Navigator.pushNamed(context, PosSale.route);
                  });
                  //action on press
                },
              ),
            ),

            ///----------------inventory sales---------------------
            Container(
              color: selectedItems == lang.S.of(context).inventorySales ? kBlueTextColor : null,
              child: ListTile(
                // leading: const Icon(
                //   Icons.list,
                //   color: Colors.white,
                // ),
                title: Text(
                  lang.S.of(context).inventorySales,
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: const Icon(
                  Icons.arrow_right,
                  color: Colors.white,
                ),
                onTap: () {
                  manuSetState(() {
                    selectedItems = lang.S.of(context).inventorySales;
                    Navigator.pushNamed(context, InventorySales.route);
                  });
                },
              ),
            ),

            ///_______________Sales List_________________________________________________
            Container(
              color: selectedItems == lang.S.of(context).saleList ? kBlueTextColor : null,
              child: ListTile(
                // leading: const Icon(
                //   Icons.list,
                //   color: Colors.white,
                // ),
                title: Text(
                  lang.S.of(context).saleList,
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: const Icon(
                  Icons.arrow_right,
                  color: Colors.white,
                ),
                onTap: () async {
                  manuSetState(() async {
                    selectedItems = lang.S.of(context).saleList;
                    if (await checkUserRolePermission(type: 'sale')) Navigator.pushNamed(context, SaleList.route);
                  });
                },
              ),
            ),

            ///_______________sales_returns_________________________________________________
            Container(
              color: selectedItems == lang.S.of(context).saleReturn ? kBlueTextColor : null,
              child: ListTile(
                // leading: const Icon(
                //   Icons.assignment_return_outlined,
                //   color: Colors.white,
                // ),
                title: Text(
                  lang.S.of(context).saleReturn,
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: const Icon(
                  Icons.arrow_right,
                  color: Colors.white,
                ),
                onTap: () {
                  manuSetState(() {
                    selectedItems = lang.S.of(context).saleReturn;
                    Navigator.pushNamed(context, SalesReturn.route);
                  });
                },
              ),
            ),

            ///_______________Quotation List_________________________________________________

            Container(
              color: selectedItems == lang.S.of(context).quotationList ? kBlueTextColor : null,
              child: ListTile(
                // leading: const Icon(
                //   Icons.list_alt_sharp,
                //   color: Colors.white,
                // ),
                title: Text(
                  lang.S.of(context).quotationList,
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: const Icon(
                  Icons.arrow_right,
                  color: Colors.white,
                ),
                onTap: () {
                  manuSetState(() {
                    selectedItems = lang.S.of(context).quotationList;
                    Navigator.pushNamed(context, QuotationList.route);
                  });
                },
              ),
            ),
            //more child menu
          ],
        );
      });
    } else {
      return StatefulBuilder(builder: (context, manuSetState) {
        return ExpansionTile(
          initiallyExpanded: selectedItems == lang.S.of(context).purchaseList ? true : false,
          iconColor: Colors.white,
          collapsedIconColor: Colors.white,
          title: Text(
            lang.S.of(context).purchase,
            style: const TextStyle(color: Colors.white),
          ),
          leading: const Icon(
            Icons.shopping_cart_checkout,
            color: Colors.white,
          ), //add icon
          childrenPadding: const EdgeInsets.only(left: 20), //children padding
          children: [
            ///_______________POS Sale_________________________________________________
            Container(
              color: selectedItems == lang.S.of(context).purchase ? kBlueTextColor : null,
              child: ListTile(
                // leading: const Icon(
                //   Icons.point_of_sale_sharp,
                //   color: Colors.white,
                // ),
                title: Text(
                  lang.S.of(context).purchase,
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: const Icon(
                  Icons.arrow_right,
                  color: Colors.white,
                ),
                onTap: () {
                  manuSetState(() async {
                    selectedItems = lang.S.of(context).purchase;
                    if (await checkUserRolePermission(type: 'purchase')) Navigator.pushNamed(context, Purchase.route);
                  });
                  //action on press
                },
              ),
            ),

            ///_______________Sales List_________________________________________________

            Container(
              color: selectedItems == lang.S.of(context).purchaseList ? kBlueTextColor : null,
              child: ListTile(
                // leading: const Icon(
                //   Icons.list,
                //   color: Colors.white,
                // ),
                title: Text(
                  lang.S.of(context).purchaseList,
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: const Icon(
                  Icons.arrow_right,
                  color: Colors.white,
                ),
                onTap: () {
                  manuSetState(() async {
                    selectedItems = lang.S.of(context).purchaseList;
                    if (await checkUserRolePermission(type: 'purchaseList')) Navigator.pushNamed(context, PurchaseList.route);
                  });
                },
              ),
            ),
            //more child menu
          ],
        );
      });
    }
  }
}
