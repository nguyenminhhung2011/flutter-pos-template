import 'dart:typed_data';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Screen/POS%20Sale/pos_sale.dart';
import '../../../../Provider/product_provider.dart';
import '../../../../const.dart';
import '../../../../model/brands_model.dart';
import '../../../../model/category_model.dart';
import '../../../../model/product_model.dart';
import '../../../../model/unit_model.dart';
import '../../../WareHouse/warehouse_model.dart';
import '../../Constant Data/button_global.dart';
import '../../Constant Data/constant.dart';

class AddItemPopUP extends StatefulWidget {
  const AddItemPopUP({Key? key}) : super(key: key);

  @override
  State<AddItemPopUP> createState() => _AddItemPopUPState();
}

class _AddItemPopUPState extends State<AddItemPopUP> {
  bool isSize = false;
  bool isColor = false;
  bool isWeight = false;
  bool isCapacity = false;
  bool isType = false;
  bool isWarranty = false;
  bool isSized = false;
  bool isColored = false;
  bool isWeights = false;
  bool capacity = false;
  bool type = false;
  bool warranty = false;
  int brandTime = 0;
  int categoryType = 0;
  int unitTime = 0;

  void showPopUp(WidgetRef ref) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: SizedBox(
                width: 600,
                height: context.height() / 1.6,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
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
                            lang.S.of(context).nam,
                            style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0),
                          ),
                          const SizedBox(width: 50),
                          SizedBox(
                            width: 400,
                            child: Expanded(
                              child: AppTextField(
                                controller: itemCategoryController,
                                showCursor: true,
                                cursorColor: kTitleColor,
                                textFieldType: TextFieldType.NAME,
                                decoration: kInputDecoration.copyWith(
                                  hintText: lang.S.of(context).name,
                                  hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
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
                                  setState(
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
                                  setState(
                                    () {
                                      isColor = val!;
                                    },
                                  );
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
                                  setState(
                                    () {
                                      isWeight = val!;
                                    },
                                  );
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
                                  setState(
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
                                  setState(
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
                                  setState(
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
                            EasyLoading.show(status: 'Adding Category');
                            final DatabaseReference categoryInformationRef = FirebaseDatabase.instance
                                // ignore: deprecated_member_use
                                .reference()
                                .child(await getUserID())
                                .child('Categories');
                            CategoryModel categoryModel = CategoryModel(
                                categoryName: itemCategoryController.text,
                                size: isSize,
                                color: isColor,
                                capacity: isCapacity,
                                type: isType,
                                weight: isWeight,
                                warranty: isWarranty);
                            await categoryInformationRef.push().set(categoryModel.toJson());
                            ref.refresh(categoryProvider);
                            setState(() {
                              categoryType = 0;
                              categoryName.clear();
                            });
                            EasyLoading.showSuccess("Successfull");
                            finish(context);
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

  void showBrandPopUp(WidgetRef ref) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: SizedBox(
                width: 600,
                height: context.height() / 2.5,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
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
                            lang.S.of(context).nam,
                            style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0),
                          ),
                          const SizedBox(width: 50),
                          SizedBox(
                            width: 400,
                            child: Expanded(
                              child: AppTextField(
                                controller: brandNameController,
                                showCursor: true,
                                cursorColor: kTitleColor,
                                textFieldType: TextFieldType.NAME,
                                decoration: kInputDecoration.copyWith(
                                  hintText: lang.S.of(context).name,
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
                            EasyLoading.show(status: 'Adding Brand');
                            final DatabaseReference _categoryInformationRef = FirebaseDatabase.instance
                                // ignore: deprecated_member_use
                                .reference()
                                .child(await getUserID())
                                .child('Brands');
                            BrandsModel brandModel = BrandsModel(brandNameController.text);
                            await _categoryInformationRef.push().set(brandModel.toJson());
                            ref.refresh(brandProvider);
                            setState(() {
                              brandTime = 0;
                              brandName.clear();
                            });
                            EasyLoading.showSuccess("Successfull");
                            finish(context);
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

  void showUnitPopUp(WidgetRef ref) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: SizedBox(
              height: 320,
              width: 600,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
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
                          lang.S.of(context).unit,
                          style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0),
                        ),
                        const SizedBox(width: 50),
                        SizedBox(
                          width: 400,
                          child: Expanded(
                            child: AppTextField(
                              controller: unitNameController,
                              showCursor: true,
                              cursorColor: kTitleColor,
                              textFieldType: TextFieldType.NAME,
                              decoration: kInputDecoration.copyWith(
                                hintText: lang.S.of(context).name,
                                hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Text(
                          lang.S.of(context).description,
                          style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0),
                        ),
                        const SizedBox(width: 10.0),
                        SizedBox(
                          width: 400,
                          child: Expanded(
                            child: AppTextField(
                              controller: descriptionController,
                              showCursor: true,
                              cursorColor: kTitleColor,
                              textFieldType: TextFieldType.NAME,
                              decoration: kInputDecoration.copyWith(
                                hintText: lang.S.of(context).description,
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
                          EasyLoading.show(status: 'Adding Units');
                          final DatabaseReference _categoryInformationRef = FirebaseDatabase.instance
                              // ignore: deprecated_member_use
                              .reference()
                              .child(await getUserID())
                              .child('Units');
                          UnitModel unitModel = UnitModel(unitNameController.text);
                          await _categoryInformationRef.push().set(unitModel.toJson());
                          ref.refresh(unitProvider);
                          setState(() {
                            unitTime = 0;
                            unitType.clear();
                          });
                          EasyLoading.showSuccess("Successfull");
                          finish(context);
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

  String profilePicture = 'https://i.imgur.com/jlyGd1j.jpg';

  Uint8List? image;

  Future<void> uploadFile() async {
    // File file = File(filePath);
    if (kIsWeb) {
      try {
        Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
        // File? file = await ImagePickerWeb.getImageAsFile();
        EasyLoading.show(
          status: 'Uploading... ',
          dismissOnTap: false,
        );
        var snapshot = await FirebaseStorage.instance.ref('Profile Picture/${DateTime.now().millisecondsSinceEpoch}').putData(bytesFromPicker!);
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
    'Accessories',
    'Computer',
    'Jacket',
    'T-shirt',
    'Shoes',
    'Fruit',
  ];

  String? selectedCategories;

  List<String> brandName = [];
  List<String> categoryName = [];
  List<String> unitType = [];

  String? selectedBrand;

  List<String> unit = [
    'Kilogram',
    'Meter',
    'Piece',
  ];

  String? selectedUnit;

  String productPicture = 'https://tasteofasia.com.au/uploads/2/products/undefine.jpg';
  TextEditingController productNameController = TextEditingController();
  TextEditingController productCodeController = TextEditingController();
  TextEditingController productStockController = TextEditingController();
  TextEditingController productSalePriceController = TextEditingController();
  TextEditingController productPurchasePriceController = TextEditingController();
  TextEditingController productDiscountPriceController = TextEditingController();
  TextEditingController productWholesalePriceController = TextEditingController();
  TextEditingController productDealerPriceController = TextEditingController();
  TextEditingController productManufacturerController = TextEditingController();

  TextEditingController itemCategoryController = TextEditingController();
  TextEditingController brandNameController = TextEditingController();
  TextEditingController unitNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  TextEditingController sizeController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController capacityController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController warrantyController = TextEditingController();


  WareHouseModel ware = WareHouseModel(warehouseName: 'Select warehouse', warehouseAddress: '', id: '');
  late WareHouseModel selectedWareHouse = ware;

  DropdownButton<WareHouseModel> getAreaName({required List<WareHouseModel> list}) {
    List<DropdownMenuItem<WareHouseModel>> dropDownItems = [
      DropdownMenuItem(
        enabled: false,
        value: ware,
        child: Text(ware.warehouseName),
      )
    ];
    for (var element in list) {
      dropDownItems.add(DropdownMenuItem(
        value: element,
        child: SizedBox(
          width: 110,
          child: Text(
            element.warehouseName,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ));
    }
    return DropdownButton(
      items: dropDownItems,
      value: selectedWareHouse,
      onChanged: (value) {
        setState(() {
          selectedWareHouse = value!;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1000,
      child: Consumer(
        builder: (context, ref, __) {
          final unitList = ref.watch(unitProvider);
          final brandList = ref.watch(brandProvider);
          final categoryList = ref.watch(categoryProvider);
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        lang.S.of(context).addItem,
                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                      const Spacer(),
                      const Icon(FeatherIcons.x, color: kTitleColor, size: 25.0).onTap(() => {finish(context)})
                    ],
                  ),
                ),
                const Divider(thickness: 1.0, color: kLitGreyColor),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              showCursor: true,
                              controller: productNameController,
                              cursorColor: kTitleColor,
                              textFieldType: TextFieldType.NAME,
                              decoration: kInputDecoration.copyWith(
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
                              categoryType == 0
                                  ? category.forEach((element) {
                                      categoryName.add(element.categoryName);
                                      categoryType++;
                                    })
                                  : null;
                              return Expanded(
                                child: FormField(
                                  builder: (FormFieldState<dynamic> field) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                          enabledBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                            borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                                          ),
                                          suffixIcon: const Icon(FeatherIcons.plus, color: kTitleColor).onTap(() => showPopUp(ref)),
                                          contentPadding: const EdgeInsets.all(8.0),
                                          floatingLabelBehavior: FloatingLabelBehavior.always,
                                          labelText: lang.S.of(context).category),
                                      child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                        onChanged: (String? value) {
                                          setState(() {
                                            selectedCategories = value!;
                                            category.forEach((element) {
                                              if (element.categoryName == selectedCategories) {
                                                isSized = element.size;
                                                isColored = element.color;
                                                isWeights = element.weight;
                                                capacity = element.capacity;
                                                type = element.type;
                                                warranty = element.warranty;
                                              }
                                            });
                                            toast(selectedCategories);
                                          });
                                        },
                                        value: selectedCategories,
                                        items: categoryName.map((String items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Text(items),
                                          );
                                        }).toList(),
                                      )),
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
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: AppTextField(
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
                            ),
                          ).visible(isSized),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                              child: AppTextField(
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
                            ),
                          ).visible(isColored),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: AppTextField(
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
                          ).visible(isWeights == true),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: AppTextField(
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
                          ).visible(capacity == true),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                              child: AppTextField(
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
                          ).visible(type),
                          const SizedBox(width: 20).visible(type && warranty),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                              child: AppTextField(
                                showCursor: true,
                                controller: warrantyController,
                                cursorColor: kTitleColor,
                                textFieldType: TextFieldType.NAME,
                                decoration: kInputDecoration.copyWith(
                                  labelText: lang.S.of(context).productWaranty,
                                  labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                  hintText: lang.S.of(context).enterWarranty,
                                  hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                ),
                              ),
                            ),
                          ).visible(warranty),
                        ],
                      ),
                      Row(
                        children: [
                          brandList.when(data: (brand) {
                            brandTime == 0
                                ? brand.forEach((element) {
                                    brandName.add(element.brandName);
                                    brandTime++;
                                  })
                                : null;
                            return Expanded(
                              child: FormField(
                                builder: (FormFieldState<dynamic> field) {
                                  return InputDecorator(
                                    decoration: InputDecoration(
                                        enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                          borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                                        ),
                                        suffixIcon: const Icon(FeatherIcons.plus, color: kTitleColor).onTap(() => showBrandPopUp(ref)),
                                        contentPadding: const EdgeInsets.all(8.0),
                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                        labelText: lang.S.of(context).brand),
                                    child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                      onChanged: (String? value) {
                                        setState(() {
                                          selectedBrand = value!;
                                          toast(selectedBrand);
                                        });
                                      },
                                      value: selectedBrand,
                                      items: brandName.map((String items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(items),
                                        );
                                      }).toList(),
                                    )),
                                  );
                                },
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
                          const SizedBox(width: 20.0),
                          Expanded(
                            child: AppTextField(
                              controller: productCodeController,
                              showCursor: true,
                              cursorColor: kTitleColor,
                              textFieldType: TextFieldType.NAME,
                              decoration: kInputDecoration.copyWith(
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
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: productStockController,
                              showCursor: true,
                              cursorColor: kTitleColor,
                              textFieldType: TextFieldType.NAME,
                              decoration: kInputDecoration.copyWith(
                                labelText: lang.S.of(context).stock,
                                labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                hintText: lang.S.of(context).enterStockAmount,
                                hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          unitList.when(data: (unit) {
                            unitTime == 0
                                ? unit.forEach((element) {
                                    unitType.add(element.unitName);
                                    unitTime++;
                                  })
                                : null;
                            return Expanded(
                              child: FormField(
                                builder: (FormFieldState<dynamic> field) {
                                  return InputDecorator(
                                    decoration: InputDecoration(
                                        suffixIcon: const Icon(FeatherIcons.plus, color: kTitleColor).onTap(() => showUnitPopUp(ref)),
                                        enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                          borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                                        ),
                                        contentPadding: const EdgeInsets.all(8.0),
                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                        labelText: lang.S.of(context).productUnit),
                                    child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                      onChanged: (String? value) {
                                        setState(() {
                                          selectedUnit = value!;
                                          toast(selectedUnit);
                                        });
                                      },
                                      value: selectedUnit,
                                      items: unitType.map((String items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(items),
                                        );
                                      }).toList(),
                                    )),
                                  );
                                },
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
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: productSalePriceController,
                              showCursor: true,
                              cursorColor: kTitleColor,
                              textFieldType: TextFieldType.NAME,
                              decoration: kInputDecoration.copyWith(
                                labelText: lang.S.of(context).salePrice,
                                labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                hintText: lang.S.of(context).enterSalePrice,
                                hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          Expanded(
                            child: AppTextField(
                              controller: productPurchasePriceController,
                              showCursor: true,
                              cursorColor: kTitleColor,
                              textFieldType: TextFieldType.NAME,
                              decoration: kInputDecoration.copyWith(
                                labelText: lang.S.of(context).purchasePrice,
                                labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                hintText: lang.S.of(context).enterPurchasePrice,
                                hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: productDiscountPriceController,
                              showCursor: true,
                              cursorColor: kTitleColor,
                              textFieldType: TextFieldType.NAME,
                              decoration: kInputDecoration.copyWith(
                                labelText: lang.S.of(context).discountPrice,
                                labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                hintText: lang.S.of(context).enterDiscountPrice,
                                hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          Expanded(
                            child: AppTextField(
                              controller: productWholesalePriceController,
                              showCursor: true,
                              cursorColor: kTitleColor,
                              textFieldType: TextFieldType.NAME,
                              decoration: kInputDecoration.copyWith(
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
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: productDealerPriceController,
                              showCursor: true,
                              cursorColor: kTitleColor,
                              textFieldType: TextFieldType.NAME,
                              decoration: kInputDecoration.copyWith(
                                labelText: lang.S.of(context).dealerPrice,
                                labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                hintText: lang.S.of(context).enterDealePrice,
                                hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          Expanded(
                            child: SizedBox(
                              width: (context.width() / 4),
                              child: AppTextField(
                                controller: productManufacturerController,
                                showCursor: true,
                                cursorColor: kTitleColor,
                                textFieldType: TextFieldType.NAME,
                                decoration: kInputDecoration.copyWith(
                                  labelText: lang.S.of(context).manufacturer,
                                  labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                  hintText: lang.S.of(context).enterManufacturerName,
                                  hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      SizedBox(
                        width: 300,
                        child: DottedBorderWidget(
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
                                        TextSpan(text: lang.S.of(context).orDragAndDropPng, style: kTextStyle.copyWith(color: kGreyTextColor, fontWeight: FontWeight.bold))
                                      ]))
                                ],
                              ),
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
                          : Container(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .1,
                            child: ButtonGlobal(
                              buttontext: lang.S.of(context).cancel,
                              buttonDecoration: kButtonDecoration.copyWith(
                                color: kRedTextColor,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(5.0),
                                ),
                              ),
                              onPressed: () {
                                finish(context);
                              },
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .1,
                            child: ButtonGlobalWithoutIcon(
                              buttontext: lang.S.of(context).submit,
                              buttonDecoration: kButtonDecoration.copyWith(
                                color: kBlueTextColor,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(5.0),
                                ),
                              ),
                              onPressed: () async {
                                if (productNameController.text.isEmpty) {
                                  EasyLoading.showError('Please Add A Product name');
                                } else if (productCodeController.text.isEmpty) {
                                  EasyLoading.showError('Please Add A Product code');
                                } else if (selectedCategories.isEmptyOrNull) {
                                  EasyLoading.showError('Please Select a product Category');
                                } else if (selectedBrand.isEmptyOrNull) {
                                  EasyLoading.showError('Please Select a brand');
                                } else if (productStockController.text.isEmpty) {
                                  EasyLoading.showError('Enter stock number');
                                } else if (selectedUnit.isEmptyOrNull) {
                                  EasyLoading.showError('Select unit type');
                                } else if (productSalePriceController.text.isEmpty) {
                                  EasyLoading.showError('Please add sale price');
                                } else if (productPurchasePriceController.text.isEmpty) {
                                  EasyLoading.showError('Please add purchase price');
                                } else {
                                  try {
                                    EasyLoading.show(status: 'Loading...', dismissOnTap: false);
                                    // ignore: no_leading_underscores_for_local_identifiers
                                    final DatabaseReference _productInformationRef = FirebaseDatabase.instance
                                        // ignore: deprecated_member_use
                                        .reference()
                                        .child(await getUserID())
                                        .child('Products');
                                    ProductModel productModel = ProductModel(
                                      productNameController.text,
                                      selectedCategories!,
                                      sizeController.text,
                                      colorController.text,
                                      weightController.text,
                                      capacityController.text,
                                      typeController.text,
                                      warrantyController.text,
                                      selectedBrand!,
                                      productCodeController.text,
                                      productStockController.text,
                                      selectedUnit!,
                                      productSalePriceController.text,
                                      productPurchasePriceController.text,
                                      productDiscountPriceController.text,
                                      productWholesalePriceController.text,
                                      productDealerPriceController.text,
                                      productManufacturerController.text,
                                      selectedWareHouse.warehouseName,
                                      selectedWareHouse.id,
                                      productPicture,
                                      [],
                                      expiringDate: null,
                                      lowerStockAlert: 5,
                                      manufacturingDate: null,
                                    );
                                    await _productInformationRef.push().set(productModel.toJson());
                                    EasyLoading.showSuccess('Added Successfully', duration: const Duration(milliseconds: 500));
                                    ref.refresh(productProvider);
                                    Future.delayed(const Duration(milliseconds: 100), () {
                                      const PosSale().launch(context, isNewTask: true);
                                    });
                                  } catch (e) {
                                    EasyLoading.dismiss();
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                                  }
                                }
                              },
                              buttonTextColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
