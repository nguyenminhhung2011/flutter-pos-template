import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as ri;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:salespro_admin/Screen/Authentication/log_in.dart';
import 'package:salespro_admin/model/personal_information_model.dart';
import '../../../Language/language_provider.dart';
import '../../../Provider/profile_provider.dart';
import '../../../const.dart';
import '../../../currency.dart';
import '../../Authentication/profile_setup.dart';
import '../../Authentication/tablet_profile_set_up.dart';
import '../../Home/home_screen.dart';
import '../../Inventory Sales/inventory_sales.dart';
import '../../POS Sale/pos_sale.dart';
import '../../Product/product.dart';
import '../../Purchase List/purchase_list.dart';
import '../../Reports/report_screen.dart';
import '../Constant Data/constant.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;

class TopBar extends StatefulWidget {
  const TopBar({
    Key? key,
  }) : super(key: key);

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  List<String> screenList = [
    MtHomeScreen.route,
    MtHomeScreen.route,
    MtHomeScreen.route,
    MtHomeScreen.route,
    MtHomeScreen.route,
    MtHomeScreen.route,
    MtHomeScreen.route,
    MtHomeScreen.route,
    MtHomeScreen.route,
  ];

  final ScrollController mainSideScroller = ScrollController();

  List<String> baseFlagsCode = [
    'US',
    'RU',
    'UZ',

  ];
  List<String> countryList = [
    'English',
    'Russian',
    'Uzbek'
  ];
  String selectedCountry = 'Uzbek';

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

  String? dropdownValue = '\$ (US Dollar)';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  getCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('currency');

    if (!data.isEmptyOrNull) {
      for (var element in items) {
        if (element.substring(0, 2).contains(data!)) {
          setState(() {
            currency = data;
            dropdownValue = element;
          });
          break;
        }
      }
    } else {
      setState(() {
        dropdownValue = items[0];
      });
    }
  }


  setCurrency(String currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency', currency);
    getCurrency();
  }

  bool isFirstTime = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: kWhiteTextColor,
      ),
      child: ri.Consumer(builder: (context, ref, __) {
        AsyncValue<PersonalInformationModel> userProfileDetails = ref.watch(profileDetailsProvider);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 30.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),

                backgroundColor: const Color(0xFF8424FF),
                // side: const BorderSide(color: kBorderColorTextField, width: 1),
                textStyle: kTextStyle.copyWith(color: kWhiteTextColor),
                surfaceTintColor: const Color(0xFF8424FF).withOpacity(0.5),
                shadowColor: const Color(0xFF8424FF).withOpacity(0.1),
              ),
              onPressed: () {
                Navigator.pushNamed(context, PosSale.route);
              },
              child: Row(
                children: [
                  const Icon(Icons.add_rounded, color: kWhiteTextColor),
                  Text(
                    'Pos',
                    style: kTextStyle.copyWith(color: kWhiteTextColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                backgroundColor: kWhiteTextColor,
                side: const BorderSide(color: kMainColor, width: 1),
                textStyle: kTextStyle.copyWith(color: kWhiteTextColor),
                surfaceTintColor: lightGreyColor,
                shadowColor: lightGreyColor.withOpacity(0.1),
              ),
              onPressed: () {
                Navigator.pushNamed(context, InventorySales.route);
              },
              child: Row(
                children: [
                  const Icon(Icons.add_rounded, color: kMainColor),
                  Text(
                    'Inventory',
                    style: kTextStyle.copyWith(color: kMainColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 30.0),
            userProfileDetails.when(data: (details) {
              setCurrency(details.currency);
              //  isFirstTime = false;
              return SizedBox(
                width: 180,
                child: Text(
                  isSubUser ? '${details.companyName ?? ''} [$constSubUserTitle]' : details.companyName ?? '',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: GoogleFonts.poppins(
                    fontSize: context.width() < 900 ? 20: context.width() * 0.010,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }, error: (e, stack) {
              return Text(e.toString());
            }, loading: () {
              return const Text('');
            }),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                backgroundColor: kWhiteTextColor,
                side: const BorderSide(color: Color(0xFFFF2525), width: 1),
                textStyle: kTextStyle.copyWith(color: const Color(0xFFFF2525)),
                surfaceTintColor: kWhiteTextColor,
                shadowColor: const Color(0xFFFF2525).withOpacity(0.1),
                foregroundColor: const Color(0xFFFF2525).withOpacity(0.1),
              ),
              onPressed: () {
                Navigator.pushNamed(context, Product.route);
              },
              child: Row(
                children: [
                  const Icon(Icons.add_rounded, color: Color(0xFFFF2525)),
                  Text(
                    'Product',
                    style: kTextStyle.copyWith(color: Color(0xFFFF2525), fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                backgroundColor: kWhiteTextColor,
                side: const BorderSide(color: Color(0xFF15CD75), width: 1),
                textStyle: kTextStyle.copyWith(color: const Color(0xFF15CD75)),
                surfaceTintColor: kWhiteTextColor,
                shadowColor: const Color(0xFF15CD75).withOpacity(0.1),
                foregroundColor: const Color(0xFF15CD75).withOpacity(0.1),
              ),
              onPressed: () {
                Navigator.pushNamed(context, PurchaseList.route);
              },
              child: Row(
                children: [
                  const Icon(Icons.add_rounded, color: Color(0xFF15CD75)),
                  Text(
                    'Purchase',
                    style: kTextStyle.copyWith(color: Color(0xFF15CD75), fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFF828282).withOpacity(0.3)),
                ),
                padding: const EdgeInsets.fromLTRB(13.0, 5.0, 13.0, 5.0),
                child: Theme(
                  data: ThemeData(highlightColor: dropdownItemColor, focusColor: dropdownItemColor, hoverColor: dropdownItemColor),
                  child: DropdownButton(
                    underline: const SizedBox(),
                    dropdownColor: Colors.white,
                    focusColor: kbgColor,
                    alignment: Alignment.center,
                    isExpanded: true,
                    style: const TextStyle(overflow: TextOverflow.ellipsis),
                    value: selectedCountry,
                    items: List.generate(
                        countryList.length,
                            (index) =>
                            DropdownMenuItem(
                              onTap: () {
                                setState(
                                      () {
                                    selectedCountry = countryList[index];
                                    selectedCountry == 'English'
                                        ? context.read<LanguageChangeProvider>().changeLocale("en")
                                        : selectedCountry == "Russian"
                                        ? context.read<LanguageChangeProvider>().changeLocale("ru")
                                        : selectedCountry == "Uzbek"
                                        ? context.read<LanguageChangeProvider>().changeLocale("uz")
                                        : context.read<LanguageChangeProvider>().changeLocale("uz");
                                    saveDataOnLocal(key: 'savedLanguage', type: 'string', value: selectedCountry);
                                    saveData(selectedCountry);
                                  },
                                );
                              },
                              value: countryList[index],
                              child: InkWell(
                                child: Row(
                                  children: [
                                    Flag.fromString(
                                      baseFlagsCode[index],
                                      height: 15,
                                      width: 20,
                                    ),
                                    const SizedBox(width: 5),
                                    Flexible(
                                      child: Text(
                                        countryList[index],
                                        style: const TextStyle(fontSize: 14, overflow: TextOverflow.ellipsis),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                    onChanged: (value) {
                      setState(() {
                        selectedCountry != value;
                      });
                    },
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF585865),
                    ),
                    isDense: true,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFF828282).withOpacity(0.3)),
                ),
                padding: const EdgeInsets.fromLTRB(13.0, 5.0, 13.0, 5.0),
                child: Theme(
                  data: ThemeData(highlightColor: dropdownItemColor, focusColor: dropdownItemColor, hoverColor: dropdownItemColor),
                  child: DropdownButton(
                    dropdownColor: Colors.white,
                    alignment: Alignment.center,
                    isExpanded: true,
                    padding: EdgeInsets.zero,
                    underline: const SizedBox(),
                    value: dropdownValue,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF585865),
                    ),
                    isDense: true,
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(
                          items,
                          style: kTextStyle.copyWith(color: kTitleColor, fontSize: 14.0, overflow: TextOverflow.ellipsis),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) async {
                      final prefs = await SharedPreferences.getInstance();

                      // Use a map for currency symbols
                      final currencySymbols = {
                        '\$ (US Dollar)': '\$',
                         'сўм (O`zbekiston)': 'сўм',
                        // Add more currencies as needed
                      };

                      if (currencySymbols.containsKey(newValue)) {
                        print(currencySymbols[newValue]!);
                        currency = currencySymbols[newValue]!;
                        await prefs.setString('currency', currency);
                        final DatabaseReference personalInformationRef = FirebaseDatabase.instance.ref().child(await getUserID()).child('Personal Information');
                        await personalInformationRef.update({'currency': currency});
                        // ref.refresh(profileDetailsProvider);
                      } else {
                        // Set a default currency if newValue is not found in the map
                        currency = "\$";
                        await prefs.setString('currency', currency);
                      }

                      setState(() {
                        Future.delayed(Duration(milliseconds: 400)).then((value) => dropdownValue = newValue.toString());

                        ref.refresh(profileDetailsProvider);
                        // ref.refresh(profileDetailsProvider);
                        Future.delayed(Duration(milliseconds: 600)).then((value) =>
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MtHomeScreen(),
                              ),
                            ));
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            userProfileDetails.when(data: (details) {
              return Theme(
                data: ThemeData(highlightColor: dropdownItemColor, focusColor: dropdownItemColor, hoverColor: dropdownItemColor),
                child: PopupMenuButton(
                  surfaceTintColor: Colors.white,
                  padding: EdgeInsets.zero,
                  position: PopupMenuPosition.under,
                  icon: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2DB0F6).withOpacity(0.1),
                      shape: BoxShape.rectangle,
                    ),
                    child: const Icon(Icons.settings, color: Color(0xFF2DB0F6), size: 30.0),
                  ),
                  itemBuilder: (BuildContext bc) =>
                  [
                    PopupMenuItem(
                      child: GestureDetector(
                        onTap: () {
                          isSubUser ? null : ProfileUpdate(personalInformationModel: details).launch(context);
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.manage_accounts_sharp, size: 18.0, color: kTitleColor),
                            const SizedBox(width: 4.0),
                            Text(
                              isSubUser ? '${details.companyName}[$constSubUserTitle]' : lang.S
                                  .of(context)
                                  .prof,
                              style: kTextStyle.copyWith(color: kTitleColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: GestureDetector(
                        onTap: () async {
                          await FirebaseAuth.instance.signOut();
                          EasyLoading.showSuccess('Successfully Logged Out');
                          const EmailLogIn().launch(context);
                        },
                        child: Row(
                          children: [
                            const Icon(FeatherIcons.logOut, size: 18.0, color: kTitleColor),
                            const SizedBox(width: 4.0),
                            Text(
                              lang.S
                                  .of(context)
                                  .logOut,
                              style: kTextStyle.copyWith(color: kTitleColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
            }),
          ],
        );
      }),
    );
  }
}

class TopBarTablate extends StatelessWidget {
  const TopBarTablate({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ri.Consumer(
      builder: (_, ref, __) {
        ri.AsyncValue<PersonalInformationModel> userProfileDetails = ref.watch(profileDetailsProvider);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: kBlueTextColor,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(FeatherIcons.plus, color: kWhiteTextColor, size: 16.0),
                  const SizedBox(width: 5.0),
                  Text(
                    'Stock',
                    style: kTextStyle.copyWith(color: kWhiteTextColor),
                  ),
                ],
              ),
            ).onTap(
                  () => Navigator.pushNamed(context, SaleReports.route, arguments: 'Stock Report'),
            ),
            const SizedBox(
              width: 8.0,
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: kRedTextColor,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(FeatherIcons.plus, color: kWhiteTextColor, size: 16.0),
                  const SizedBox(width: 5.0),
                  Text(
                    lang.S
                        .of(context)
                        .dueList,
                    style: kTextStyle.copyWith(color: kWhiteTextColor),
                  ),
                ],
              ),
            ),
            //     .onTap(
            //   () => Navigator.pushNamed(context, TabletSaleReport.route, arguments: 'Due'),
            // ),
            const SizedBox(
              width: 8.0,
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(color: kYellowColor),
                color: kWhiteTextColor,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(FeatherIcons.plus, color: kYellowColor, size: 16.0),
                  const SizedBox(width: 5.0),
                  Text(
                    lang.S
                        .of(context)
                        .reports,
                    style: kTextStyle.copyWith(color: kYellowColor),
                  ),
                ],
              ),
            ),
            //         .onTap(
            //   () => Navigator.pushNamed(context, TabletSaleReport.route),
            // ),
            const SizedBox(
              width: 8.0,
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: kRedTextColor,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(FeatherIcons.plus, color: kWhiteTextColor, size: 16.0),
                  const SizedBox(width: 5.0),
                  Text(
                    lang.S
                        .of(context)
                        .sale,
                    style: kTextStyle.copyWith(color: kWhiteTextColor),
                  ),
                ],
              ),
            ),
            //           .onTap(
            //   () => Navigator.pushNamed(context, TabletPosSale.route),
            // ),
            const SizedBox(
              width: 8.0,
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: kGreenTextColor,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(FeatherIcons.plus, color: kWhiteTextColor, size: 16.0),
                  const SizedBox(width: 5.0),
                  Text(
                    lang.S
                        .of(context)
                        .purchase,
                    style: kTextStyle.copyWith(color: kWhiteTextColor),
                  ),
                ],
              ),
            ),
            //     .onTap(
            //   () => Navigator.pushNamed(context, TabletPurchase.route),
            // ),
            const SizedBox(
              width: 8.0,
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(color: kBlueTextColor),
                color: kWhiteTextColor,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(FeatherIcons.plus, color: kBlueTextColor, size: 16.0),
                  const SizedBox(width: 5.0),
                  Text(
                    'Add More',
                    style: kTextStyle.copyWith(color: kBlueTextColor),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                FeatherIcons.bell,
                color: kTitleColor,
              ),
            ),
            userProfileDetails.when(data: (details) {
              return GestureDetector(
                onTap: () {
                  TabletProfileSetUp(
                    personalInformationModel: details,
                  ).launch(context);
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(details.pictureUrl), fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(50),
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
            }),
          ],
        );
      },
    );
  }
}
