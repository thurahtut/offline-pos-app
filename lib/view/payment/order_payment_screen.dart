import 'package:offline_pos/components/export_files.dart';

class OrderPaymentScreen extends StatefulWidget {
  static const String routeName = "/order_payment_screen";
  const OrderPaymentScreen({super.key});

  @override
  State<OrderPaymentScreen> createState() => _OrderPaymentScreenState();
}

class _OrderPaymentScreenState extends State<OrderPaymentScreen> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: SaleAppBar(),
      body: _bodyWidget(),
    ));
  }

  Widget _bodyWidget() {
    bool isTabletMode = CommonUtils.isTabletMode(context);
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal:
              isTabletMode ? 10 : (MediaQuery.of(context).size.width / 3) / 2),
      child: Column(
        children: [
          _actionButtonsWidget(),
          SizedBox(height: 40),
          _paymentTypeAndAmountWidget(),
        ],
      ),
    );
  }

  Row _actionButtonsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BorderContainer(
          text: 'Back',
          width: MediaQuery.of(context).size.width / 8.5,
          onTap: () {
            Navigator.pop(context);
          },
        ),
        Text(
          'Payment',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        BorderContainer(
          text: 'Validate',
          width: MediaQuery.of(context).size.width / 8.5,
          containerColor: Constants.primaryColor,
          textColor: Colors.white,
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _paymentTypeAndAmountWidget() {
    bool isTabletMode = CommonUtils.isTabletMode(context);
    return isTabletMode
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _paymentTypeWidget(),
              SizedBox(height: 10),
              _editAmountWidget(),
              SizedBox(height: 10),
              _paymentCalculatorWidget(),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _paymentTypeWidget()),
              Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _editAmountWidget(),
                      SizedBox(height: 10),
                      _paymentCalculatorWidget(),
                    ],
                  ))
            ],
          );
  }

  Widget _paymentTypeWidget() {
    bool isTabletMode = CommonUtils.isTabletMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BorderContainer(
          text: 'Cash (Easy 3)',
          width: MediaQuery.of(context).size.width / (isTabletMode ? 2 : 6),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        SizedBox(height: 10),
        BorderContainer(
          text: 'Credit/Debit Cards (Easy 3)',
          width: MediaQuery.of(context).size.width / (isTabletMode ? 2 : 6),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        SizedBox(height: 10),
        BorderContainer(
          text: 'Near Me E-Payment (Easy 3)',
          width: MediaQuery.of(context).size.width / (isTabletMode ? 2 : 6),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _editAmountWidget() {
    TextStyle textStyle = TextStyle(
      color: Constants.primaryColor,
      fontSize: 30,
      fontWeight: FontWeight.w800,
    );
    return Container(
      height: 200,
      padding: EdgeInsets.all(MediaQuery.of(context).size.width / 30),
      decoration: BoxDecoration(
        color: Constants.greyColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
              controller: _amountController,
              decoration: InputDecoration(
                hintText: '0.00 Ks',
                hintStyle: textStyle,
                border: InputBorder.none,
                labelStyle: textStyle,
              ),
              inputFormatters: [
                // FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
              ]),
          Text(
            'Please select a payment method',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Constants.alertColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentCalculatorWidget() {
    return Column(
      children: [
        _eachCalculatorRowWidget(
          [
            CommonUtils.eachCalculateButtonWidget(
              text: "1",
              onPressed: () {
                _amountController.text += "1";
                setState(() {});
              },
            ),
            CommonUtils.eachCalculateButtonWidget(
              text: "2",
              onPressed: () {
                _amountController.text += "2";
                setState(() {});
              },
            ),
            CommonUtils.eachCalculateButtonWidget(
              text: "3",
              onPressed: () {
                _amountController.text += "3";
                setState(() {});
              },
            ),
            CommonUtils.eachCalculateButtonWidget(
              text: "+10",
              onPressed: () {
                _amountController.text =
                    (parseValueAmount(_amountController.text) + 10).toString();
                setState(() {});
              },
            ),
            context.watch<CurrentOrderController>().isContainCustomer == true
                ? CommonUtils.eachCalculateButtonWidget(
                    text: "BG Bakerys",
                    width: 150,
                    prefixSvg: "assets/svg/account_circle.svg",
                    svgColor: Constants.primaryColor,
                    onPressed: () {},
                  )
                : CommonUtils.eachCalculateButtonWidget(
                    text: "Invoice",
                    width: 150,
                    prefixSvg: "assets/svg/receipt_long.svg",
                    svgColor: Constants.primaryColor,
                    onPressed: () {},
            ),
          ],
        ),
        SizedBox(height: 4),
        _eachCalculatorRowWidget(
          [
            CommonUtils.eachCalculateButtonWidget(
              text: "4",
              onPressed: () {
                _amountController.text += "4";
                setState(() {});
              },
            ),
            CommonUtils.eachCalculateButtonWidget(
              text: "5",
              onPressed: () {
                _amountController.text += "5";
                setState(() {});
              },
            ),
            CommonUtils.eachCalculateButtonWidget(
              text: "6",
              onPressed: () {
                _amountController.text += "6";
                setState(() {});
              },
            ),
            CommonUtils.eachCalculateButtonWidget(
                text: "+20",
                onPressed: () {
                  _amountController.text =
                      (parseValueAmount(_amountController.text) + 20)
                          .toString();
                  setState(() {});
                }),
            context.watch<CurrentOrderController>().isContainCustomer == true
                ? CommonUtils.eachCalculateButtonWidget(
              text: "Invoice",
              width: 150,
              prefixSvg: "assets/svg/receipt_long.svg",
              svgColor: Constants.primaryColor,
              onPressed: () {},
                  )
                : SizedBox(),
          ],
        ),
        SizedBox(height: 4),
        _eachCalculatorRowWidget(
          [
            CommonUtils.eachCalculateButtonWidget(
              text: "7",
              onPressed: () {
                _amountController.text += "7";
                setState(() {});
              },
            ),
            CommonUtils.eachCalculateButtonWidget(
              text: "8",
              onPressed: () {
                _amountController.text += "8";
                setState(() {});
              },
            ),
            CommonUtils.eachCalculateButtonWidget(
              text: "9",
              onPressed: () {
                _amountController.text += "9";
                setState(() {});
              },
            ),
            CommonUtils.eachCalculateButtonWidget(
              text: "+50",
              onPressed: () {
                _amountController.text =
                    (parseValueAmount(_amountController.text) + 50).toString();
                setState(() {});
              },
            ),
          ],
        ),
        SizedBox(height: 4),
        _eachCalculatorRowWidget(
          [
            CommonUtils.eachCalculateButtonWidget(
                text: "+/-", onPressed: () {}),
            CommonUtils.eachCalculateButtonWidget(
              text: "0",
              onPressed: () {
                _amountController.text += "0";
                setState(() {});
              },
            ),
            CommonUtils.eachCalculateButtonWidget(
              text: ".",
              onPressed: () {
                double d = parseValueAmount(_amountController.text);
                if (d is! int) {
                  return;
                }
                _amountController.text += ".";
                setState(() {});
              },
            ),
            CommonUtils.eachCalculateButtonWidget(
              icon: Icons.backspace_outlined,
              iconColor: Constants.alertColor,
              onPressed: () {
                _amountController.text = _amountController.text
                    .substring(0, _amountController.text.length - 1);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _eachCalculatorRowWidget(List<Widget> widgets) {
    return Row(
      children: widgets
          .map((e) => Row(
                children: [
                  e,
                  SizedBox(
                    width: 4,
                  )
                ],
              ))
          .toList(),
    );
  }

  double parseValueAmount(String str) {
    double value = double.tryParse(str) ?? 0;
    return value;
  }
}
