// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Screen/Widgets/Constant%20Data/constant.dart';
import 'package:salespro_admin/Screen/Widgets/TopBar/top_bar_widget.dart';
import 'package:salespro_admin/model/home_report_model.dart';
import 'package:salespro_admin/model/product_model.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../Provider/all_expanse_provider.dart';
import '../../Provider/customer_provider.dart';
import '../../Provider/income_provider.dart';
import '../../Provider/product_provider.dart';
import '../../Provider/purchase_transaction_single.dart';
import '../../Provider/transactions_provider.dart';
import '../../const.dart';
import '../../currency.dart';
import '../../model/add_to_cart_model.dart';
import '../../model/customer_model.dart';
import '../../model/due_transaction_model.dart';
import '../../model/expense_model.dart';
import '../../model/income_modle.dart';
import '../../model/sale_transaction_model.dart';
import '../../subscription.dart';
import '../Customer List/add_customer.dart';
import '../POS Sale/pos_sale.dart';
import '../Product/add_product.dart';
import '../Product/product.dart';
import '../Purchase/purchase.dart';
import '../Sale List/sale_list.dart';
import '../Supplier List/supplier_list.dart';
import '../Widgets/Footer/footer.dart';
import '../Widgets/Sidebar/sidebar_widget.dart';
import '../Widgets/topselling_table_widget.dart';
import '../Widgets/total_count_widget.dart';

class MtHomeScreen extends StatefulWidget {
  const MtHomeScreen({super.key});

  static const String route = '/dashBoard';

  @override
  State<MtHomeScreen> createState() => _MtHomeScreenState();
}

class _MtHomeScreenState extends State<MtHomeScreen> {
  int totalStock = 0;
  double totalSalePrice = 0;
  double totalParPrice = 0;

  List<String> status = [
    'This Month',
    'Last Month',
    'April',
    'March',
    'February',
  ];

  String selectedStatus = 'This Month';

  DropdownButton<String> getStatus() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String des in status) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(des),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      items: dropDownItems,
      value: selectedStatus,
      onChanged: (value) {
        setState(() {
          selectedStatus = value!;
        });
      },
    );
  }

  List<String> dates = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
  ];

  String selectedDate = 'January';

  DropdownButton<String> selectDate() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String des in dates) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(des),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      items: dropDownItems,
      value: selectedDate,
      onChanged: (value) {
        setState(() {
          selectedDate = value!;
        });
      },
    );
  }

  bool isOn = false;

  double calculateTotal(List<dynamic> purchases) {
    double totalPurchase = 0.0;
    for (var element in purchases) {
      totalPurchase += element.totalAmount!;
    }
    return totalPurchase;
  }

  double calculateTotalSale(List<SaleTransactionModel> sales) {
    double totalSale = 0.0;
    for (var element in sales) {
      totalSale += element.totalAmount!;
    }
    return totalSale;
  }

  List<HomeReport> getLastCustomerName(List<SaleTransactionModel> model) {
    List<HomeReport> customers = [];
    model.reversed.toList().forEach((element) {
      HomeReport report = HomeReport(element.customerName, element.totalAmount.toString());
      customers.add(report);
    });
    return customers;
  }

  List<HomeReport> getLastPurchaserName(List<dynamic> model) {
    List<HomeReport> customers = [];
    model.reversed.toList().forEach((element) {
      HomeReport report = HomeReport(element.customerName, element.totalAmount.toString());
      customers.add(report);
    });
    return customers;
  }

  List<HomeReport> getLastDueName(List<DueTransactionModel> model) {
    List<HomeReport> customers = [];
    model.reversed.toList().forEach((element) {
      HomeReport report = HomeReport(element.customerName, element.payDueAmount.toString());
      customers.add(report);
    });
    return customers;
  }

  List<TopSellReport> getTopSellingReport(List<AddToCartModel> model) {
    return model
        .map(
          (element) => TopSellReport(
            element.productName,
            element.productPurchasePrice.toString(),
            element.productBrandName,
            element.quantity.toString(),
            element.productImage,
          ),
        )
        .toList();
  }

  bool isAfterFirstDayOfCurrentMonth(DateTime date) {
    return date.isAfter(firstDayOfCurrentMonth);
  }

  // List<TopCustomer> getTopCustomer(List<CustomerModel> model) {
  //   List<TopCustomer> customers = [];
  //   model.reversed.toList().forEach((element) {
  //     TopCustomer report = TopCustomer(element.customerName, element.phoneNumber, element.dueAmount, element.profilePicture);
  //     customers.add(report);
  //   });
  //   return customers;
  // }

  List<TopCustomer> getTopCustomer(List<CustomerModel> model) {
    return model
        .map(
          (element) => TopCustomer(
            element.customerName,
            element.openingBalance.toString() ?? '',
            element.phoneNumber,
            element.profilePicture.toString(),
          ),
        )
        .toList();
  }

  List<String> items = ['Today', 'Last 7 Days', 'This Month', 'This Year'];

  List<String> baseFlagsCode = [
    'US',
    'ES',
    'IN',
    'SA',
    'FR',
    'BD',
    'TR',
    'CN',
    'JP',
    'RO',
    'DE',
    'VN',
    'IT',
    'TH',
    'PT',
    'IL',
    'PL',
    'HU',
    'FI',
    'KR',
    'MY',
    'ID',
    'UA',
    'BA',
    'GR',
    'NL',
    'Pk',
    'LK',
    'IR',
    'RS',
    'KH',
    'LA',
    'RU',
    'IN',
    'IN',
    'IN',
    'ZA',
    'CZ',
    'SE',
    'SK',
    'TZ',
    'AL',
    'DK',
    'AZ',
    'KZ',
    'HR',
    'NP'
  ];
  List<String> countryList = [
    'English',
    'Spanish',
    'Hindi',
    'Arabic',
    'France',
    'Bengali',
    'Turkish',
    'Chinese',
    'Japanese',
    'Romanian',
    'Germany',
    'Vietnamese',
    'Italian',
    'Thai',
    'Portuguese',
    'Hebrew',
    'Polish',
    'Hungarian',
    'Finland',
    'Korean',
    'Malay',
    'Indonesian',
    'Ukrainian',
    'Bosnian',
    'Greek',
    'Dutch',
    'Urdu',
    'Sinhala',
    'Persian',
    'Serbian',
    'Khmer',
    'Lao',
    'Russian',
    'Kannada',
    'Marathi',
    'Tamil',
    'Afrikaans',
    'Czech',
    'Swedish',
    'Slovak',
    'Swahili',
    'Albanian',
    'Danish',
    'Azerbaijani',
    'Kazakh',
    'Croatian',
    'Nepali'
  ];
  String selectedCountry = 'English';

  List<String> currencyList = [
    'USD',
    'TK',
    'Rupee',
    'Riyal',
  ];
  String selectedCurrency = 'USD';

  Future<void> saveData(String data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('savedLanguage', data);
  }

  getData() async {
    final prefs = await SharedPreferences.getInstance();
    selectedCountry = prefs.getString('savedLanguage') ?? selectedCountry;
    setState(() {});
  }

  Future<void> saveDataOnLocal({required String key, required String type, required dynamic value}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (type == 'bool') prefs.setBool(key, value);
    if (type == 'string') prefs.setString(key, value);
  }

  String? dropdownValue = 'Tsh (TZ Shillings)';
  List<IconData> iconsList = [
    MdiIcons.accountGroupOutline,
    MdiIcons.accountGroupOutline,
    MdiIcons.fileChartOutline,
    MdiIcons.cart,
    MdiIcons.textBox,
    Icons.post_add_outlined,
  ];

  List<String> titleList = [
    'Add Client',
    'Add Supplier',
    'Create Product',
    'Create Sale',
    'Create Purchase',
    'Add Quotation',
  ];

  Future<void> addUser() async {
    if (await Subscription.subscriptionChecker(item: SupplierList.route)) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return const AddCustomer(
              typeOfCustomerAdd: 'Buyer',
              listOfPhoneNumber: [],
              sideBarNumber: 5,
            );
          });
    } else {
      EasyLoading.showError('Update your plan first\nAdd Customer limit is over.');
    }
  }

  Future<void> addSupplier() async {
    if (await Subscription.subscriptionChecker(item: SupplierList.route)) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return const AddCustomer(
              typeOfCustomerAdd: 'Supplier',
              listOfPhoneNumber: [],
              sideBarNumber: 5,
            );
          });
    } else {
      EasyLoading.showError('Update your plan first\nAdd Customer limit is over.');
    }
  }

  // Future<void> createProduct() async {
  //   if (await Subscription.subscriptionChecker(item: Product.route)) {
  //     const AddProduct(
  //       allProductsCodeList: [],
  //       allProductsNameList: [],
  //       sideBarNumber: 3, warehouseID: [],
  //     ).launch(context);
  //   } else {
  //     EasyLoading.showError(lang.S.of(context).updateYourPlanFirst);
  //   }
  // }

  Future<void> addSales() async {
    if (await Subscription.subscriptionChecker(item: PosSale.route)) {
      Navigator.pushNamed(context, PosSale.route);
    } else {
      EasyLoading.showError(lang.S.of(context).updateYourPlanFirst);
    }
  }

  Future<void> addPurchase() async {
    if (await Subscription.subscriptionChecker(item: Purchase.route)) {
      Navigator.pushNamed(context, Purchase.route);
    } else {
      EasyLoading.showError(lang.S.of(context).updateYourPlanFirst);
    }
  }

  final ScrollController mainSideScroller = ScrollController();

  double totalProfitCurrentMonth = 0;
  double totalProfitPreviousMonth = 0;
  double totalLoss = 0;
  static DateTime fromDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  static DateTime toDate = DateTime.now();
  static String selectedIndex = 'Today';

  Future<void> _refresh() {
    return getUserID().then((user) {
      setState(() => user = user);
    });
  }

  bool isFirstTime = true;

  int i = 0;

//__________________________________Sale_Statistics__________________

  ScrollController scrollController = ScrollController();
  List<SaleTransactionModel> totalSaleOfYear = [];
  List<SaleTransactionModel> saleCountOfcurrentMonth = [];
  List<SaleTransactionModel> saleCountOfLastMonth = [];
  List<SaleTransactionModel> saleCountOfLastYear = [];
  double totalSaleOfCurrentYear = 0;
  double totalSaleOfPreviousYear = 0;
  double totalSaleOfCurrentMonth = 0;
  List<double> monthlySale = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  List<int> dailySaleOfCurrentMonth = [];
  List<int> dailySale = [];
  double totalSaleOfLastMonth = 0;
  List<SaleTransactionModel> saleList = [];

  //__________________________________Expense_Statistics__________________

  List<ExpenseModel> totalExpenseOfYear = [];
  List<ExpenseModel> expenseCountOfCurrentMonth = [];
  List<ExpenseModel> expenseCountOfLastMonth = [];
  List<ExpenseModel> expenseCountOfLastYear = [];
  double totalExpenseOfCurrentYear = 0;
  double totalExpenseOfPreviousYear = 0;
  double totalExpenseOfCurrentMonth = 0;
  List<double> monthlyExpense = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  List<int> dailyExpenseOfCurrentMonth = [];
  List<int> dailyExpense = [];
  double totalExpenseOfLastMonth = 0;
  List<ExpenseModel> expenseList = [];

  //__________________________________income_Statistics__________________

  List<IncomeModel> totalIncomeOfYear = [];
  List<IncomeModel> incomeCountOfCurrentMonth = [];
  List<IncomeModel> incomeCountOfLastMonth = [];
  List<IncomeModel> iCountOfLastYear = [];
  double totalIncomeOfCurrentYear = 0;
  double totalIncomeOfPreviousYear = 0;
  double totalIncomeOfCurrentMonth = 0;
  List<double> monthlyIncome = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  List<int> dailyIncomeOfCurrentMonth = [];
  List<int> dailyIncome = [];
  double totalIncomeOfLastMonth = 0;
  List<IncomeModel> incomeList = [];
  List<SaleTransactionModel> totalSaleList = [];
  List<SaleTransactionModel> recentFive = [];

  double totalPaid = 0;

  @override
  void initState() {
    getAllTotal();
    getData();
    selectedCountry;
    Subscription.getUserLimitsData(context: context, wannaShowMsg: true);
    for (int i = 0; i < DateTime(currentDate.year, currentDate.month + 1, 0).day; i++) {
      dailySaleOfCurrentMonth.add(0);
    }
    for (int i = 0; i < DateTime(currentDate.year, currentDate.month + 1, 0).day; i++) {
      dailySale.add(0);
    }
    for (int i = 0; i < DateTime(currentDate.year, currentDate.month + 1, 0).day; i++) {
      dailyExpenseOfCurrentMonth.add(0);
    }
    for (int i = 0; i < DateTime(currentDate.year, currentDate.month + 1, 0).day; i++) {
      dailyExpense.add(0);
    }
    super.initState();
  }

  List<SaleTransactionModel> shopList = [];

  //__________________top_purchase_report_________________________________________

  List<TopPurchaseReport> getTopPurchaseReport(List<ProductModel> model) {
    return model
        .map(
          (element) => TopPurchaseReport(
            element.productName,
            element.productPurchasePrice.toString() ?? '',
            element.productCategory,
            element.productPicture,
            element.productStock,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    i++;
    getUserDataFromLocal();
    return SafeArea(
      child: Scaffold(
        backgroundColor: kbgColor,
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 240,
                child: SideBarWidget(
                  index: 0,
                  isTab: false,
                ),
              ),
              SizedBox(
                // width: context.width() < 1000 ? 1000 - 240 : MediaQuery.of(context).size.width - 240,
                width: MediaQuery.of(context).size.width < 1275 ? 1275 - 240 : MediaQuery.of(context).size.width - 240,
                child: SingleChildScrollView(
                  child: Container(
                    decoration: const BoxDecoration(color: kDarkWhite),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //_______________________________________topBar_____________________________________
                        const TopBar(),
                        Consumer(
                          builder: (_, ref, watch) {
                            AsyncValue<List<SaleTransactionModel>> transactionReport = ref.watch(transitionProvider);
                            final incomes = ref.watch(incomeProvider);
                            final expenses = ref.watch(expenseProvider);
                            final purchaseTransactionReport = ref.watch(purchaseTransitionProviderSIngle);
                            return Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [


                                        //________________________________________top_five_table_______________________
                                        const SizedBox(height: 20),
                                        transactionReport.when(data: (topSell) {
                                          List<AddToCartModel> saleProductList = [];
                                          List<CustomerModel> currentMonthCustomerList = [];
                                          bool isContain({required AddToCartModel element}) {
                                            for (var p in saleProductList) {
                                              if (p.productName == element.productName && p.productId == element.productId) {
                                                print(p.productName);
                                                p.quantity += element.quantity;
                                                return true;
                                              }
                                            }
                                            return false;
                                          }

                                          bool isContainCustomer({required SaleTransactionModel element}) {
                                            for (var p in currentMonthCustomerList) {
                                              if (p.customerName == element.customerName && p.phoneNumber == element.customerPhone) {
                                                p.openingBalance = (double.parse(p.openingBalance) + double.parse(element.totalAmount.toString())).toString();

                                                return true;
                                              }
                                            }
                                            return false;
                                          }

                                          for (var element in topSell) {
                                            final saleData = DateTime.tryParse(element.purchaseDate.toString()) ?? DateTime.now();
                                          }

                                          for (var element in topSell) {
                                            final saleData = DateTime.tryParse(element.purchaseDate.toString()) ?? DateTime.now();
                                            if (isAfterFirstDayOfCurrentMonth(saleData)) {
                                              ///___For_Top_Customer____________________
                                              if (!isContainCustomer(element: element)) {
                                                currentMonthCustomerList.add(
                                                  CustomerModel(
                                                    customerName: element.customerName,
                                                    phoneNumber: element.customerPhone,
                                                    type: element.customerType,
                                                    profilePicture: element.customerImage,
                                                    emailAddress: '',
                                                    customerAddress: element.customerAddress,
                                                    dueAmount: element.dueAmount.toString(),
                                                    openingBalance: element.totalAmount.toString(),
                                                    remainedBalance: element.dueAmount.toString(),
                                                  ),
                                                );
                                              }

                                              ///____Top_sealing_product______________________
                                              for (var product in element.productList!) {
                                                if (!isContain(element: product)) {
                                                  AddToCartModel a = AddToCartModel(
                                                    productPurchasePrice: product.productPurchasePrice,
                                                    productImage: product.productImage,
                                                    productBrandName: product.productBrandName,
                                                    productDetails: product.productDetails,
                                                    productId: product.productId,
                                                    productName: product.productName,
                                                    warehouseName: product.warehouseName,
                                                    warehouseId: product.warehouseId,
                                                    productWarranty: product.productWarranty,
                                                    quantity: product.quantity,
                                                    serialNumber: product.serialNumber,
                                                    stock: product.stock,
                                                    subTotal: product.subTotal,
                                                    uniqueCheck: product.uniqueCheck,
                                                    unitPrice: product.unitPrice,
                                                    uuid: product.uuid,
                                                    itemCartIndex: product.itemCartIndex,
                                                  );
                                                  saleProductList.add(a);
                                                }
                                              }
                                            }
                                          }

                                          saleProductList.sort(
                                            (a, b) {
                                              return b.quantity.compareTo(a.quantity);
                                            },
                                          );
                                          currentMonthCustomerList.sort(
                                            (a, b) {
                                              return double.parse(b.openingBalance).compareTo(double.parse(a.openingBalance));
                                            },
                                          );

                                          return Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              //__________________________________________Top_selling_product______
                                              Expanded(
                                                flex: 1,
                                                child: TopSellingProduct(
                                                  report: getTopSellingReport(saleProductList),
                                                ),
                                              ),
                                              const SizedBox(width: 20.0),
                                              //__________________________________________Top_Customer____________
                                              Expanded(
                                                flex: 1,
                                                child: TopCustomerTable(
                                                  report: getTopCustomer((currentMonthCustomerList)),
                                                ),
                                              ),
                                              const SizedBox(width: 20.0),
                                              //__________________________________________Top_Purchasing_product______
                                              Expanded(
                                                flex: 1,
                                                child: purchaseTransactionReport.when(
                                                  data: (purchase) {
                                                    List<ProductModel> purchaseProductList = [];
                                                    bool isContain({required ProductModel element}) {
                                                      for (var p in purchaseProductList) {
                                                        if (p.productCode == element.productCode) {
                                                          p.productStock = (int.parse(p.productStock) + int.parse(element.productStock)).toString();
                                                          return true;
                                                        }
                                                      }
                                                      return false;
                                                    }

                                                    for (var element in purchase) {
                                                      final saleData = DateTime.tryParse(element.purchaseDate.toString()) ?? DateTime.now();
                                                      if (isAfterFirstDayOfCurrentMonth(saleData)) {
                                                        ///____Top_purchasing_product______________________
                                                        for (var product in element.productList!) {
                                                          if (!isContain(element: product)) {
                                                            purchaseProductList.add(ProductModel(
                                                              product.productName,
                                                              product.productCategory,
                                                              product.size,
                                                              product.color,
                                                              '',
                                                              '',
                                                              '',
                                                              '',
                                                              '',
                                                              product.productCode,
                                                              product.productStock,
                                                              '',
                                                              '',
                                                              '',
                                                              '',
                                                              '',
                                                              '',
                                                              '',
                                                              product.warehouseName,
                                                              product.warehouseId,
                                                              product.productPicture,
                                                              [],
                                                              expiringDate: '',
                                                              lowerStockAlert: 0,
                                                              manufacturingDate: '',
                                                            ));
                                                          }
                                                        }
                                                      }
                                                    }

                                                    purchaseProductList.sort(
                                                      (a, b) {
                                                        return int.parse(b.productStock.toString()).compareTo(int.parse(a.productStock.toString()));
                                                      },
                                                    );

                                                    return MtTopStock(
                                                      report: getTopPurchaseReport(purchaseProductList),
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
                                              ),
                                            ],
                                          );
                                        }, error: (e, stack) {
                                          return Center(
                                            child: Text(e.toString()),
                                          );
                                        }, loading: () {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }),
                                        const SizedBox(width: 20.0),

                                        //_______________________________________________________recent_sales___________
                                        const SizedBox(height: 20),
                                        Container(
                                          padding: const EdgeInsets.all(20.0),
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.0), color: kWhiteTextColor),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(FeatherIcons.box),
                                                  const SizedBox(width: 5.0),
                                                  Text(
                                                    lang.S.of(context).recentSale,
                                                    maxLines: 1,
                                                    style:
                                                        kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    totalSaleList.length > 5
                                                        ? 'Showing ${recentFive.length} of ${totalSaleList.length}'
                                                        : 'Showing ${totalSaleList.length} of ${totalSaleList.length}',
                                                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pushNamed(context, SaleList.route);
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          'View All',
                                                          style: kTextStyle.copyWith(color: kMainColor),
                                                        ),
                                                        const Icon(FeatherIcons.arrowRight),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 20),
                                              transactionReport.when(data: (sellerSnap) {
                                                shopList = sellerSnap;
                                                List<SaleTransactionModel> recentSaleList =
                                                    shopList.length > 5 ? shopList.sublist(shopList.length - 5) : shopList;
                                                recentSaleList = recentSaleList.reversed.toList();
                                                totalSaleList = shopList;
                                                recentFive = recentSaleList;
                                                return Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8.0),
                                                    border: Border.all(color: kBorderColorTextField, strokeAlign: BorderSide.strokeAlignOutside),
                                                  ),
                                                  child: DataTable(
                                                    clipBehavior: Clip.antiAlias,
                                                    border: TableBorder.lerp(
                                                        TableBorder(verticalInside: BorderSide.none, borderRadius: BorderRadius.circular(8.0)),
                                                        TableBorder(borderRadius: BorderRadius.circular(8.0)),
                                                        8.0),
                                                    showCheckboxColumn: true,
                                                    dividerThickness: 1.0,
                                                    dataRowColor: const MaterialStatePropertyAll(whiteColor),
                                                    headingRowColor: MaterialStateProperty.all(const Color(0xFFF8F3FF)),
                                                    showBottomBorder: false,
                                                    headingTextStyle: kTextStyle.copyWith(color: kTitleColor, overflow: TextOverflow.ellipsis),
                                                    dataTextStyle: kTextStyle.copyWith(color: kGreyTextColor, overflow: TextOverflow.ellipsis),
                                                    columns: [
                                                      DataColumn(
                                                        label: Text(
                                                          'S.L',
                                                          style: kTextStyle.copyWith(color: kTitleColor, overflow: TextOverflow.ellipsis),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                          label: Text('Date', style: kTextStyle.copyWith(color: kTitleColor, overflow: TextOverflow.ellipsis))),
                                                      DataColumn(
                                                          label:
                                                              Text('Invoice', style: kTextStyle.copyWith(color: kTitleColor, overflow: TextOverflow.ellipsis))),
                                                      DataColumn(
                                                          label: Flexible(
                                                              child: Text('Mijoz',
                                                                  style: kTextStyle.copyWith(color: kTitleColor, overflow: TextOverflow.ellipsis)))),
                                                      DataColumn(
                                                          label: Flexible(
                                                              child: Text('Payment Type',
                                                                  style: kTextStyle.copyWith(color: kTitleColor, overflow: TextOverflow.ellipsis)))),
                                                      DataColumn(
                                                          label:
                                                              Text('Amount', style: kTextStyle.copyWith(color: kTitleColor, overflow: TextOverflow.ellipsis))),
                                                      DataColumn(
                                                          label: Text('Paid', style: kTextStyle.copyWith(color: kTitleColor, overflow: TextOverflow.ellipsis))),
                                                      DataColumn(
                                                          label: Text('Due', style: kTextStyle.copyWith(color: kTitleColor, overflow: TextOverflow.ellipsis))),
                                                      DataColumn(
                                                          label:
                                                              Text('Status', style: kTextStyle.copyWith(color: kTitleColor, overflow: TextOverflow.ellipsis))),
                                                      // DataColumn(
                                                      //     label:
                                                      //         Text('Action', style: kTextStyle.copyWith(color: kTitleColor, overflow: TextOverflow.ellipsis))),
                                                    ],
                                                    rows: List.generate(
                                                      recentSaleList.reversed.toList().length,
                                                      (index) => DataRow(
                                                        cells: [
                                                          DataCell(
                                                            Text(
                                                              (index + 1).toString(),
                                                              textAlign: TextAlign.start,
                                                            ),
                                                          ),
                                                          DataCell(
                                                            Text(dataTypeFormat.format(
                                                              DateTime.parse(
                                                                recentSaleList[index].purchaseDate.toString(),
                                                              ),
                                                            )),
                                                          ),
                                                          DataCell(
                                                            Text(
                                                              recentSaleList[index].invoiceNumber.toString(),
                                                              style: kTextStyle.copyWith(color: kMainColor),
                                                            ),
                                                          ),
                                                          DataCell(
                                                            Text(recentSaleList[index].customerName.toString()),
                                                          ),
                                                          DataCell(
                                                            Text(recentSaleList[index].paymentType.toString()),
                                                          ),
                                                          DataCell(
                                                            Text('$currency${recentSaleList[index].totalAmount.toString()}'),
                                                          ),
                                                          DataCell(
                                                            Text(
                                                                '$currency${((recentSaleList[index].totalAmount!) - (double.parse(recentSaleList[index].dueAmount.toString())))}'),
                                                          ),
                                                          DataCell(
                                                            Text('$currency${recentSaleList[index].dueAmount.toString()}'),
                                                          ),
                                                          DataCell(
                                                            Text(recentSaleList[index].isPaid == true ? 'Paid' : "Unpaid"),
                                                          ),
                                                          // DataCell(
                                                          //   PopupMenuButton(
                                                          //     icon: const Icon(Icons.more_vert_rounded, size: 18.0),
                                                          //     padding: EdgeInsets.zero,
                                                          //     itemBuilder: (BuildContext bc) => [
                                                          //       PopupMenuItem(
                                                          //         child: GestureDetector(
                                                          //           onTap: () {
                                                          //             // Navigator.push(context, MaterialPageRoute(builder: (context) => const EditParty()));
                                                          //           },
                                                          //           child: Row(
                                                          //             children: [
                                                          //               const Icon(IconlyLight.edit_square, size: 18.0, color: kGreyTextColor),
                                                          //               const SizedBox(width: 4.0),
                                                          //               Text(
                                                          //                 'View/Edit',
                                                          //                 style: kTextStyle.copyWith(color: kGreyTextColor),
                                                          //               ),
                                                          //             ],
                                                          //           ),
                                                          //         ),
                                                          //       ),
                                                          //     ],
                                                          //     onSelected: (value) {
                                                          //       Navigator.pushNamed(context, '$value');
                                                          //     },
                                                          //   ),
                                                          // ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }, error: (e, stack) {
                                                return Center(
                                                  child: Text(e.toString()),
                                                );
                                              }, loading: () {
                                                return const Center(
                                                  child: CircularProgressIndicator(),
                                                );
                                              })
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        const Footer(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getAllTotal() async {
    // ignore: unused_local_variable
    List<ProductModel> productList = [];
    await FirebaseDatabase.instance.ref(await getUserID()).child('Products').orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = jsonDecode(jsonEncode(element.value));
        totalStock = totalStock + int.parse(data['productStock']);
        totalSalePrice = totalSalePrice + (num.parse(data['productSalePrice']) * num.parse(data['productStock']));
        totalParPrice = totalParPrice + (num.parse(data['productPurchasePrice']) * num.parse(data['productStock']));

        // productList.add(ProductModel.fromJson(jsonDecode(jsonEncode(element.value))));
      }
    });
    setState(() {});
  }
}
