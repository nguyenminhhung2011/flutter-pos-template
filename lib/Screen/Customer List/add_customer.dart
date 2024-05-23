// ignore_for_file: unused_result

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../Provider/customer_provider.dart';
import '../../commas.dart';
import '../../const.dart';
import '../../model/customer_model.dart';
import '../../subscription.dart';
import '../Widgets/Constant Data/button_global.dart';
import '../Widgets/Constant Data/constant.dart';
import '../Widgets/Footer/footer.dart';
import '../Widgets/Sidebar/sidebar_widget.dart';
import '../Widgets/TopBar/top_bar_widget.dart';

class AddCustomer extends StatefulWidget {
  const AddCustomer({Key? key, required this.typeOfCustomerAdd, required this.listOfPhoneNumber, required this.sideBarNumber}) : super(key: key);

  final String typeOfCustomerAdd;
  final List<String> listOfPhoneNumber;
  final int sideBarNumber;

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  bool saleButtonClicked = false;
  String profilePicture =
      'https://firebasestorage.googleapis.com/v0/b/maanpos.appspot.com/o/Profile%20Picture%2Fblank-profile-picture-973460_1280.webp?alt=media&token=3578c1e0-7278-4c03-8b56-dd007a9befd3';

  Uint8List? image;

  Future<void> uploadFile() async {
    if (kIsWeb) {
      try {
        Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
        if (bytesFromPicker!.isNotEmpty) {
          EasyLoading.show(status: 'Uploading... ', dismissOnTap: false);
        }

        var snapshot = await FirebaseStorage.instance.ref('Profile Picture/${DateTime.now().millisecondsSinceEpoch}').putData(bytesFromPicker);
        var url = await snapshot.ref.getDownloadURL();
        EasyLoading.showSuccess('Upload Successful!');
        setState(() {
          image = bytesFromPicker;
          profilePicture = url.toString();
        });
      } on firebase_core.FirebaseException catch (e) {
        EasyLoading.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.code.toString())));
      }
    }
  }

  List<String> categories = [
    'Retailer',
    'Wholesaler',
    'Dealer',
    'Supplier',
  ];
  String pageName = 'Add Customer';

  String selectedCategories = 'Retailer';

  @override
  initState() {
    super.initState();
    if (widget.typeOfCustomerAdd == 'Buyer') {
      categories = [
        'Retailer',
        'Wholesaler',
        'Dealer',
      ];
    } else if (widget.typeOfCustomerAdd == 'Supplier') {
      categories = [
        'Supplier',
      ];
      selectedCategories = 'Supplier';
      pageName = 'Add Supplier';
    }
  }

  DropdownButton<String> getCategories() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String des in categories) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(des,style: kTextStyle.copyWith(fontWeight: FontWeight.normal,color: kTitleColor),),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      items: dropDownItems,
      value: selectedCategories,
      onChanged: (value) {
        setState(() {
          selectedCategories = value!;
        });
      },
    );
  }

  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerPhoneController = TextEditingController();
  TextEditingController customerEmailController = TextEditingController();
  TextEditingController customerPreviousDueController = TextEditingController();
  TextEditingController customerAddressController = TextEditingController();

  String openingBalance = '';

  GlobalKey<FormState> addCustomer = GlobalKey<FormState>();

  bool validateAndSave() {
    final form = addCustomer.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  ScrollController mainScroll = ScrollController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kDarkWhite,
        body: Scrollbar(
          controller: mainScroll,
          child: SingleChildScrollView(
            controller: mainScroll,
            scrollDirection: Axis.horizontal,
            child: Consumer(builder: (context, ref, _) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 240,
                    child: SideBarWidget(
                      index: widget.sideBarNumber,
                      isTab: false,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width < 1275 ? 1275 - 240 : MediaQuery.of(context).size.width - 240,
                    // width: context.width() < 1080 ? 1080 - 240 : MediaQuery.of(context).size.width - 240,
                    decoration: const BoxDecoration(color: kDarkWhite),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TopBar(),
                        const SizedBox(height: 20.0),
                        Container(
                          height: MediaQuery.of(context).size.height - 240,
                          decoration: const BoxDecoration(color: kDarkWhite),
                          child: SingleChildScrollView(
                            controller: mainScroll,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        pageName,
                                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 21.0),
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            color: kWhiteTextColor,
                                          ),
                                          child: Form(
                                            key: addCustomer,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 20.0),

                                                ///__________Name_&_Phone___________________________________
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: TextFormField(
                                                        validator: (value) {
                                                          if (value.isEmptyOrNull) {
                                                            return 'Customer Name Is Required.';
                                                          } else {
                                                            return null;
                                                          }
                                                        },
                                                        onSaved: (value) {
                                                          customerNameController.text = value!;
                                                        },
                                                        controller: customerNameController,
                                                        showCursor: true,
                                                        cursorColor: kTitleColor,
                                                        decoration: kInputDecoration.copyWith(
                                                          errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                          labelText: lang.S.of(context).customerName,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          hintText: lang.S.of(context).enterCustomerName,
                                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 20.0),
                                                    Expanded(
                                                      child: TextFormField(
                                                        validator: (value) {
                                                          if (value.isEmptyOrNull) {
                                                            return 'Phone Number is required.';
                                                          } else if (widget.listOfPhoneNumber.contains(value.removeAllWhiteSpace().toLowerCase())) {
                                                            return 'Phone Number already exists';
                                                          } else if (double.tryParse(value!) == null && value.isNotEmpty) {
                                                            return 'Please Enter valid phone number.';
                                                          } else {
                                                            return null;
                                                          }
                                                        },
                                                        onSaved: (value) {
                                                          customerPhoneController.text = value!;
                                                        },
                                                        controller: customerPhoneController,
                                                        showCursor: true,
                                                        cursorColor: kTitleColor,
                                                        decoration: kInputDecoration.copyWith(
                                                          errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                          labelText: lang.S.of(context).phoneNumber,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          hintText: lang.S.of(context).enterYourPhoneNumber,
                                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 20.0),

                                                ///__________Email_&_Address___________________________________
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: TextFormField(
                                                        validator: (value) {
                                                          return null;
                                                        },
                                                        onSaved: (value) {
                                                          customerEmailController.text = value!;
                                                        },
                                                        controller: customerEmailController,
                                                        showCursor: true,
                                                        cursorColor: kTitleColor,
                                                        decoration: kInputDecoration.copyWith(
                                                          labelText: lang.S.of(context).email,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          hintText: lang.S.of(context).enterYourEmailAddress,
                                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 20.0),
                                                    Expanded(
                                                      child: TextFormField(
                                                        validator: (value) {
                                                          return null;
                                                        },
                                                        onSaved: (value) {
                                                          customerAddressController.text = value!;
                                                        },
                                                        controller: customerAddressController,
                                                        showCursor: true,
                                                        cursorColor: kTitleColor,
                                                        decoration: kInputDecoration.copyWith(
                                                          labelText: lang.S.of(context).address,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          hintText: lang.S.of(context).enterYourAddress,
                                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 20.0),

                                                ///__________Opening_&_Type__________________________________________
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: TextFormField(
                                                        onChanged: (value) {
                                                          openingBalance = value.replaceAll(',', '');
                                                          var formattedText = myFormat.format(int.parse(openingBalance));
                                                          customerPreviousDueController.value = customerPreviousDueController.value.copyWith(
                                                            text: formattedText,
                                                            selection: TextSelection.collapsed(offset: formattedText.length),
                                                          );
                                                        },
                                                        validator: (value) {
                                                          if (double.tryParse(openingBalance) == null && openingBalance.isNotEmpty) {
                                                            return 'Please Enter valid balance.';
                                                          } else {
                                                            return null;
                                                          }
                                                        },
                                                        onSaved: (value) {
                                                          customerPreviousDueController.text = value!;
                                                        },
                                                        controller: customerPreviousDueController,
                                                        showCursor: true,
                                                        cursorColor: kTitleColor,
                                                        decoration: kInputDecoration.copyWith(
                                                          errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                          labelText: lang.S.of(context).openingBalance,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          hintText: lang.S.of(context).enterOpeningBalance,
                                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 20.0),
                                                    Expanded(
                                                      child: FormField(
                                                        builder: (FormFieldState<dynamic> field) {
                                                          return InputDecorator(
                                                            decoration: InputDecoration(
                                                                enabledBorder: const OutlineInputBorder(
                                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                                  borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                                                                ),
                                                                contentPadding: const EdgeInsets.all(6.0),
                                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                                labelText: lang.S.of(context).type),
                                                            child: Theme(
                                                                data: ThemeData(
                                                                    highlightColor: dropdownItemColor,
                                                                    focusColor: dropdownItemColor,
                                                                    hoverColor: dropdownItemColor
                                                                ),
                                                                child: DropdownButtonHideUnderline(child: getCategories())),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                ///_______Button_______________________________________________________
                                                const SizedBox(height: 30.0),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: context.width() < 1080 ? 1080 * .18 : MediaQuery.of(context).size.width * .18,
                                                      child: ButtonGlobal(
                                                        buttontext: lang.S.of(context).cancel,
                                                        buttonDecoration: kButtonDecoration.copyWith(color: Colors.red),
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                      ),
                                                    ),
                                                    const SizedBox(width: 20),
                                                    SizedBox(
                                                      width: context.width() < 1080 ? 1080 * .18 : MediaQuery.of(context).size.width * .18,
                                                      child: ButtonGlobal(
                                                        buttontext: lang.S.of(context).saveAndPublish,
                                                        buttonDecoration: kButtonDecoration.copyWith(color: kGreenTextColor),
                                                        onPressed: saleButtonClicked
                                                            ? () {}
                                                            : () async {
                                                          if(!isDemo){
                                                            if (await checkUserRolePermission(type: 'parties')) {
                                                              if (validateAndSave()) {
                                                                try {
                                                                  setState(() {
                                                                    saleButtonClicked = true;
                                                                  });
                                                                  EasyLoading.show(status: 'Loading...', dismissOnTap: false);
                                                                  final DatabaseReference customerInformationRef =
                                                                  FirebaseDatabase.instance.ref().child(await getUserID()).child('Customers');
                                                                  CustomerModel customerModel = CustomerModel(
                                                                    customerName: customerNameController.text,
                                                                    phoneNumber: customerPhoneController.text,
                                                                    type: selectedCategories,
                                                                    profilePicture: profilePicture,
                                                                    emailAddress: customerEmailController.text,
                                                                    customerAddress: customerAddressController.text,
                                                                    dueAmount: openingBalance.isEmpty ? '0' : openingBalance,
                                                                    openingBalance: openingBalance.isEmpty ? '0' : openingBalance,
                                                                    remainedBalance: openingBalance.isEmpty ? '0' : openingBalance,
                                                                  );
                                                                  await customerInformationRef.push().set(customerModel.toJson());

                                                                  ///________subscription_plan_update_________________________________________________
                                                                  Subscription.decreaseSubscriptionLimits(itemType: 'partiesNumber', context: context);

                                                                  EasyLoading.showSuccess('Added Successfully!');
                                                                  ref.refresh(buyerCustomerProvider);
                                                                  ref.refresh(supplierProvider);
                                                                  ref.refresh(allCustomerProvider);
                                                                  Future.delayed(const Duration(milliseconds: 100), () {
                                                                    Navigator.pop(context);
                                                                  });
                                                                } catch (e) {
                                                                  setState(() {
                                                                    saleButtonClicked = false;
                                                                  });
                                                                  EasyLoading.dismiss();
                                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                                                                }
                                                              }
                                                            }
                                                          } else {
                                                            EasyLoading.showInfo(demoText);
                                                          }

                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 20.0),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20.0),
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                          padding: const EdgeInsets.all(20.0),
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: kWhiteTextColor),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              const SizedBox(height: 10.0),
                                              DottedBorderWidget(
                                                padding: const EdgeInsets.all(6),
                                                color: kLitGreyColor,
                                                child: ClipRRect(
                                                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                                                  child: Container(
                                                    width: context.width(),
                                                    padding: const EdgeInsets.all(10.0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(20.0),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Icon(MdiIcons.cloudUpload, size: 50.0, color: kLitGreyColor).onTap(() => uploadFile()),
                                                          ],
                                                        ),
                                                        const SizedBox(height: 5.0),
                                                        RichText(
                                                          text: TextSpan(
                                                            text: lang.S.of(context).uploadAImage,
                                                            style: kTextStyle.copyWith(color: kGreenTextColor, fontWeight: FontWeight.bold),
                                                            children: [
                                                              TextSpan(
                                                                  text: lang.S.of(context).orDragAndDropPng,
                                                                  style: kTextStyle.copyWith(color: kGreyTextColor, fontWeight: FontWeight.bold))
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              image != null
                                                  ? Image.memory(
                                                image!,
                                                width: 150,
                                                height: 150,
                                              )
                                                  : Image.network(
                                                profilePicture,
                                                width: 150,
                                                height: 150,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),

                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Footer(),
                      ],
                    ),
                  )
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
