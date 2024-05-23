import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Screen/Product/product.dart';
import 'package:salespro_admin/Screen/Widgets/Constant%20Data/button_global.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../Provider/product_provider.dart';
import '../../const.dart';
import '../../model/brands_model.dart';
import '../../model/category_model.dart';
import '../../model/product_model.dart';
import '../../model/unit_model.dart';
import '../WareHouse/warehouse_model.dart';
import '../Widgets/Constant Data/constant.dart';
import '../Widgets/Footer/footer.dart';
import '../Widgets/Sidebar/sidebar_widget.dart';
import '../Widgets/TopBar/top_bar_widget.dart';

class EditProduct extends StatefulWidget {
  const EditProduct({Key? key, required this.productModel, required this.allProductsNameList,required this.allProductsCodeList}) : super(key: key);

  final ProductModel productModel;
  final List<String> allProductsNameList;
  final List<String> allProductsCodeList;



  @override
  State<EditProduct> createState() => _AddProductState();
}

class _AddProductState extends State<EditProduct> {
  GlobalKey<FormState> addProductFormKey = GlobalKey<FormState>();


  bool categoryValidateAndSave() {
    final form = addProductFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  List<String> allNameInThisFile = [];
  List<String> allCodeInThisFile = [];
  List<String> allCategory = [];
  bool isSize = false;
  bool isColor = false;
  bool isWeight = false;
  bool isCapacity = false;
  bool isType = false;
  bool isWarranty = false;
  bool isSizedBoxShow = false;
  bool isColoredBoxShow = false;
  bool isWeightsBoxShow = false;
  bool isWarrantyBoxShow = false;
  bool isCapacityBoxShow = false;
  bool isTypeBoxShow = false;
  int brandTime = 0;
  int unitTime = 0;
  int categoryTime = 0;
  TextEditingController expireDateTextEditingController = TextEditingController();
  TextEditingController manufactureDateTextEditingController = TextEditingController();
  int lowerStockAlert = 5;
  String? expireDate;
  String? manufactureDate;

  List<String> productSerialNumberList = [];
  bool isSerialNumberTaken = false;
  String selectedTime = 'Year';
  List<String> warrantyTime = ['Day', 'Month', 'Year'];
  String productPicture = '';

  Future<void> addCategoryShowPopUp({required WidgetRef ref, required List<String> categoryNameList, required BuildContext addProductContext}) async {
    GlobalKey<FormState> categoryNameKey = GlobalKey<FormState>();
    bool categoryValidateAndSave() {
      final form = categoryNameKey.currentState;
      if (form!.validate()) {
        form.save();
        return true;
      }
      return false;
    }

    showDialog(
        barrierDismissible: false,
        context: addProductContext,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState1) {
            return Dialog(
              surfaceTintColor: kWhiteTextColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              child: SizedBox(
                width: 600,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: const BoxDecoration(shape: BoxShape.rectangle),
                            child: const Icon(
                              FeatherIcons.plus,
                              color: kTitleColor,
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            lang.S.of(context).addItemCategory,
                            style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          const Icon(
                            FeatherIcons.x,
                            color: kTitleColor,
                            size: 21.0,
                          ).onTap(() {
                            itemCategoryController.clear();
                            isSize = false;
                            isColor = false;
                            isWeight = false;
                            isCapacity = false;
                            isType = false;
                            isWarranty = false;
                            finish(context);
                          })
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Divider(
                        thickness: 1.0,
                        color: kGreyTextColor.withOpacity(0.2),
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          Text(
                            lang.S.of(context).categoryName,
                            style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0),
                          ),
                          const SizedBox(width: 20),
                          Form(
                            key: categoryNameKey,
                            child: SizedBox(
                              width: 400,
                              child: TextFormField(
                                controller: itemCategoryController,
                                validator: (value) {
                                  if (value.isEmptyOrNull) {
                                    return 'Category name is required.';
                                  } else if (categoryNameList.contains(value.removeAllWhiteSpace().toLowerCase())) {
                                    return 'Category name is already exist.';
                                  } else {
                                    return null;
                                  }
                                },
                                showCursor: true,
                                cursorColor: kTitleColor,
                                decoration: kInputDecoration.copyWith(
                                  errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                  labelText: lang.S.of(context).categoryName,
                                  hintText: lang.S.of(context).enterCategoryName,
                                  hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30.0),
                      Text(
                        lang.S.of(context).selectVariations,
                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              leading: Checkbox(
                                activeColor: kMainColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                value: isSize,
                                onChanged: (val) {
                                  setState1(
                                        () {
                                      isSize = val!;
                                    },
                                  );
                                },
                              ),
                              title: Text(lang.S.of(context).size),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              leading: Checkbox(
                                activeColor: kMainColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                value: isColor,
                                onChanged: (val) {
                                  setState1(() {
                                    isColor = val!;
                                  });
                                },
                              ),
                              title: Text(lang.S.of(context).color),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              leading: Checkbox(
                                activeColor: kMainColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                value: isWeight,
                                onChanged: (val) {
                                  setState1(() {
                                    isWeight = val!;
                                  });
                                },
                              ),
                              title: Text(lang.S.of(context).wight),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              leading: Checkbox(
                                activeColor: kMainColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                value: isCapacity,
                                onChanged: (val) {
                                  setState1(
                                        () {
                                      isCapacity = val!;
                                    },
                                  );
                                },
                              ),
                              title: Text(lang.S.of(context).capacity),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              leading: Checkbox(
                                activeColor: kMainColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                value: isType,
                                onChanged: (val) {
                                  setState1(
                                        () {
                                      isType = val!;
                                    },
                                  );
                                },
                              ),
                              title: Text(lang.S.of(context).type),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              leading: Checkbox(
                                activeColor: kMainColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                value: isWarranty,
                                onChanged: (val) {
                                  setState1(
                                        () {
                                      isWarranty = val!;
                                    },
                                  );
                                },
                              ),
                              title: Text(lang.S.of(context).warranty),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5.0),
                      Divider(
                        thickness: 1.0,
                        color: kGreyTextColor.withOpacity(0.2),
                      ),
                      const SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: kRedTextColor),
                            child: Text(
                              lang.S.of(context).cancel,
                              style: kTextStyle.copyWith(color: kWhiteTextColor),
                            ),
                          ).onTap(() {
                            itemCategoryController.clear();
                            isSize = false;
                            isColor = false;
                            isWeight = false;
                            isCapacity = false;
                            isType = false;
                            isWarranty = false;

                            finish(context);
                          }),
                          const SizedBox(width: 5.0),
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: kGreenTextColor),
                            child: Text(
                              lang.S.of(context).submit,
                              style: kTextStyle.copyWith(color: kWhiteTextColor),
                            ),
                          ).onTap(() async {
                            if (categoryValidateAndSave()) {
                              EasyLoading.show(status: 'Adding Category');
                              try {
                                final DatabaseReference categoryInformationRef = FirebaseDatabase.instance.ref().child(await getUserID()).child('Categories');
                                CategoryModel categoryModel = CategoryModel(
                                  categoryName: itemCategoryController.text,
                                  size: isSize,
                                  color: isColor,
                                  capacity: isCapacity,
                                  type: isType,
                                  weight: isWeight,
                                  warranty: isWarranty,
                                );

                                await categoryInformationRef.push().set(categoryModel.toJson());
                                ref.refresh(categoryProvider);

                                setState1(() {
                                  // selectedCategories = categoryModel.categoryName;
                                  isSizedBoxShow = isSize;
                                  isColoredBoxShow = isColor;
                                  isWeightsBoxShow = isWeight;
                                  isCapacityBoxShow = isCapacity;
                                  isTypeBoxShow = isType;
                                  isWarrantyBoxShow = isWarranty;
                                });

                                itemCategoryController.clear();
                                isSize = false;
                                isColor = false;
                                isWeight = false;
                                isCapacity = false;
                                isType = false;
                                isWarranty = false;
                                EasyLoading.showSuccess("Successfully Added");

                                finish(context);
                              } catch (e) {
                                EasyLoading.showError('Error');
                              }
                            }
                          })
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  Future<void> showBrandPopUp({required WidgetRef ref, required List<String> brandNameList, required BuildContext addProductsContext}) async {
    GlobalKey<FormState> brandNameKey = GlobalKey<FormState>();
    bool brandValidateAndSave() {
      final form = brandNameKey.currentState;
      if (form!.validate()) {
        form.save();
        return true;
      }
      return false;
    }

    showDialog(
        barrierDismissible: false,
        context: addProductsContext,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              surfaceTintColor: kWhiteTextColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: SizedBox(
                width: 600,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: const BoxDecoration(shape: BoxShape.rectangle),
                            child: const Icon(
                              FeatherIcons.plus,
                              color: kTitleColor,
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            lang.S.of(context).addBrand,
                            style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          const Icon(
                            FeatherIcons.x,
                            color: kTitleColor,
                            size: 21.0,
                          ).onTap(() {
                            brandNameController.clear();
                            finish(context);
                          })
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Divider(
                        thickness: 1.0,
                        color: kGreyTextColor.withOpacity(0.2),
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          Text(
                            lang.S.of(context).brandName,
                            style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0),
                          ),
                          const SizedBox(width: 50),
                          Form(
                            key: brandNameKey,
                            child: SizedBox(
                              width: 400,
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmptyOrNull) {
                                    return 'Brand name is required.';
                                  } else if (brandNameList.contains(value.removeAllWhiteSpace().toLowerCase())) {
                                    return 'Brand name is already exist.';
                                  } else {
                                    return null;
                                  }
                                },
                                controller: brandNameController,
                                showCursor: true,
                                cursorColor: kTitleColor,
                                decoration: kInputDecoration.copyWith(
                                  errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                  labelText: lang.S.of(context).brandName,
                                  hintText: lang.S.of(context).enterBrandName,
                                  hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Divider(
                        thickness: 1.0,
                        color: kGreyTextColor.withOpacity(0.2),
                      ),
                      const SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: kRedTextColor),
                            child: Text(
                              lang.S.of(context).cancel,
                              style: kTextStyle.copyWith(color: kWhiteTextColor),
                            ),
                          ).onTap(() {
                            brandNameController.clear();
                            finish(context);
                          }),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: kGreenTextColor),
                            child: Text(
                              lang.S.of(context).submit,
                              style: kTextStyle.copyWith(color: kWhiteTextColor),
                            ),
                          ).onTap(() async {
                            if (brandValidateAndSave()) {
                              try {
                                EasyLoading.show(status: 'Adding Brand');
                                final DatabaseReference categoryInformationRef = FirebaseDatabase.instance.ref().child(await getUserID()).child('Brands');
                                BrandsModel brandModel = BrandsModel(brandNameController.text);
                                await categoryInformationRef.push().set(brandModel.toJson());
                                ref.refresh(brandProvider);
                                setState(() {
                                  // selectedBrand = brandModel.brandName;
                                  // brandName.clear();
                                });
                                brandNameController.clear();
                                EasyLoading.showSuccess("Successfully Added");
                                finish(context);
                              } catch (e) {
                                EasyLoading.showError('Error');
                              }
                            }
                          })
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  void showUnitPopUp({required WidgetRef ref, required List<String> unitNameList, required BuildContext addProductsContext}) {
    GlobalKey<FormState> unitNameKey = GlobalKey<FormState>();
    bool unitValidateAndSave() {
      final form = unitNameKey.currentState;
      if (form!.validate()) {
        form.save();
        return true;
      }
      return false;
    }

    showDialog(
        barrierDismissible: true,
        context: addProductsContext,
        builder: (BuildContext context) {
          return Dialog(
            surfaceTintColor: kWhiteTextColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: SizedBox(
              width: 600,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: const BoxDecoration(shape: BoxShape.rectangle),
                          child: const Icon(
                            FeatherIcons.plus,
                            color: kTitleColor,
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          lang.S.of(context).addUnit,
                          style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        const Icon(
                          FeatherIcons.x,
                          color: kTitleColor,
                          size: 21.0,
                        ).onTap(() {
                          unitNameController.clear();
                          descriptionController.clear();
                          finish(context);
                        })
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Divider(
                      thickness: 1.0,
                      color: kGreyTextColor.withOpacity(0.2),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Text(
                          lang.S.of(context).unitName,
                          style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0),
                        ),
                        const SizedBox(width: 50),
                        Form(
                          key: unitNameKey,
                          child: SizedBox(
                            width: 400,
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmptyOrNull) {
                                  return 'Unit name is required.';
                                } else if (unitNameList.contains(value.removeAllWhiteSpace().toLowerCase())) {
                                  return 'Unit name is already exist.';
                                } else {
                                  return null;
                                }
                              },
                              controller: unitNameController,
                              showCursor: true,
                              cursorColor: kTitleColor,
                              decoration: kInputDecoration.copyWith(
                                errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                labelText: lang.S.of(context).unitName,
                                hintText: lang.S.of(context).enterUnitName,
                                hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5.0),
                    Divider(
                      thickness: 1.0,
                      color: kGreyTextColor.withOpacity(0.2),
                    ),
                    const SizedBox(height: 5.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: kRedTextColor),
                          child: Text(
                            lang.S.of(context).cancel,
                            style: kTextStyle.copyWith(color: kWhiteTextColor),
                          ),
                        ).onTap(() {
                          unitNameController.clear();
                          finish(context);
                        }),
                        const SizedBox(width: 5.0),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: kGreenTextColor),
                          child: Text(
                            lang.S.of(context).submit,
                            style: kTextStyle.copyWith(color: kWhiteTextColor),
                          ),
                        ).onTap(() async {
                          if (unitValidateAndSave()) {
                            try {
                              EasyLoading.show(status: 'Adding Units');
                              final DatabaseReference categoryInformationRef = FirebaseDatabase.instance.ref().child(await getUserID()).child('Units');
                              UnitModel unitModel = UnitModel(unitNameController.text);
                              await categoryInformationRef.push().set(unitModel.toJson());
                              ref.refresh(unitProvider);
                              setState(() {
                                unitTime = 0;
                                extraAddedUnits.clear();
                                selectedUnit = unitModel.unitName;
                              });
                              unitNameController.clear();
                              EasyLoading.showSuccess("Successfully Added");
                              finish(context);
                            } catch (e) {
                              EasyLoading.showError('Error');
                            }
                          }
                        })
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Uint8List? image;



  Future<void> uploadFile() async {
    // File file = File(filePath);
    if (kIsWeb) {
      try {
        Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
        // File? file = await ImagePickerWeb.getImageAsFile();
        if (bytesFromPicker!.isNotEmpty) {
          EasyLoading.show(
            status: 'Uploading... ',
            dismissOnTap: false,
          );
        }
        var snapshot = await FirebaseStorage.instance.ref('Profile Picture/${DateTime.now().millisecondsSinceEpoch}').putData(bytesFromPicker);
        var url = await snapshot.ref.getDownloadURL();
        EasyLoading.showSuccess('Upload Successful!');
        setState(() {
          image = bytesFromPicker;
          productPicture = url.toString();
        });
      } on firebase_core.FirebaseException catch (e) {
        EasyLoading.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.code.toString())));
      }
    }
  }

  List<String> extraAddedUnits = [];
  List<String> allUnitList = [
    "PIECES (Pcs)",
    "BAGS (Bag)",
    "BOX ( Box )",
    "PACKS (Pac)",
    "PAIRS (Prs)",
    "LITRE (Ltr)",
    "CANS (Can)",
    "ROLLS (Rol)",
    "QUINTAL (Qtl)",
    "CARTONS (Ctn)",
    "DOZENS (Dzn)",
    "MILILITRE (Mr)",
    "BOTTLES (Blt)",
    "BUNDLES (Bdl)",
    "GRAMMES (Gm)",
    "KILOGRAMS (Kg)",
    "NUMBERS (Nos)",
    "TABLETS (Tbs)",
    "SQUARE FEET (Sqf)",
    "SQUARE METERS (Sqm)"
  ];

  String? selectedBrand;
  String? selectedCategories;
  String? selectedUnit = 'PIECES (Pcs)';


  String productSalePrice = '';
  String productPurchasePrice = '';
  String productDealerPrice = '';
  String productWholeSalePrice = '';

  TextEditingController productNameController = TextEditingController();
  TextEditingController productCodeController = TextEditingController();
  TextEditingController productQuantityController = TextEditingController();
  TextEditingController productSalePriceController = TextEditingController();
  TextEditingController productPurchasePriceController = TextEditingController();
  TextEditingController productDiscountPriceController = TextEditingController(text: '');
  TextEditingController productWholesalePriceController = TextEditingController(text: '');
  TextEditingController productDealerPriceController = TextEditingController(text: '');
  TextEditingController productManufacturerController = TextEditingController(text: '');
  TextEditingController productSerialNumberController = TextEditingController(text: '');

  TextEditingController itemCategoryController = TextEditingController();
  TextEditingController brandNameController = TextEditingController();
  TextEditingController unitNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  TextEditingController sizeController = TextEditingController(text: '');
  TextEditingController colorController = TextEditingController(text: '');
  TextEditingController weightController = TextEditingController(text: '');
  TextEditingController capacityController = TextEditingController(text: '');
  TextEditingController typeController = TextEditingController(text: '');
  TextEditingController warrantyController = TextEditingController(text: '');
  final TextEditingController _textEditingController = TextEditingController(text:'');


  late String productKey;

  void getProductKey(String code) async {
    // ignore: unused_local_variable
    List<ProductModel> productList = [];
    await FirebaseDatabase.instance.ref(await getUserID()).child('Products').orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = jsonDecode(jsonEncode(element.value));
        if (data['productCode'].toString() == code) {
          productKey = element.key.toString();
        }
      }
    });
  }

  late ProductModel productModel;

  // String purchasePrice=Product.productModel;
  // String salePrice=productModel.productSalePrice;
  // String dealerPrice=productModel.productDealerPrice;
  // String wholeSalePrice=productModel.productWholeSalePrice;

  @override
  void initState() {
    productModel = widget.productModel;
    productCodeController.text = widget.productModel.productCode;
    productNameController.text = widget.productModel.productName;
    productSalePriceController.text = widget.productModel.productSalePrice;
    productPurchasePriceController.text = widget.productModel.productPurchasePrice;
    productDiscountPriceController.text = widget.productModel.productDiscount;
    productWholesalePriceController.text = widget.productModel.productWholeSalePrice;
    productDealerPriceController.text = widget.productModel.productDealerPrice;
    productManufacturerController.text = widget.productModel.productManufacturer;
    sizeController.text = widget.productModel.size;
    colorController.text = widget.productModel.color;
    weightController.text = widget.productModel.weight;
    capacityController.text = widget.productModel.capacity;
    typeController.text = widget.productModel.type;
    warrantyController.text = widget.productModel.warranty.getNumericOnly();
    getProductKey(widget.productModel.productCode);
    if (!widget.productModel.warranty.isEmptyOrNull) {
      if (widget.productModel.warranty.contains('Month')) {
        selectedTime = 'Month';
      } else if (widget.productModel.warranty.contains('Year')) {
        selectedTime = 'Year';
      } else {
        selectedTime = 'Day';
      }
    }
    if (widget.productModel.expiringDate != null) {
      expireDateTextEditingController.text = DateFormat.yMMMd().format(DateTime.parse(widget.productModel.expiringDate!));
      expireDate = widget.productModel.expiringDate;
    }
    if (widget.productModel.manufacturingDate != null) {
      manufactureDateTextEditingController.text = DateFormat.yMMMd().format(DateTime.parse(widget.productModel.manufacturingDate!));
      manufactureDate = widget.productModel.manufacturingDate;
    }

    lowerStockAlert = widget.productModel.lowerStockAlert;

    productPicture = widget.productModel.productPicture;

    widget.productModel.serialNumber.isNotEmpty ? isSerialNumberTaken = true : isSerialNumberTaken = false;
    super.initState();
  }

  ScrollController mainScroll = ScrollController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkWhite,
      body: Scrollbar(
        controller: mainScroll,
        child: SingleChildScrollView(
          controller: mainScroll,
          scrollDirection: Axis.horizontal,
          child: Consumer(
            builder: (context, ref, __) {
              final unitList = ref.watch(unitProvider);
              final brandList = ref.watch(brandProvider);
              final categoryList = ref.watch(categoryProvider);
              final wareHouseList = ref.watch(warehouseProvider);
              selectedCategories=widget.productModel.productCategory;
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 240,
                    child: SideBarWidget(
                      index: 3,
                      isTab: false,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width < 1275 ? 1275 - 240 : MediaQuery.of(context).size.width - 240,
                    // width: context.width() < 1080 ? 1080 - 240 : MediaQuery.of(context).size.width - 240,
                    decoration: const BoxDecoration(color: kDarkWhite),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //_______________________________top_bar____________________________
                          const TopBar(),

                          const SizedBox(height: 20.0),
                          Container(
                            decoration: const BoxDecoration(color: kDarkWhite),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    lang.S.of(context).addProduct,
                                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 20.0),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ///___________edit_______________________________________________
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
                                            key: addProductFormKey,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 10.0),

                                                ///________Name_And_Category_____________________________________________
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: TextFormField(
                                                        validator: (value) {
                                                          if (value.removeAllWhiteSpace().isEmptyOrNull) {
                                                            return 'Product name is required.';
                                                          } else if (widget.allProductsNameList.contains(value.removeAllWhiteSpace().toLowerCase()) &&
                                                              widget.productModel.productName != value) {
                                                            return 'Product Name already exist.';
                                                          } else {
                                                            return null;
                                                          }
                                                        },
                                                        onSaved: (value) {
                                                          productNameController.text = value!;
                                                        },
                                                        showCursor: true,
                                                        controller: productNameController,
                                                        cursorColor: kTitleColor,
                                                        decoration: kInputDecoration.copyWith(
                                                          errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                          labelText: lang.S.of(context).productNam,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          hintText: lang.S.of(context).enterProductName,
                                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 20.0),
                                                    categoryList.when(
                                                      data: (category) {
                                                        List<String> editNameList = [];
                                                        List<String> categoryName = [];
                                                        // if (category.isEmpty) {
                                                        //   // postGeneralCategory();
                                                        //   ref.refresh(categoryProvider);
                                                        // }
                                                        // categoryTime == 0
                                                        //     // ignore: avoid_function_literals_in_foreach_calls
                                                        //     ? category.forEach((element) {
                                                        //
                                                        //         editNameList.add(element.categoryName.removeAllWhiteSpace().toLowerCase());
                                                        //         categoryTime++;
                                                        //       })
                                                        //     : null;
                                                        for (var element in category) {
                                                          categoryName.add(element.categoryName);
                                                          editNameList.add(element.categoryName.toLowerCase().removeAllWhiteSpace());
                                                        }
                                                        return Expanded(
                                                          child: FormField(
                                                            builder: (FormFieldState<dynamic> field) {
                                                              return InputDecorator(
                                                                decoration: InputDecoration(
                                                                    enabledBorder: const OutlineInputBorder(
                                                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                                      borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                                                                    ),
                                                                    suffixIcon: GestureDetector(
                                                                        onTap: () async {
                                                                          await addCategoryShowPopUp(
                                                                              ref: ref, categoryNameList: editNameList, addProductContext: context);
                                                                        },
                                                                        child: const Icon(FeatherIcons.plus, color: kTitleColor)),
                                                                    contentPadding: const EdgeInsets.all(8.0),
                                                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                                                    labelText: lang.S.of(context).category),
                                                                child: Theme(
                                                                    data: ThemeData(
                                                                        highlightColor: dropdownItemColor,
                                                                        focusColor: dropdownItemColor,
                                                                        hoverColor: dropdownItemColor),
                                                                    child: DropdownButtonHideUnderline(
                                                                      child: DropdownButton2<String>(
                                                                        isExpanded: true,
                                                                        hint: Text(
                                                                          'Select Category',
                                                                          style: TextStyle(
                                                                            fontSize: 14,
                                                                            color: Theme.of(context).hintColor,
                                                                          ),
                                                                        ),
                                                                        items: categoryName.map((String items) {
                                                                          return DropdownMenuItem(
                                                                            value: items,
                                                                            child: Text(items),
                                                                          );
                                                                        }).toList(),
                                                                        value: selectedCategories,
                                                                        onChanged: (String? value) {
                                                                          setState(() {
                                                                            selectedCategories = value!;
                                                                            for (var element in category) {
                                                                              if (element.categoryName == selectedCategories) {
                                                                                isSizedBoxShow = element.size;
                                                                                isColoredBoxShow = element.color;
                                                                                isWeightsBoxShow = element.weight;
                                                                                isCapacityBoxShow = element.capacity;
                                                                                isTypeBoxShow = element.type;
                                                                                isWarrantyBoxShow = element.warranty;
                                                                              }
                                                                            }
                                                                            toast(selectedCategories);
                                                                          });
                                                                        },
                                                                        buttonStyleData: const ButtonStyleData(
                                                                          padding: EdgeInsets.symmetric(horizontal: 16),
                                                                          height: 50,
                                                                          width: 200,
                                                                        ),
                                                                        dropdownStyleData: const DropdownStyleData(
                                                                          maxHeight: 550,
                                                                        ),
                                                                        menuItemStyleData: const MenuItemStyleData(
                                                                          height: 30,
                                                                        ),
                                                                        dropdownSearchData: DropdownSearchData(
                                                                          searchController: itemCategoryController,
                                                                          searchInnerWidgetHeight: 150,
                                                                          searchInnerWidget: Container(
                                                                            height: 50,
                                                                            padding: const EdgeInsets.only(
                                                                              top: 8,
                                                                              bottom: 4,
                                                                              right: 8,
                                                                              left: 8,
                                                                            ),
                                                                            child: TextFormField(
                                                                              expands: true,
                                                                              maxLines: null,
                                                                              controller: itemCategoryController,
                                                                              decoration: InputDecoration(
                                                                                isDense: true,
                                                                                contentPadding: const EdgeInsets.symmetric(
                                                                                  horizontal: 10,
                                                                                  vertical: 8,
                                                                                ),
                                                                                hintText: 'Element qidirish...',
                                                                                hintStyle: const TextStyle(fontSize: 12),
                                                                                border: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.circular(8),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          searchMatchFn: (item, searchValue) {
                                                                            return item.value.toString().toLowerCase().contains(searchValue.toLowerCase());
                                                                          },
                                                                        ),
                                                                        //This to clear the search value when you close the menu
                                                                        onMenuStateChange: (isOpen) {
                                                                          if (!isOpen) {
                                                                            itemCategoryController.clear();
                                                                          }
                                                                        },
                                                                      ),

                                                                      // hint: const Text('Select Category'),

                                                                      // onChanged: (String? value) {
                                                                      //   setState(() {
                                                                      //     selectedCategories = value!;
                                                                      //     for (var element in category) {
                                                                      //       if (element.categoryName == selectedCategories) {
                                                                      //         isSizedBoxShow = element.size;
                                                                      //         isColoredBoxShow = element.color;
                                                                      //         isWeightsBoxShow = element.weight;
                                                                      //         isCapacityBoxShow = element.capacity;
                                                                      //         isTypeBoxShow = element.type;
                                                                      //         isWarrantyBoxShow = element.warranty;
                                                                      //       }
                                                                      //     }
                                                                      //     toast(selectedCategories);
                                                                      //   });
                                                                      // },
                                                                      // value: selectedCategories,
                                                                      // items: categoryName.map((String items) {
                                                                      //   return DropdownMenuItem(
                                                                      //     value: items,
                                                                      //     child: Text(items),
                                                                      //   );
                                                                      // }).toList(),
                                                                    )),
                                                                // ),
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      },
                                                      error: (e, stack) {
                                                        return Center(
                                                          child: Text(
                                                            e.toString(),
                                                          ),
                                                        );
                                                      },
                                                      loading: () {
                                                        return const Center(
                                                          child: CircularProgressIndicator(),
                                                        );
                                                      },
                                                    ),
                                                    // Expanded(
                                                    //   child: TextFormField(
                                                    //     readOnly: true,
                                                    //     initialValue: widget.productModel.productCategory,
                                                    //     cursorColor: kTitleColor,
                                                    //     decoration: kInputDecoration.copyWith(
                                                    //       errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                    //       labelText: lang.S.of(context).productCategory,
                                                    //       labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                    //       hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                                const SizedBox(height: 20.0),

                                                ///________Size_&_Color____________________________________________________
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: AppTextField(
                                                        validator: (value) {
                                                          return null;
                                                        },
                                                        showCursor: true,
                                                        controller: sizeController,
                                                        cursorColor: kTitleColor,
                                                        textFieldType: TextFieldType.NAME,
                                                        decoration: kInputDecoration.copyWith(
                                                          labelText: lang.S.of(context).productSize,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          hintText: lang.S.of(context).enterProductSize,
                                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                        ),
                                                      ),
                                                    ).visible(widget.productModel.size.isNotEmpty),
                                                    const SizedBox(width: 20).visible(widget.productModel.color.isNotEmpty && widget.productModel.size.isNotEmpty),
                                                    Expanded(
                                                      child: AppTextField(
                                                        validator: (value) {
                                                          return null;
                                                        },
                                                        showCursor: true,
                                                        controller: colorController,
                                                        cursorColor: kTitleColor,
                                                        textFieldType: TextFieldType.NAME,
                                                        decoration: kInputDecoration.copyWith(
                                                          labelText: lang.S.of(context).productColor,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          hintText: lang.S.of(context).enterProductColor,
                                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                        ),
                                                      ),
                                                    ).visible(widget.productModel.color.isNotEmpty),
                                                  ],
                                                ),

                                                ///_____________Weight_&_Capacity___________________________________________
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top: 20.0),
                                                        child: AppTextField(
                                                          validator: (value) {
                                                            return null;
                                                          },
                                                          showCursor: true,
                                                          controller: weightController,
                                                          cursorColor: kTitleColor,
                                                          textFieldType: TextFieldType.NAME,
                                                          decoration: kInputDecoration.copyWith(
                                                            labelText: lang.S.of(context).productWeight,
                                                            labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                            hintText: lang.S.of(context).enterProductWeight,
                                                            hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                          ),
                                                        ),
                                                      ),
                                                    ).visible(widget.productModel.weight.isNotEmpty),
                                                    const SizedBox(width: 20).visible(widget.productModel.weight.isNotEmpty && widget.productModel.capacity.isNotEmpty),
                                                    Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top: 20.0),
                                                        child: AppTextField(
                                                          validator: (value) {
                                                            return null;
                                                          },
                                                          showCursor: true,
                                                          controller: capacityController,
                                                          cursorColor: kTitleColor,
                                                          textFieldType: TextFieldType.NAME,
                                                          decoration: kInputDecoration.copyWith(
                                                            labelText: lang.S.of(context).productcapacity,
                                                            labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                            hintText: lang.S.of(context).enterProductCapacity,
                                                            hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                          ),
                                                        ),
                                                      ),
                                                    ).visible(widget.productModel.capacity.isNotEmpty),
                                                  ],
                                                ),

                                                ///_____________Type_&_Warranty___________________________________________
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                                                        child: AppTextField(
                                                          validator: (value) {
                                                            return null;
                                                          },
                                                          showCursor: true,
                                                          controller: typeController,
                                                          cursorColor: kTitleColor,
                                                          textFieldType: TextFieldType.NAME,
                                                          decoration: kInputDecoration.copyWith(
                                                            labelText: lang.S.of(context).productType,
                                                            labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                            hintText: lang.S.of(context).enterProductType,
                                                            hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                          ),
                                                        ),
                                                      ),
                                                    ).visible(widget.productModel.type.isNotEmpty),
                                                    const SizedBox(width: 20).visible(widget.productModel.type.isNotEmpty && widget.productModel.warranty.isNotEmpty),
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                                                              child: TextFormField(
                                                                validator: (value) {
                                                                  if (double.tryParse(value!) == null && !value.isEmptyOrNull) {
                                                                    return 'Enter Quantity in number.';
                                                                  } else {
                                                                    return null;
                                                                  }
                                                                },
                                                                onSaved: (value) {
                                                                  warrantyController.text = value!;
                                                                },
                                                                showCursor: true,
                                                                controller: warrantyController,
                                                                cursorColor: kTitleColor,
                                                                decoration: kInputDecoration.copyWith(
                                                                  errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                                  labelText: lang.S.of(context).productWaranty,
                                                                  labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                                  hintText: lang.S.of(context).enterWarranty,
                                                                  hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(width: 4),
                                                          SizedBox(
                                                            width: 220,
                                                            child: FormField(
                                                              builder: (FormFieldState<dynamic> field) {
                                                                return InputDecorator(
                                                                  decoration: InputDecoration(
                                                                    enabledBorder: const OutlineInputBorder(
                                                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                                      borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                                                                    ),
                                                                    contentPadding: EdgeInsets.all(8.0),
                                                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                                                    labelText: lang.S.of(context).warranty,
                                                                  ),
                                                                  child: DropdownButtonHideUnderline(
                                                                      child: DropdownButton<String>(
                                                                    onChanged: (String? value) {
                                                                      setState(() {
                                                                        selectedTime = value!;
                                                                      });
                                                                    },
                                                                    hint: Text(lang.S.of(context).selectWarrantyTime),
                                                                    value: selectedTime,
                                                                    items: warrantyTime.map((String items) {
                                                                      return DropdownMenuItem(
                                                                        value: items,
                                                                        child: Text(items),
                                                                      );
                                                                    }).toList(),
                                                                  )),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ).visible(widget.productModel.warranty.isNotEmpty),
                                                  ],
                                                ),

                                                ///_______brand_&_ProductCode________________________________________
                                                const SizedBox(height: 10),

                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: TextFormField(
                                                        initialValue: widget.productModel.brandName,
                                                        readOnly: true,
                                                        cursorColor: kTitleColor,
                                                        decoration: kInputDecoration.copyWith(
                                                          errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                          labelText: lang.S.of(context).brandName,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          hintText: lang.S.of(context).enterBrandName,
                                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 20.0),
                                                    Expanded(
                                                      child: TextFormField(

                                                        onSaved: (value) {
                                                          if (value.removeAllWhiteSpace().isEmptyOrNull) {
                                                            //  productCodeController.text = '';
                                                            // } else {
                                                            productCodeController.text = value!;
                                                          }
                                                        },
                                                        showCursor: true,
                                                        controller: productCodeController,
                                                        // initialValue: widget.productModel.productCode,
                                                        cursorColor: kTitleColor,
                                                        decoration: kInputDecoration.copyWith(
                                                          errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                          labelText: lang.S.of(context).productCod,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          hintText: lang.S.of(context).enterProductCode,
                                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                          suffixIcon: const Icon(
                                                            Icons.scanner,
                                                            color: kTitleColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 20.0),

                                                ///______quantity_&_Unit______________________________________________
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: TextFormField(
                                                        initialValue: widget.productModel.productStock,
                                                        cursorColor: kTitleColor,
                                                        decoration: kInputDecoration.copyWith(
                                                          errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                          labelText: lang.S.of(context).Quantity,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          hintText: lang.S.of(context).enterProductQuantity,
                                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 20.0),
                                                    Expanded(
                                                      child: TextFormField(
                                                        initialValue: widget.productModel.productUnit,
                                                        readOnly: true,
                                                        cursorColor: kTitleColor,
                                                        decoration: kInputDecoration.copyWith(
                                                          errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                          labelText: lang.S.of(context).productUnit,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          hintText: lang.S.of(context).enterProductUnit,
                                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 20.0),

                                                ///__________Sale_Price_&_Purchase_Price_______________________________
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: TextFormField(
                                                        validator: (value) {
                                                          if (value.removeAllWhiteSpace().isEmptyOrNull) {
                                                            return 'Product Purchase Price is required.';
                                                          } else if (double.tryParse(value!) == null) {
                                                            return 'Enter price in number.';
                                                          } else {
                                                            return null;
                                                          }
                                                        },
                                                        onSaved: (value) {
                                                          productPurchasePriceController.text = value!;
                                                        },
                                                        controller: productPurchasePriceController,
                                                        showCursor: true,
                                                        cursorColor: kTitleColor,
                                                        decoration: kInputDecoration.copyWith(
                                                          errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                          labelText: lang.S.of(context).purchasePrice,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          hintText: lang.S.of(context).enterPurchasePrice,
                                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 20.0),
                                                    Expanded(
                                                      child: TextFormField(
                                                        validator: (value) {
                                                          if (value.removeAllWhiteSpace().isEmptyOrNull) {
                                                            return 'Product Sale Price is required.';
                                                          } else if (double.tryParse(value!) == null) {
                                                            return 'Enter price in number.';
                                                          } else {
                                                            return null;
                                                          }
                                                        },
                                                        onSaved: (value) {
                                                          productSalePriceController.text = value!;
                                                        },
                                                        controller: productSalePriceController,
                                                        showCursor: true,
                                                        cursorColor: kTitleColor,
                                                        decoration: kInputDecoration.copyWith(
                                                          errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                          labelText: lang.S.of(context).salePrices,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          hintText: lang.S.of(context).enterSalePrice,
                                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 20.0),

                                                ///__________Dealer &_Wholesele_Price______________________________________
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: TextFormField(
                                                        validator: (value) {
                                                          if (double.tryParse(value!) == null && !value.isEmptyOrNull) {
                                                            return 'Enter price in number.';
                                                          } else {
                                                            return null;
                                                          }
                                                        },
                                                        onSaved: (value) {
                                                          productDealerPriceController.text = value!;
                                                        },
                                                        controller: productDealerPriceController,
                                                        showCursor: true,
                                                        cursorColor: kTitleColor,
                                                        decoration: kInputDecoration.copyWith(
                                                          errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                          labelText: lang.S.of(context).dealerPrice,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          hintText: lang.S.of(context).enterDealePrice,
                                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 20.0),
                                                    Expanded(
                                                      child: TextFormField(
                                                        validator: (value) {
                                                          if (double.tryParse(value!) == null && !value.isEmptyOrNull) {
                                                            return 'Enter price in number.';
                                                          } else {
                                                            return null;
                                                          }
                                                        },
                                                        onSaved: (value) {
                                                          productWholesalePriceController.text = value!;
                                                        },
                                                        controller: productWholesalePriceController,
                                                        showCursor: true,
                                                        cursorColor: kTitleColor,
                                                        decoration: kInputDecoration.copyWith(
                                                          errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                          labelText: lang.S.of(context).wholeSaleprice,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          hintText: lang.S.of(context).enterPrice,
                                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 20.0),

                                                ///________Manufacturer_______________________________________________
                                                SizedBox(
                                                  child: TextFormField(
                                                    validator: (value) {
                                                      return null;
                                                    },
                                                    onSaved: (value) {
                                                      productManufacturerController.text = value!;
                                                    },
                                                    controller: productManufacturerController,
                                                    showCursor: true,
                                                    cursorColor: kTitleColor,
                                                    decoration: kInputDecoration.copyWith(
                                                      labelText: lang.S.of(context).manufacturer,
                                                      labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                      hintText: lang.S.of(context).enterManufacturerName,
                                                      hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                    ),
                                                  ),
                                                ).visible(false),
                                                const SizedBox(height: 20.0),
                                                ///______________ExpireDate______________________
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        child: AppTextField(
                                                          textFieldType: TextFieldType.NAME,
                                                          readOnly: true,
                                                          validator: (value) {
                                                            return null;
                                                          },
                                                          controller: manufactureDateTextEditingController,
                                                          decoration:  kInputDecoration.copyWith(
                                                            floatingLabelBehavior: FloatingLabelBehavior.always,
                                                            labelText: "Manufacture Date",
                                                            hintText: 'Enter Date',
                                                            labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                            hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                            border: const OutlineInputBorder(),
                                                            suffixIcon: IconButton(
                                                              onPressed: () async {
                                                                final DateTime? picked = await showDatePicker(
                                                                  // initialDate: DateTime.now(),
                                                                  firstDate: DateTime(2015, 8),
                                                                  lastDate: DateTime(2101),
                                                                  context: context,
                                                                );
                                                                setState(() {
                                                                  picked != null ?   manufactureDateTextEditingController.text = DateFormat.yMMMd().format(picked):null;
                                                                  picked != null ? manufactureDate = picked.toString():null;
                                                                });
                                                              },
                                                              icon: const Icon(FeatherIcons.calendar),
                                                            ),
                                                          ),
                                                        )
                                                    ),
                                                    const SizedBox(width: 20,),
                                                    Expanded(
                                                      child: AppTextField(
                                                        textFieldType: TextFieldType.NAME,
                                                        readOnly: true,
                                                        validator: (value) {
                                                          return null;
                                                        },
                                                        controller: expireDateTextEditingController,
                                                        decoration:  kInputDecoration.copyWith(
                                                          floatingLabelBehavior: FloatingLabelBehavior.always,
                                                          labelText: 'Expire Date',
                                                          hintText: 'Enter Date',
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                          border: const OutlineInputBorder(),
                                                          suffixIcon: IconButton(
                                                            onPressed: () async {
                                                              final DateTime? picked = await showDatePicker(
                                                                // initialDate: DateTime.now(),
                                                                firstDate: DateTime(2015, 8),
                                                                lastDate: DateTime(2101),
                                                                context: context,
                                                              );
                                                              setState(() {
                                                                picked != null ? expireDateTextEditingController.text = DateFormat.yMMMd().format(picked) : null;
                                                                picked != null ? expireDate = picked.toString():null;
                                                              });
                                                            },
                                                            icon: const Icon(FeatherIcons.calendar),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ).visible(false),
                                                const SizedBox(height: 20.0),

                                                ///_______Lower_stock___________________________
                                                TextFormField(
                                                  initialValue: lowerStockAlert.toString(),
                                                  onSaved: (value) {
                                                    lowerStockAlert = int.tryParse(value ?? '') ?? 5;
                                                  },
                                                  decoration:   kInputDecoration.copyWith(
                                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                                    labelText: 'Low Stock Alert',
                                                    hintText: 'Enter Low Stock Alert Quantity',
                                                    border: const OutlineInputBorder(),
                                                  ),
                                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                ),
                                                const SizedBox(height: 20.0),

                                                ///_________product_serial____________________________________________
                                                Row(
                                                  children: [
                                                    Text(lang.S.of(context).enterSerialNumber),
                                                    const SizedBox(
                                                      width: 30,
                                                    ),
                                                    CupertinoSwitch(
                                                        value: isSerialNumberTaken,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            isSerialNumberTaken = value;
                                                          });
                                                        })
                                                  ],
                                                ),
                                                const SizedBox(height: 20.0),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Expanded(
                                                      child: AppTextField(
                                                        validator: (value) {
                                                          return null;
                                                        },
                                                        controller: productSerialNumberController,
                                                        showCursor: true,
                                                        cursorColor: kTitleColor,
                                                        onFieldSubmitted: (value) {
                                                          if (isSerialNumberUnique(allList: widget.productModel.serialNumber, newSerial: value)) {
                                                            setState(() {
                                                              widget.productModel.serialNumber.add(value);
                                                            });
                                                            productSerialNumberController.clear();
                                                          } else {
                                                            EasyLoading.showError('Serial number already added!');
                                                          }
                                                        },
                                                        textFieldType: TextFieldType.NAME,
                                                        decoration: kInputDecoration.copyWith(
                                                          labelText: lang.S.of(context).serialNumber,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          hintText: lang.S.of(context).enterSerialNumber,
                                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),

                                                    ///__________serial_add_button_______________________________________________
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (isSerialNumberUnique(allList: widget.productModel.serialNumber, newSerial: productSerialNumberController.text)) {
                                                          setState(() {
                                                            widget.productModel.serialNumber.add(productSerialNumberController.text);
                                                          });
                                                          productSerialNumberController.clear();
                                                        } else {
                                                          EasyLoading.showError('Serial number already added!');
                                                        }
                                                      },
                                                      child: Container(
                                                        width: 70,
                                                        height: 53,
                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: kMainColor),
                                                        child: Center(
                                                          child: Text(
                                                            lang.S.of(context).add,
                                                            style: TextStyle(color: Colors.white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Container(
                                                      width: 400,
                                                      height: 150,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(width: 1, color: Colors.grey),
                                                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                      ),
                                                      child: GridView.builder(
                                                          shrinkWrap: true,
                                                          itemCount: productModel.serialNumber.length,
                                                          itemBuilder: (BuildContext context, int index) {
                                                            if (productModel.serialNumber.isNotEmpty) {
                                                              return Padding(
                                                                padding: const EdgeInsets.all(5.0),
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(
                                                                      width: 170,
                                                                      child: Text(
                                                                        productModel.serialNumber[index],
                                                                        maxLines: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                        setState(() {
                                                                          productModel.serialNumber.removeAt(index);
                                                                        });
                                                                      },
                                                                      child: const Icon(
                                                                        Icons.cancel,
                                                                        color: Colors.red,
                                                                        size: 15,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            } else {
                                                              return const Text('No Serial Number Found');
                                                            }
                                                          },
                                                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 2,
                                                            childAspectRatio: 6,
                                                            crossAxisSpacing: .5,
                                                            mainAxisSpacing: .5,
                                                            // mainAxisExtent: 1,
                                                          )),
                                                    ),
                                                  ],
                                                ).visible(isSerialNumberTaken),

                                                ///__________save_Button___________________________________________
                                                const SizedBox(height: 30.0),
                                                Center(
                                                  child: SizedBox(
                                                    width: MediaQuery.of(context).size.width < 1080 ? 1080 * .30 : MediaQuery.of(context).size.width * .30,
                                                    child: ButtonGlobalWithoutIcon(
                                                      buttontext: lang.S.of(context).saveAndPublished,
                                                      buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
                                                      onPressed: () async {
                                                        if(!isDemo){
                                                          if (categoryValidateAndSave()) {
                                                            try {
                                                              EasyLoading.show(status: 'Loading...', dismissOnTap: false);
                                                              final DatabaseReference productInformationRef =
                                                              FirebaseDatabase.instance.ref("${await getUserID()}/Products/$productKey");
                                                              productModel.productName = productNameController.text;
                                                              productModel.size = sizeController.text;
                                                              productModel.color = colorController.text;
                                                              productModel.weight = weightController.text;
                                                              productModel.type = typeController.text;
                                                              // productModel.warranty = warrantyController.text;
                                                              productModel.capacity = capacityController.text;
                                                              //_____price_____________________________________
                                                              productModel.productSalePrice = productSalePriceController.text;
                                                              productModel.productPurchasePrice = productPurchasePriceController.text;
                                                              productModel.productDealerPrice = productDealerPriceController.text;
                                                              productModel.productWholeSalePrice = productWholesalePriceController.text;
                                                              productModel.productCode=productCodeController.text;
                                                              productModel.productManufacturer = productManufacturerController.text;
                                                              productModel.warranty = warrantyController.text == '' ? '' : '${warrantyController.text} $selectedTime';
                                                              productModel.productPicture = productPicture;
                                                              productModel.manufacturingDate = manufactureDate;
                                                              productModel.expiringDate = expireDate;
                                                              productModel.lowerStockAlert = lowerStockAlert;

                                                              await productInformationRef.set(productModel.toJson());
                                                              EasyLoading.showSuccess('Added Successfully', duration: const Duration(milliseconds: 500));
                                                              ref.refresh(productProvider);
                                                              Future.delayed(const Duration(milliseconds: 100), () {
                                                                const Product().launch(context, isNewTask: true);
                                                              });
                                                            } catch (e) {
                                                              EasyLoading.dismiss();
                                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                                                            }
                                                          }
                                                        }else{ EasyLoading.showInfo(demoText);}
                                                      },
                                                      buttonTextColor: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 20.0),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    ///_________image___________________________________________________
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
                                                            ]))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              image != null
                                                  ? Image.memory(
                                                      image!,
                                                      width: 150,
                                                      height: 150,
                                                    )
                                                  : Image.network(
                                                      productPicture,
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
                          const SizedBox(height:20.0),
                          const Footer(),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  bool isSerialNumberUnique({required List<String> allList, required String newSerial}) {
    for (var element in allList) {
      if (element.toLowerCase().removeAllWhiteSpace() == newSerial.toLowerCase().removeAllWhiteSpace()) {
        return false;
      }
    }
    return true;
  }
}
