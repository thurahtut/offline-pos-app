import 'package:offline_pos/components/export_files.dart';

class Product {
  int? productId;
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
  double? qty;

  Product({
    this.productId,
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
    this.qty,
  });

  Product.fromJson(Map<String, dynamic> json) {
    productId = json[PRODUCT_ID];
    productName = json[PRODUCT_NAME];
    package = json[PACKAGE];
    productType = json[PRODUCT_TYPE] != "null"
        ? ProductType.values.firstWhere((e) => e.name == json[PRODUCT_TYPE])
        : ProductType.consumable;
    isBundled = bool.tryParse(json[IS_BUNDLED]);
    canBeSold = bool.tryParse(json[CAN_BE_SOLD]);
    canBePurchased = bool.tryParse(json[CAN_BE_PURCHASED]);
    canBeManufactured = bool.tryParse(json[CAN_BE_MANUFACTURED]);
    reInvoiceExpenses = json[RE_INVOICE_EXPENSES] != "null"
        ? ReInvoiceExpenses.values
            .firstWhere((e) => e.text == json[RE_INVOICE_EXPENSES])
        : ReInvoiceExpenses.no;
    invoicingPolicy = json[INVOICE_POLICY] != "null"
        ? InvoicingPolicy.values
            .firstWhere((e) => e.name == json[INVOICE_POLICY])
        : InvoicingPolicy.orderedQuantities;
    unitOfMeasure = json[UNIT_OF_MEASURE];
    baseUnitCount = double.tryParse(json[BASE_UNIT_COUNT].toString());
    isSecondaryUnit = bool.tryParse(json[IS_SECONDARY_UNIT]);
    purchaseUOM = json[PURCHASE_UOM];
    isCommissionBasedServices =
        bool.tryParse(json[IS_COMMISSION_BASED_SERVICES]);
    isThirdUnit = bool.tryParse(json[IS_THIRD_UNIT]);
    rebatePercentage = double.tryParse(json[REBATE_PERCENTAGE].toString());
    price = double.tryParse(json[PRICE].toString());
    salePrice = double.tryParse(json[SALE_PRICE].toString());
    latestPrice = double.tryParse(json[LATEST_PRICE].toString());
    productCategory = json[PRODUCT_CATEGORY];
    productBrand = json[PRODUCT_BRAND];
    qtyInBags = double.tryParse(json[QTY_IN_BAGS].toString());
    multipleOfQty = double.tryParse(json[MULTIPLE_OF_QTY].toString());
    oldInternalRef = json[OLD_INTERNAL_REF];
    internalRef = json[INTERNAL_REF];
    barcode = json[BARCODE];
    isClearance = bool.tryParse(json[IS_CLEARANCE]);
    itemType = json[ITEM_TYPE] != "null"
        ? ItemType.values.firstWhere((e) => e.text == json[ITEM_TYPE])
        : ItemType.none;
    countryCode = json[COUNTRY_CODE];
    allowNegativeStock = bool.tryParse(json[ALLOW_NEGATIVE_STOCK]);
    company = json[COMPANY];
    tags = json[TAGS];
    internalNotes = json[INTERNAL_NOTES];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['package'] = package;
    data['product_type'] = productType?.name;
    data['is_bundled'] = isBundled?.toString();
    data['can_be_sold'] = canBeSold?.toString();
    data['can_be_purchased'] = canBePurchased?.toString();
    data['can_be_manufactured'] = canBeManufactured?.toString();
    data['re_invoice_expenses'] = reInvoiceExpenses?.text;
    data['invoice_policy'] = invoicingPolicy?.name;
    data['unit_of_measure'] = unitOfMeasure;
    data['base_unit_count'] = baseUnitCount;
    data['is_secondary_count'] = isSecondaryUnit?.toString();
    data['purchase_uom'] = purchaseUOM;
    data['is_commission_based_services'] =
        isCommissionBasedServices?.toString();
    data['is_third_unit'] = isThirdUnit?.toString();
    data['rebate_percentage'] = rebatePercentage;
    data['price'] = price;
    data['sale_price'] = salePrice;
    data['latest_price'] = latestPrice;
    data['product_category'] = productCategory;
    data['product_brand'] = productBrand;
    data['qty_in_bags'] = qtyInBags;
    data['multiple_of_qty'] = multipleOfQty;
    data['old_internal_ref'] = oldInternalRef;
    data['internal_ref'] = internalRef;
    data['barcode'] = barcode;
    data['is_clearance'] = isClearance?.toString();
    data['item_type'] = itemType?.text;
    data['country_code'] = countryCode;
    data['allow_negative_stock'] = allowNegativeStock?.toString();
    data['company'] = company;
    data['tags'] = tags;
    data['internal_notes'] = internalNotes;
    return data;
  }
}
