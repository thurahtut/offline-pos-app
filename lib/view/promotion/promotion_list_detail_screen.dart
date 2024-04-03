import 'package:offline_pos/components/export_files.dart';

class PromotionListDetailScreen extends StatelessWidget {
  const PromotionListDetailScreen({super.key, required this.promotion});
  static const String routeName = "/promotion_list_detail_screen";
  final Promotion? promotion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      body: _bodyWidget(context),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 10, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black.withOpacity(0.6)),
        boxShadow: [
          BoxShadow(
            color: Constants.greyColor2.withOpacity(0.3),
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._promotionNameWidget(),
            ..._detailInfo(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _promotionNameWidget() {
    return [
      Text(
        'Program Name',
        style: TextStyle(
          color: Constants.textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      Text(
        promotion?.name ?? '',
        style: TextStyle(
          color: Constants.textColor,
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
      ),
    ];
  }

  List<Widget> _detailInfo(BuildContext context) {
    return [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: _leftDetailWidget(context),
            ),
          )),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: _rightDetailWidget(),
            ),
          )),
        ],
      ),
    ];
  }

  get spacer => SizedBox(height: 10);

  List<Widget> _leftDetailWidget(BuildContext context) {
    return [
      Text(
        'Conditions',
        style: TextStyle(
          color: Constants.textColor.withOpacity(0.7),
          fontWeight: FontWeight.w300,
          fontSize: 12,
        ),
      ),
      Divider(
        color: Constants.greyColor.withOpacity(0.7),
      ),
      ..._basedOnProductsWidget(),
      ..._quantityWidget(),
      ..._companyWidget(),
      ..._freeProductWidget(),
      ..._rewardQuantityWidget(),
      ..._applyDiscountWidget(),
      ..._fixedAmountWidget(),
      ..._discountApplyOnWidget(context),
    ];
  }

  List<Widget> _rightDetailWidget() {
    return [
      Text(
        'Validity',
        style: TextStyle(
          color: Constants.textColor.withOpacity(0.7),
          fontWeight: FontWeight.w300,
          fontSize: 12,
        ),
      ),
      Divider(
        color: Constants.greyColor.withOpacity(0.7),
      ),
    ];
  }

  List<Widget> _basedOnProductsWidget() {
    return [
      spacer,
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              'Based On Products',
              style: TextStyle(
                color: Constants.textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Match records with the following rule:',
                    style: TextStyle(
                      color: Constants.textColor.withOpacity(0.7),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  spacer,
                  Row(
                    children: [
                      Icon(Icons.arrow_forward_rounded),
                      Text(
                        '${promotion?.promotionRule?.validProductIds?.length ?? 0} RECORD(S)',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ],
      ),
    ];
  }

  List<Widget> _quantityWidget() {
    return [
      spacer,
      Row(
        children: [
          Expanded(
            child: Text(
              'Quantity',
              style: TextStyle(
                color: Constants.textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${promotion?.promotionRule?.ruleMinQuantity ?? 0} ',
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Constants.textColor,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> _companyWidget() {
    return [
      spacer,
      Row(
        children: const [
          Expanded(
            child: Text(
              'Company',
              style: TextStyle(
                color: Constants.textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'SSS International Co.,ltd',
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Constants.textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> _freeProductWidget() {
    return promotion?.freeProduct == null
        ? []
        : [
            spacer,
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Free Product',
                    style: TextStyle(
                      color: Constants.textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    '${promotion?.freeProduct?.barcode != null ? '[${promotion?.freeProduct!.barcode}]' : ''} ${promotion?.freeProduct?.productName ?? ''}',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ];
  }

  List<Widget> _rewardQuantityWidget() {
    return promotion?.freeProduct == null
        ? []
        : [
            spacer,
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Quantity',
                    style: TextStyle(
                      color: Constants.textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    '${promotion?.rewardProductQuantity ?? 0} ',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Constants.textColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ];
  }

  List<Widget> _applyDiscountWidget() {
    return promotion?.freeProduct == null
        ? [
            spacer,
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Apply Discount',
                    style: TextStyle(
                      color: Constants.textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    promotion?.discountType?.split('_').join(" ") ?? '',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Constants.textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ]
        : [];
  }

  List<Widget> _fixedAmountWidget() {
    return promotion?.discountType == "fixed_amount"
        ? [
            spacer,
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Fixed Amount',
                    style: TextStyle(
                      color: Constants.textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    '${promotion?.discountFixedAmount ?? 0} ',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Constants.textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ]
        : [];
  }

  List<Widget> _discountApplyOnWidget(BuildContext context) {
    return [
      spacer,
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              'Discount Apply On',
              style: TextStyle(
                color: Constants.textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: DiscountApplyOn.values.map((e) {
                  return _eachRadioWidget(
                    text: e.text,
                    value: e.index,
                    groupValue:
                        promotion?.discountApplyOn == e.name ? e.index : -1,
                    onChanged: null,
                  );
                }).toList(),
              )),
        ],
      ),
    ];
  }

  RadioListTile<int> _eachRadioWidget({
    required int value,
    required int groupValue,
    required String text,
    Function(int? value)? onChanged,
  }) {
    return RadioListTile(
      value: value,
      activeColor: primaryColor,
      fillColor: MaterialStateColor.resolveWith((states) => primaryColor),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      groupValue: groupValue,
      onChanged: onChanged,
      title: Text(
        text,
        style: TextStyle(
          color: Constants.textColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
