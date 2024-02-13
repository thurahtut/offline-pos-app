class AmountTax {
  int? id;
  String? name;
  String? typeTaxUse;
  String? taxScope;
  String? description;
  int? companyId;

  AmountTax(
      {this.id,
      this.name,
      this.typeTaxUse,
      this.taxScope,
      this.description,
      this.companyId});

  AmountTax.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    typeTaxUse = json['type_tax_use'];
    taxScope = json['tax_scope'];
    description = json['description'];
    companyId = json['company_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['type_tax_use'] = typeTaxUse;
    data['tax_scope'] = taxScope;
    data['description'] = description;
    data['company_id'] = companyId;
    return data;
  }
}
