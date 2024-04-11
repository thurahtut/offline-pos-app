enum ViewMode { view, create, edit }

enum ReInvoiceExpenses {
  no("No"),
  atCost("At Cost"),
  salePrice("Sale Price");

  const ReInvoiceExpenses(this.text);
  final String text;
}

enum ProductType { consumable, service, storableProduct }

enum InvoicingPolicy { orderedQuantities, deliveredQuantities }

enum CustomerTaxes { s5Good }

enum ItemType {
  none("None"),
  mDPrivateLabel("MD : Private label"),
  mNNationalBrand("MN : National brand");

  const ItemType(this.text);
  final String text;
}

enum Computation {
  fixed("Fixed Price"),
  discount("Discount"),
  formula("Formula");

  const Computation(this.text);
  final String text;
}

enum Condition {
  allProduct("All Products"),
  productCategory("Product Category"),
  product("Product"),
  productVarient("Product Varient"),
  productPackage("Product Package");

  const Condition(this.text);
  final String text;
}

enum DataSync {
  product,
  price,
  customer,
  paymentMethod,
  posCategory,
  amountTax,
  databaseBackup,
  reset,
  productPackaging,
  promotion,
  discount,
}

enum OrderState {
  draft("new"),
  cancelled("cancelled"),
  paid("paid");

  const OrderState(this.text);
  final String text;
}

enum OrderCondition {
  unsync("Unsynced"),
  sync("Synced"),
  rewrite("Rewrite");

  const OrderCondition(this.text);
  final String text;
}

enum CurrentOrderKeyboardState { disc, qty, price, refund }

enum DiscountApplyOn {
  // ignore: constant_identifier_names
  on_order("On Order"),
  // ignore: constant_identifier_names
  specific_products("On Specific Products");

  const DiscountApplyOn(this.text);
  final String text;
}

enum RewardType {
  discount("Discount"),
  product("Free Product");

  const RewardType(this.text);
  final String text;
}
