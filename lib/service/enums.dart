enum ProductDetailMode { view, create, edit }

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
  mDPrivateLabel("MD : Private label"),
  mNNationalBrand("MN : National brand");

  const ItemType(this.text);
  final String text;
}
