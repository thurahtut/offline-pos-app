import 'package:offline_pos/components/export_files.dart';

class PriceRuleDetailView extends StatefulWidget {
  const PriceRuleDetailView({super.key});

  @override
  State<PriceRuleDetailView> createState() => _PriceRuleDetailViewState();
}

class _PriceRuleDetailViewState extends State<PriceRuleDetailView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height / 2,
          minWidth: (MediaQuery.of(context).size.width / 2) -
              MediaQuery.of(context).size.width / 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Constants.greyColor2.withOpacity(0.3),
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 30, vertical: 10),
      padding: EdgeInsets.all(20),
      child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              // width:( MediaQuery.of(context).size.width/2) -MediaQuery.of(context).size.width / 15,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Product Computation',
                    style: TextStyle(
                      color: Constants.textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ..._infoWidget(),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                'The computed price is expressed in the default Unit of Measure of the product.',
                style: TextStyle(
                  color: Constants.textColor.withOpacity(0.7),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ]),
    );
  }

  List<Widget> _infoWidget() {
    var spacer = SizedBox(height: 15);

    return [
      spacer,
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _textForDetailInfo("Computation")),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                _eachRadioWidget(
                  text: 'Fixed Price',
                  value: 0,
                  selected: true,
                  groupValue: 0,
                ),
                _eachRadioWidget(
                  text: 'Discount',
                  value: 1,
                  selected: false,
                  groupValue: 0,
                ),
                _eachRadioWidget(
                  text: 'Formula',
                  value: 2,
                  selected: false,
                  groupValue: 0,
                ),
              ],
            ),
          ),
        ],
      ),
      spacer,
      Row(
        children: [
          Expanded(child: _textForDetailInfo("Fixed Price")),
          Expanded(
              flex: 2,
              child: _textForDetailInfo(
                  '${context.read<PriceRulesListController>().editingPriceRule?.price ?? 0} Ks')),
        ],
      ),
      spacer,
      _textForDetailInfo("Conditions"),
      spacer,
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _textForDetailInfo("Apply On")),
          Expanded(
            flex: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _eachRadioWidget(
                        text: 'All Product',
                        value: 0,
                        selected: true,
                        groupValue: 1,
                      ),
                      _eachRadioWidget(
                        text: 'Product Category',
                        value: 1,
                        selected: false,
                        groupValue: 1,
                      ),
                      _eachRadioWidget(
                        text: 'Product',
                        value: 2,
                        selected: false,
                        groupValue: 1,
                      ),
                      _eachRadioWidget(
                        text: 'Product Varient',
                        value: 3,
                        selected: false,
                        groupValue: 1,
                      ),
                      _eachRadioWidget(
                        text: 'Product Package',
                        value: 4,
                        selected: false,
                        groupValue: 1,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: _textForDetailInfo("Quantity")),
                          Expanded(
                              flex: 2,
                              child: _textForDetailInfo(
                                  '${context.read<PriceRulesListController>().editingPriceRule?.quantity ?? 0}')),
                        ],
                      ),
                      spacer,
                      Row(
                        children: [
                          Expanded(child: _textForDetailInfo("Validity")),
                          Expanded(
                              flex: 2,
                              child: _textForDetailInfo('12.07.2024 12:00:00')),
                        ],
                      ),
                      spacer,
                      Row(
                        children: [
                          Expanded(child: _textForDetailInfo("Currency")),
                          Expanded(flex: 2, child: _textForDetailInfo('MMK')),
                        ],
                      ),
                      spacer,
                      Row(
                        children: [
                          Expanded(child: _textForDetailInfo("Company")),
                          Expanded(
                              flex: 2,
                              child: _textForDetailInfo(
                                  'SSS International Co;Ltd')),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      spacer,
      Row(
        children: [
          Expanded(child: _textForDetailInfo("Product")),
          Expanded(
            flex: 2,
            child: _textForDetailInfo(
                '[${context.read<PriceRulesListController>().editingPriceRule?.appliedOn ?? ''}]'
                '${context.read<PriceRulesListController>().editingPriceRule?.product ?? ''}'),
          ),
        ],
      ),
    ];
  }

  RadioListTile<int> _eachRadioWidget({
    required int value,
    required bool selected,
    required int groupValue,
    required String text,
  }) {
    return RadioListTile(
      value: value,
      selected: selected,
      activeColor: Constants.primaryColor,
      fillColor:
          MaterialStateColor.resolveWith((states) => Constants.primaryColor),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      groupValue: groupValue,
      onChanged: (Object? value) {},
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

  Widget _textForDetailInfo(String text) {
    return Text(
      text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Constants.textColor,
        fontSize: 17,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
