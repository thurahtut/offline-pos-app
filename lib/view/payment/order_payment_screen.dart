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
      appBar: MyAppBar(),
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
    return Row(
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BorderContainer(
          text: 'Cash (Easy 3)',
          width: MediaQuery.of(context).size.width / 6,
          onTap: () {
            Navigator.pop(context);
          },
        ),
        SizedBox(height: 10),
        BorderContainer(
          text: 'Credit/Debit Cards (Easy 3)',
          width: MediaQuery.of(context).size.width / 6,
          onTap: () {
            Navigator.pop(context);
          },
        ),
        SizedBox(height: 10),
        BorderContainer(
          text: 'Near Me E-Payment (Easy 3)',
          width: MediaQuery.of(context).size.width / 6,
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
          ),
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
            CommonUtils.eachCalculateButtonWidget(text: "1", onPressed: () {}),
            CommonUtils.eachCalculateButtonWidget(text: "2", onPressed: () {}),
            CommonUtils.eachCalculateButtonWidget(text: "3", onPressed: () {}),
            CommonUtils.eachCalculateButtonWidget(
                text: "+10", onPressed: () {}),
            CommonUtils.eachCalculateButtonWidget(
              text: "BG Bakerys",
              width: 150,
              prefixSvg: "assets/svg/account_circle.svg",
              onPressed: () {},
              svgColor: Constants.primaryColor,
            ),
          ],
        ),
        SizedBox(height: 4),
        _eachCalculatorRowWidget(
          [
            CommonUtils.eachCalculateButtonWidget(text: "4", onPressed: () {}),
            CommonUtils.eachCalculateButtonWidget(text: "5", onPressed: () {}),
            CommonUtils.eachCalculateButtonWidget(text: "6", onPressed: () {}),
            CommonUtils.eachCalculateButtonWidget(
                text: "+20", onPressed: () {}),
            CommonUtils.eachCalculateButtonWidget(
              text: "Invoice",
              width: 150,
              prefixSvg: "assets/svg/receipt_long.svg",
              onPressed: () {},
              svgColor: Constants.primaryColor,
            ),
          ],
        ),
        SizedBox(height: 4),
        _eachCalculatorRowWidget(
          [
            CommonUtils.eachCalculateButtonWidget(text: "7", onPressed: () {}),
            CommonUtils.eachCalculateButtonWidget(text: "8", onPressed: () {}),
            CommonUtils.eachCalculateButtonWidget(text: "9", onPressed: () {}),
            CommonUtils.eachCalculateButtonWidget(
                text: "+50", onPressed: () {}),
          ],
        ),
        SizedBox(height: 4),
        _eachCalculatorRowWidget(
          [
            CommonUtils.eachCalculateButtonWidget(
                text: "+/-", onPressed: () {}),
            CommonUtils.eachCalculateButtonWidget(text: "0", onPressed: () {}),
            CommonUtils.eachCalculateButtonWidget(text: ".", onPressed: () {}),
            CommonUtils.eachCalculateButtonWidget(
                icon: Icons.backspace_outlined,
                iconColor: Constants.alertColor,
                onPressed: () {}),
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
}
