class ProductModel {
  late String productName,
      productCategory,
      size,
      color,
      weight,
      capacity,
      type,
      warranty,
      brandName,
      productCode,
      productStock,
      productUnit,
      productSalePrice,
      productPurchasePrice,
      productDiscount,
      productWholeSalePrice,
      productDealerPrice,
      productManufacturer,
      warehouseName,
      warehouseId,
      productPicture;
  String? expiringDate, manufacturingDate;
  late int lowerStockAlert;
  List<String> serialNumber = [];

  ProductModel(
    this.productName,
    this.productCategory,
    this.size,
    this.color,
    this.weight,
    this.capacity,
    this.type,
    this.warranty,
    this.brandName,
    this.productCode,
    this.productStock,
    this.productUnit,
    this.productSalePrice,
    this.productPurchasePrice,
    this.productDiscount,
    this.productWholeSalePrice,
    this.productDealerPrice,
    this.productManufacturer,
    this.warehouseName,
    this.warehouseId,
    this.productPicture,
    this.serialNumber, {
    this.expiringDate,
    required this.lowerStockAlert,
    this.manufacturingDate,
  });

  ProductModel.fromJson(Map<dynamic, dynamic> json) {
    productName = json['productName'] as String;
    productCategory = json['productCategory'].toString();
    size = json['size'].toString();
    color = json['color'].toString();
    weight = json['weight'].toString();
    capacity = json['capacity'].toString();
    type = json['type'].toString();
    warranty = json['warranty'].toString();
    brandName = json['brandName'].toString();
    productCode = json['productCode'].toString();
    productStock = json['productStock'].toString();
    productUnit = json['productUnit'].toString();
    productSalePrice = json['productSalePrice'].toString();
    productPurchasePrice = json['productPurchasePrice'].toString();
    productDiscount = json['productDiscount'].toString();
    productWholeSalePrice = json['productWholeSalePrice'].toString();
    productDealerPrice = json['productDealerPrice'].toString();
    productManufacturer = json['productManufacturer'].toString();
    warehouseName = json['warehouseName'].toString();
    warehouseId = json['warehouseId'].toString();
    productPicture = json['productPicture'].toString();
    if (json['serialNumber'] != null) {
      serialNumber = <String>[];
      json['serialNumber'].forEach((v) {
        serialNumber.add(v);
      });
    }
    expiringDate = json['expiringDate'];
    manufacturingDate = json['manufacturingDate'];
    lowerStockAlert = json['lowerStockAlert'] ?? 5;
  }

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'productName': productName,
        'productCategory': productCategory,
        'size': size,
        'color': color,
        'weight': weight,
        'capacity': capacity,
        'type': type,
        'warranty': warranty,
        'brandName': brandName,
        'productCode': productCode,
        'productStock': productStock,
        'productUnit': productUnit,
        'productSalePrice': productSalePrice,
        'productPurchasePrice': productPurchasePrice,
        'productDiscount': productDiscount,
        'productWholeSalePrice': productWholeSalePrice,
        'productDealerPrice': productDealerPrice,
        'productManufacturer': productManufacturer,
        'warehouseName': warehouseName,
        'warehouseId': warehouseId,
        'productPicture': productPicture,
        'serialNumber': serialNumber.map((e) => e).toList(),
        'manufacturingDate': manufacturingDate,
        'expiringDate': expiringDate,
        'lowerStockAlert': lowerStockAlert,
      };
}
