import 'package:offline_pos/components/export_files.dart';

class Product {
  String? productName;
  String? package;
  ProductType? productType;
  bool? isBundled;
  bool? canBeSold;
  bool? canBePurchased;
  bool? canBeManufactured;
  ReInvoiceExpenses? reInvoiceExpenses;
  InvoicingPolicy? invoicingPolicy;
  String? unitOfMeasure;
  double? baseUnitCount;
  bool? isSecondaryUnit;
  String? purchaseUOM;
  bool? isCommissionBasedServices;
  bool? isThirdUnit;
  double? rebatePercentage;
  double? price;
  double? salePrice;
  double? latestPrice;
  String? productCategory;
  String? productBrand;
  double? qtyInBags;
  double? multipleOfQty;
  String? oldInternalRef;
  String? internalRef;
  String? barcode;
  bool? isClearance;
  ItemType? itemType;
  String? countryCode;
  bool? allowNegativeStock;
  String? company;
  String? tags;
  String? internalNotes;

  Product({
    this.productName,
    this.package,
    this.productType,
    this.isBundled,
    this.canBeSold,
    this.canBePurchased,
    this.canBeManufactured,
    this.reInvoiceExpenses,
    this.invoicingPolicy,
    this.unitOfMeasure,
    this.baseUnitCount,
    this.isSecondaryUnit,
    this.purchaseUOM,
    this.isCommissionBasedServices,
    this.isThirdUnit,
    this.rebatePercentage,
    this.price,
    this.salePrice,
    this.latestPrice,
    this.productCategory,
    this.productBrand,
    this.qtyInBags,
    this.multipleOfQty,
    this.oldInternalRef,
    this.internalRef,
    this.barcode,
    this.isClearance,
    this.itemType,
    this.countryCode,
    this.allowNegativeStock,
    this.company,
    this.tags,
    this.internalNotes,
  });

  Product.fromJson(Map<String, dynamic> json) {
    productName = json['product_name'];
    package = json['package'];
    price = json['price'];
    barcode = json['barcode'];
    salePrice = json['sale_price'];
    latestPrice = json['latest_price'];
    productCategory = json['product_category'];
    productType = json['product_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_name'] = productName;
    data['package'] = package;
    data['price'] = price;
    data['barcode'] = barcode;
    data['sale_price'] = salePrice;
    data['latest_price'] = latestPrice;
    data['product_category'] = productCategory;
    data['product_type'] = productType;
    return data;
  }
}
