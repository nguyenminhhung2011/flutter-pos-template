import 'dart:convert';

class AddToCartModel {
  AddToCartModel({
    this.uuid,
    this.productId,
    this.productName,
    required this.warehouseName,
    required this.warehouseId,
    this.unitPrice,
    this.subTotal,
    this.quantity = 1,
    this.productDetails,
    this.itemCartIndex = -1,
    this.uniqueCheck,
    this.productBrandName,
    this.stock,
    required this.productPurchasePrice,
    this.serialNumber,
    this.productWarranty,
    required this.productImage,
  });

  dynamic uuid;
  dynamic productId;
  String? productName;
  String? warehouseName;
  String? warehouseId;
  dynamic unitPrice;
  dynamic subTotal;
  dynamic productPurchasePrice;
  dynamic uniqueCheck;
  int quantity = 1;
  dynamic productDetails;
  dynamic productBrandName;

  // Item store on which index of cart so we can update or delete cart easily, initially it is -1
  int itemCartIndex;
  int? stock;
  late String productImage;
  List<dynamic>? serialNumber;
  String? productWarranty;

  factory AddToCartModel.fromJson(String str) => AddToCartModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AddToCartModel.fromMap(Map<String, dynamic> json) => AddToCartModel(
      uuid: json["uuid"],
      productId: json["product_id"],
      productName: json["product_name"],
      warehouseName: json["warehouseName"],
      warehouseId: json["warehouseId"],
      productBrandName: json["product_brand_name"],
      unitPrice: json["unit_price"],
      subTotal: json["sub_total"],
      uniqueCheck: json["unique_check"],
      quantity: json["quantity"],
      productDetails: json["product_details"],
      itemCartIndex: json["item_cart_index"],
      stock: json["stock"],
      productImage: json["productImage"] ??
          'https://firebasestorage.googleapis.com/v0/b/maanpos.appspot.com/o/Product%20No%20Image%2Fno-image-found-360x250.png?alt=media&token=9299964e-22b3-4d88-924e-5eeb285ae672',
      productPurchasePrice: json["productPurchasePrice"],
      serialNumber: json["serialNumber"],
      productWarranty: json['productWarranty']);

  Map<String, dynamic> toMap() => {
        "uuid": uuid,
        "product_id": productId,
        "product_name": productName,
        "warehouseName": warehouseName,
        "warehouseId": warehouseId,
        "unit_price": unitPrice,
        "sub_total": subTotal,
        "unique_check": uniqueCheck,
        "quantity": quantity == 0 ? null : quantity,
        "item_cart_index": itemCartIndex,
        "stock": stock,
        "productPurchasePrice": productPurchasePrice,
        // ignore: prefer_null_aware_operators
        "product_details": productDetails == null ? null : productDetails.toJson(),
        'serialNumber': serialNumber?.map((e) => e).toList(),
        'productWarranty': productWarranty,
        'productImage': productImage,
      };
}
