import 'package:offline_pos/components/export_files.dart';

class PriceListItemDetailNew extends StatefulWidget {
  const PriceListItemDetailNew({super.key});

  @override
  State<PriceListItemDetailNew> createState() => _PriceListItemDetailNewState();
}

class _PriceListItemDetailNewState extends State<PriceListItemDetailNew> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fixedPriceTextController =
      TextEditingController();
  final TextEditingController _productTextController = TextEditingController();
  final TextEditingController _quantityTextController = TextEditingController();
  final TextEditingController _validityTextController = TextEditingController();

  @override
  void dispose() {
    _fixedPriceTextController.dispose();
    _productTextController.dispose();
    _quantityTextController.dispose();
    _validityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
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
      ),
    );
  }

  List<Widget> _infoWidget() {
    var spacer = SizedBox(height: 15);

    return [
      // spacer,
      // Row(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     Expanded(child: _textForDetailInfo("Computation")),
      //     Expanded(
      //       flex: 2,
      //       child: Column(
      //         children: Computation.values.map((e) {
      //           return _eachRadioWidget(
      //             text: e.text,
      //             value: e.index,
      //             groupValue:
      //             (context
      //                             .watch<PriceListItemController>()
      //                             .creatingPriceItem
      //                             ?.computation ??
      //                         '') ==
      //                     e
      //                 ? e.index
      //                 :
      //                  -1,
      //             onChanged: (value) {
      //               if (value != null) {
      //                 context
      //                     .read<PriceListItemController>()
      //                     .creatingPriceItem
      //                     ?.computation = Computation.values.elementAt(value);
      //                 context.read<PriceListItemController>().notify();
      //               }
      //             },
      //           );
      //         }).toList(),
      //       ),
      //     ),
      //   ],
      // ),
      spacer,
      Row(
        children: [
          Expanded(child: _textForDetailInfo("Fixed Price")),
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: _fixedPriceTextController,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                  labelStyle: TextStyle(
                    color: primaryColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                  border: UnderlineInputBorder(),
                  contentPadding: EdgeInsets.all(16),
                  suffixIcon: Text(' Ks')),
            ),
          ),
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
                    children: Condition.values.map((e) {
                      return _eachRadioWidget(
                        text: e.text,
                        value: e.index,
                        groupValue: (context
                                        .watch<PriceListItemController>()
                                        .creatingPriceItem
                                        ?.priceListItem
                                        ?.appliedOn ??
                                    '') ==
                                e
                            ? e.index
                            : -1,
                        onChanged: (value) {
                          if (value != null) {
                            context
                                    .read<PriceListItemController>()
                                    .creatingPriceItem
                                    ?.priceListItem
                                    ?.appliedOn =
                                Condition.values.elementAt(value).name;
                            context.read<PriceListItemController>().notify();
                          }
                        },
                      );
                    }).toList(),
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
                            child: TextFormField(
                              controller: _quantityTextController,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                // hintText: "e.g. Cheese Burger",
                                // hintStyle: TextStyle(
                                //   color: Constants.disableColor.withOpacity(0.9),
                                //   fontSize: 15,
                                //   fontWeight: FontWeight.w800,
                                // ),
                                labelStyle: TextStyle(
                                  color: primaryColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                                border: UnderlineInputBorder(),
                                contentPadding: EdgeInsets.all(16),
                              ),
                            ),
                          ),
                        ],
                      ),
                      spacer,
                      Row(
                        children: [
                          Expanded(child: _textForDetailInfo("Validity")),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _validityTextController,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                // hintText: "e.g. Cheese Burger",
                                // hintStyle: TextStyle(
                                //   color: Constants.disableColor.withOpacity(0.9),
                                //   fontSize: 15,
                                //   fontWeight: FontWeight.w800,
                                // ),
                                labelStyle: TextStyle(
                                  color: primaryColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                                border: UnderlineInputBorder(),
                                contentPadding: EdgeInsets.all(16),
                              ),
                            ),
                          ),
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
            child: TextFormField(
              controller: _productTextController,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: "Enter Product",
                hintStyle: TextStyle(
                  color: Constants.disableColor.withOpacity(0.9),
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
                labelStyle: TextStyle(
                  color: primaryColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
                border: UnderlineInputBorder(),
                contentPadding: EdgeInsets.all(16),
              ),
            ),
          ),
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
