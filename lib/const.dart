import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'Screen/Due List/due_list_screen.dart';
import 'Screen/Expenses/expenses_list.dart';
import 'Screen/LossProfit/lossProfit_screen.dart';
import 'Screen/Reports/report_screen.dart';
import 'Screen/Stock List/stock_list_screen.dart';
import 'model/user_role_model.dart';

final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

String appsName = 'Pos Saas';
String appsTitle = 'Pos Saas Web';
String pdfFooter = 'acnoo.com';
bool isDemo = false;
String demoText = 'You Can\'t change anything in demo mode';
String sideBarLogo='images/pos.png';
String appLogo='images/mobipos.png';

// String appLogo='images/mobipos.png';
// String appsName = 'Pos Saas';
// String appsTitle = 'Pos Saas Web';
// String pdfFooter = 'acnoo.com';
// bool isDemo = false;
// String demoText = 'You Can\'t change anything in demo mode';
// String sideBarLogo='images/pos.png';

List<String> selectedNumbers = [];

Future<String?> getSaleID({required String id}) async {
  String? key;
  await FirebaseDatabase.instance.ref().child('Admin Panel').child('Seller List').orderByKey().get().then((value) async {
    for (var element in value.children) {
      var data = jsonDecode(jsonEncode(element.value));
      if (data['userId'].toString() == id) {
        key = element.key.toString();
      }
    }
  });
  return key;
}

String constUserId = '';
bool isSubUser = false;
String constSubUserTitle = '';

String subUserEmail = '';

String searchItems = '';

String mainLoginPassword = '';
String mainLoginEmail = '';

UserRoleModel finalUserRoleModel = UserRoleModel(
  email: '',
  userTitle: '',
  databaseId: '',
  salePermission: true,
  partiesPermission: true,
  purchasePermission: true,
  productPermission: true,
  profileEditPermission: true,
  addExpensePermission: true,
  lossProfitPermission: true,
  dueListPermission: true,
  stockPermission: true,
  reportsPermission: true,
  salesListPermission: true,
  purchaseListPermission: true,
);

Future<void> setUserDataOnLocalData({required String uid, required String subUserTitle, required bool isSubUser}) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('userId', uid);
  await prefs.setString('subUserTitle', subUserTitle);
  await prefs.setBool('isSubUser', isSubUser);
}

Future<void> getUserDataFromLocal() async {
  final prefs = await SharedPreferences.getInstance();
  constUserId = prefs.getString('userId') ?? '';
  constSubUserTitle = prefs.getString('subUserTitle') ?? '';
  isSubUser = prefs.getBool('isSubUser') ?? false;
  String? data = prefs.getString("userPermission");
  data != null ? finalUserRoleModel = UserRoleModel.fromJson(jsonDecode(data)) : null;
}

String userPermissionErrorText = 'Access not granted';

Future<bool> checkUserRolePermission({required String type}) async {
  await getUserDataFromLocal();
  bool permission = true;

  if (isSubUser) {
    switch (type) {
      case 'sale':
        permission = finalUserRoleModel.salePermission;
        break;
      case 'salesList':
        permission = finalUserRoleModel.salesListPermission;
        break;
      case ExpensesList.route:
        permission = finalUserRoleModel.addExpensePermission;
        break;
      case DueList.route:
        permission = finalUserRoleModel.dueListPermission;
        break;
      case LossProfitScreen.route:
        permission = finalUserRoleModel.lossProfitPermission;
        break;
      case 'parties':
        permission = finalUserRoleModel.partiesPermission;
        break;
      case 'product':
        permission = finalUserRoleModel.productPermission;
        break;
      case 'purchaseList':
        permission = finalUserRoleModel.purchaseListPermission;
        break;
      case 'purchase':
        permission = finalUserRoleModel.purchasePermission;
        break;
      case SaleReports.route:
        permission = finalUserRoleModel.reportsPermission;
        break;
      case StockListScreen.route:
        permission = finalUserRoleModel.stockPermission;
        break;
      case 'profileEdit':
        permission = finalUserRoleModel.profileEditPermission;
        break;
      default:
        permission = true;
        break;
    }
    if (permission) {
      return permission;
    } else {
      EasyLoading.showError(userPermissionErrorText);
      return permission;
    }
  } else {
    return true;
  }
}

Future<String> getUserID() async {
  final prefs = await SharedPreferences.getInstance();
  final String? uid = prefs.getString('userId');

  return uid ?? '';
}

void putUserDataImidiyate({required String uid, required String title, required bool isSubUse}) {
  constUserId = uid;
  constSubUserTitle = title;
  isSubUser = isSubUse;
}

List<String> categories = [
  'Select Business Category',
  'Bag & Luggage',
  'Books & Stationery',
  'Clothing',
  'Construction & Raw materials',
  'Coffee & Tea',
  'Cosmetic & Jewellery',
  'Computer & Electronic',
  'E-Commerce',
  'Furniture',
  'General Store',
  'Gift, Toys & flowers',
  'Grocery, Fruits & Bakery',
  'Handicraft',
  'Home & Kitchen',
  'Hardware & sanitary',
  'Internet, Dish & TV',
  'Laundry',
  'Manufacturing',
  'Mobile Top up',
  'Motorbike & parts',
  'Mobile & Gadgets',
  'Pharmacy',
  'Poultry & Agro',
  'Pet & Accessories',
  'Rice mill',
  'Super Shop',
  'Sunglasses',
  'Service & Repairing',
  'Sports & Exercise',
  'Shoes',
  'Saloon & Beauty Parlour',
  'Shop Rent & Office Rent',
  'Trading',
  'Travel Ticket & Rental',
  'Thai Aluminium & Glass',
  'Vehicles & Parts',
  'Others',
];
String dropdownValue = 'Select Business Category';

final currentDate = DateTime.now();
final firstDayOfCurrentMonth = DateTime(currentDate.year, currentDate.month, 1);
final firstDayOfCurrentYear = DateTime(currentDate.year, 1, 1);
final firstDayOfPreviousYear = firstDayOfCurrentYear.subtract(const Duration(days: 1));
final lastDayOfPreviousMonth = firstDayOfCurrentMonth.subtract(const Duration(days: 1));
final firstDayOfPreviousMonth = DateTime(lastDayOfPreviousMonth.year, lastDayOfPreviousMonth.month, 1);

DateFormat dataTypeFormat = DateFormat('dd MMM yyyy');
