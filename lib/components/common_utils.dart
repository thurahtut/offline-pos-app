import 'dart:math';

import 'package:offline_pos/components/export_files.dart';

class CommonUtils {
  static bool isTabletMode(BuildContext context) {
    return MediaQuery.of(context).size.width < 1080;
  }

  static Widget svgIconActionButton(
    String svg, {
    double? width,
    double? height,
    Color? iconColor,
    Function()? onPressed,
    bool? withContianer,
    Color? containerColor,
    bool? withBorder,
    Color? borderWithPrimaryColor,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: withContianer != null ? EdgeInsets.all(3) : null,
        decoration: withContianer != null
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(((width ?? 27) / 2) + 10),
                color: containerColor,
                border: withBorder == true
                    ? Border.all(
                        color: borderWithPrimaryColor ??
                            containerColor ??
                            Colors.transparent,
                      )
                    : null,
              )
            : null,
        child: SvgPicture.asset(
          svg,
          width: width ?? 27,
          height: height ?? 27,
          colorFilter: ColorFilter.mode(
            iconColor ?? Constants.primaryColor,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  static Widget iconActionButton(
    IconData icon, {
    double? size,
    Color? iconColor,
    Function()? onPressed,
    bool? withContianer,
    Color? containerColor,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: withContianer != null ? EdgeInsets.all(3) : null,
        decoration: withContianer != null
            ? BoxDecoration(
                borderRadius: BorderRadius.circular((size ?? 50) / 2),
                color: containerColor,
              )
            : null,
        child: Icon(
          icon,
          size: size ?? 27,
          color: iconColor ?? Constants.primaryColor,
        ),
      ),
    );
  }

  static List sideBarList = [
    {
      "svgPicture": 'assets/svg/info.svg',
      "text": 'Info',
      "onTap": () {},
    },
    {
      "svgPicture": 'assets/svg/refresh.svg',
      "text": 'Refund',
      "onTap": () {
        if (NavigationService.navigatorKey.currentContext != null) {
          ProductDiscountDialog.productDiscountDialogWidget(
              NavigationService.navigatorKey.currentContext!);
        }
      },
    },
    {
      "svgPicture": 'assets/svg/barcode_scanner.svg',
      "text": 'Enter Code',
      "onTap": () {
        if (NavigationService.navigatorKey.currentContext != null) {
          EnterCouponCodeDialog.enterCouponCodeDialogWidget(
              NavigationService.navigatorKey.currentContext!);
        }
      },
    },
    {
      "svgPicture": 'assets/svg/kid_star.svg',
      "text": 'Reset Programs',
      "onTap": () {},
    },
    {
      "svgPicture": 'assets/svg/qr_code.svg',
      "text": 'QR',
      "onTap": () {},
    },
    {
      "svgPicture": 'assets/svg/sell.svg',
      "text": 'Print Summary Report',
      "onTap": () {},
    },
    {
      "svgPicture": 'assets/svg/history.svg',
      "text": 'Order History',
      "onTap": () {
        if (NavigationService.navigatorKey.currentContext != null) {
          Navigator.pushNamed(
            NavigationService.navigatorKey.currentContext!,
            OrderHistoryListScreen.routeName,
          );
        }
      },
    },
    {
      "svgPicture": 'assets/svg/payments.svg',
      "text": 'Cash In/Out Statement',
      "onTap": () {
        if (NavigationService.navigatorKey.currentContext != null) {
          PrintStatementDialog.printStatementDialogWidget(
              NavigationService.navigatorKey.currentContext!);
        }
      },
    },
    {
      "svgPicture": 'assets/svg/credit_card.svg',
      "text": 'Payments',
      "onTap": () {
        if (NavigationService.navigatorKey.currentContext != null) {
          // Navigator.pushNamed(
          //   NavigationService.navigatorKey.currentContext!,
          //   OrderPaymentScreen.routeName,
          // );

          PaymentDialog.paymentDialogWidget(
              NavigationService.navigatorKey.currentContext!);
        }
      },
    },
    {
      "svgPicture": 'assets/svg/link.svg',
      "text": 'Quotation / Order',
      "onTap": () {
        if (NavigationService.navigatorKey.currentContext != null) {
          Navigator.pushNamed(
            NavigationService.navigatorKey.currentContext!,
            QuotationOrderListScreen.routeName,
          );
        }
      },
    },
    {
      "svgPicture": 'assets/svg/sell.svg',
      "text": 'Change UOM',
      "onTap": () {},
    },
    {
      "svgPicture": 'assets/svg/assignment.svg',
      "text": 'Template Products',
      "onTap": () {},
    },
    {
      "svgPicture": 'assets/svg/sync.svg',
      "text": 'Sync',
      "onTap": () {},
    },
  ];

  static List itemList = [
    {
      "id": 93420932095039,
      "name": "100 Pipers Wisky 175ML",
      "on_hand": 1163,
      "unit": "Unit",
      "price": 3950,
    },
    {
      "id": 93420932095039,
      "name": "100 Pipers Wisky 175ML",
      "on_hand": 1163,
      "unit": "Unit",
      "price": 3950,
    },
    {
      "id": 93420932095039,
      "name": "100 Pipers Wisky 175ML",
      "on_hand": 1163,
      "unit": "Unit",
      "price": 3950,
    },
    {
      "id": 93420932095039,
      "name": "100 Pipers Wisky 175ML",
      "on_hand": 1163,
      "unit": "Unit",
      "price": 3950,
    },
    {
      "id": 93420932095039,
      "name": "100 Pipers Wisky 175ML",
      "on_hand": 1163,
      "unit": "Unit",
      "price": 3950,
    },
    {
      "id": 93420932095039,
      "name": "100 Pipers Wisky 175ML",
      "on_hand": 1163,
      "unit": "Unit",
      "price": 3950,
    },
    {
      "id": 93420932095039,
      "name": "100 Pipers Wisky 175ML",
      "on_hand": 1163,
      "unit": "Unit",
      "price": 3950,
    },
    {
      "id": 93420932095039,
      "name": "100 Pipers Wisky 175ML",
      "on_hand": 1163,
      "unit": "Unit",
      "price": 3950,
    },
    {
      "id": 93420932095039,
      "name": "100 Pipers Wisky 175ML",
      "on_hand": 1163,
      "unit": "Unit",
      "price": 3950,
    },
    {
      "id": 93420932095039,
      "name": "100 Pipers Wisky 175ML",
      "on_hand": 1163,
      "unit": "Unit",
      "price": 3950,
    },
    {
      "id": 93420932095039,
      "name": "100 Pipers Wisky 175ML",
      "on_hand": 1163,
      "unit": "Unit",
      "price": 3950,
    },
    {
      "id": 93420932095039,
      "name": "100 Pipers Wisky 175ML",
      "on_hand": 1163,
      "unit": "Unit",
      "price": 3950,
    },
    {
      "id": 93420932095039,
      "name": "100 Pipers Wisky 175ML",
      "on_hand": 1163,
      "unit": "Unit",
      "price": 3950,
    },
  ];

  static Widget eachCalculateButtonWidget({
    String? text,
    IconData? icon,
    String? prefixSvg,
    Color? iconColor,
    Color? containerColor,
    Color? textColor,
    Color? svgColor,
    double? width,
    double? height,
    double? iconSize,
    double? textSize,
    Function()? onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: width ?? 50,
        height: height ?? 50,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color:
              containerColor ?? Constants.calculatorBgColor.withOpacity(0.77),
        ),
        child: Row(
          mainAxisAlignment: prefixSvg != null
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (prefixSvg != null) SizedBox(width: 4),
            if (prefixSvg != null)
              svgIconActionButton(
                prefixSvg,
                iconColor: svgColor,
              ),
            if (prefixSvg != null) SizedBox(width: 4),
            icon != null
                ? Icon(
                    icon,
                    size: iconSize ?? 24,
                    color: iconColor ?? Constants.primaryColor,
                  )
                : Text(
                    text ?? '',
                    style: TextStyle(
                      color: textColor ?? Constants.textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: textSize ?? 16,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  static List<Widget> calculatorActionWidgetList = [
    eachCalculateButtonWidget(text: "1", onPressed: () {}),
    eachCalculateButtonWidget(text: "2", onPressed: () {}),
    eachCalculateButtonWidget(text: "3", onPressed: () {}),
    eachCalculateButtonWidget(text: "Qty", onPressed: () {}),
    eachCalculateButtonWidget(
        icon: Icons.keyboard_arrow_down_rounded,
        iconSize: 32,
        onPressed: () {}),
    eachCalculateButtonWidget(text: "4", onPressed: () {}),
    eachCalculateButtonWidget(text: "5", onPressed: () {}),
    eachCalculateButtonWidget(text: "6", onPressed: () {}),
    eachCalculateButtonWidget(text: "Disc", onPressed: () {}),
    eachCalculateButtonWidget(text: "Price", onPressed: () {}),
    eachCalculateButtonWidget(text: "7", onPressed: () {}),
    eachCalculateButtonWidget(text: "8", onPressed: () {}),
    eachCalculateButtonWidget(text: "9", onPressed: () {}),
    eachCalculateButtonWidget(text: "+/-", onPressed: () {}),
    eachCalculateButtonWidget(
        icon: Icons.arrow_forward_ios, iconSize: 21, onPressed: () {}),
    eachCalculateButtonWidget(text: ".", onPressed: () {}),
    eachCalculateButtonWidget(text: "0", onPressed: () {}),
    eachCalculateButtonWidget(
        icon: Icons.backspace_outlined,
        iconColor: Constants.alertColor,
        onPressed: () {}),
    eachCalculateButtonWidget(
      text: "Customer",
      containerColor: Constants.primaryColor,
      textColor: Colors.white,
      width: 100,
      onPressed: () {
        if (NavigationService.navigatorKey.currentContext != null) {
          NavigationService.navigatorKey.currentContext!
              .read<ViewController>()
              .isCustomerView = true;
          CustomerListDialog.customerListDialogWidget(
              NavigationService.navigatorKey.currentContext!);
        }
      },
    ),
  ];

  static Widget orderCalculatorWidget(BuildContext context) {
    bool isTabletMode = CommonUtils.isTabletMode(context);
    List<Widget> list = [];
    List<Widget> rowList = [];

    for (var i = 0;
        i < CommonUtils.calculatorActionWidgetList.length;
        i += (isTabletMode ? 10 : 5)) {
      int start = (list.length * (isTabletMode ? 10 : 5));
      int end =
          (isTabletMode ? 10 : 5) + (list.length * (isTabletMode ? 10 : 5));
      rowList.addAll(CommonUtils.calculatorActionWidgetList.getRange(
          start, min(end, CommonUtils.calculatorActionWidgetList.length)));
      list.add(SizedBox(
        width: isTabletMode
            ? (MediaQuery.of(context).size.width / 10) * 9
            : MediaQuery.of(context).size.width -
                (MediaQuery.of(context).size.width / 5.5) -
                ((MediaQuery.of(context).size.width / 5.3) * 3),
        child: Row(
          children: List.generate(
            rowList.length,
            (index) => Expanded(
              flex: rowList.length == (isTabletMode ? 10 : 5)
                  ? 1
                  : index == (rowList.length - 1)
                      ? 2
                      : 1,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: (isTabletMode ? 4 : 8.0),
                  vertical: (isTabletMode ? 1.2 : 3),
                ),
                child: rowList[index],
              ),
            ),
          ),
        ),
      ));
      rowList = [];
    }

    return Column(
      children: list,
    );
  }

  static Widget okCancelWidget({
    String? okLabel,
    String? cancelLabel,
    bool? switchBtns,
    double? width,
    Color? cancelContainerColor,
    Function()? okCallback,
    Function()? cancelCallback,
  }) {
    List<Widget> list = [
      Expanded(
        child: BorderContainer(
          text: okLabel ?? 'OK',
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          containerColor: Constants.primaryColor,
          textColor: Colors.white,
          width: width ?? 140,
          textSize: 20,
          radius: 16,
          onTap: okCallback,
        ),
      ),
      SizedBox(width: 8),
      Expanded(
        child: BorderContainer(
          text: cancelLabel ?? 'Cancel',
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          containerColor: cancelContainerColor,
          borderWithPrimaryColor: cancelContainerColor != null ? true : false,
          width: width ?? 140,
          textSize: 20,
          radius: 16,
          onTap: cancelCallback,
        ),
      ),
    ];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        ...(switchBtns == true) ? list.reversed : list,
      ]),
    );
  }

  static Future<void> showGeneralDialogWidget(
    BuildContext mainContext,
    Widget Function(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) pageBuilder,
  ) {
    return showGeneralDialog(
      context: mainContext,
      barrierDismissible: true,
      barrierLabel: "Label",
      transitionDuration: Duration(milliseconds: 300),
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
      pageBuilder: pageBuilder,
    );
  }

  static List<CustomerDataModel> customerList = [
    CustomerDataModel(
      name: "Carina McCoy",
      address: "605 Dog Hill Lane, Tapeka, KS 66603",
      phone: "(214) 390-8650",
      email: "j.jones@outlook.com",
      discount: 0,
      credit: 0,
      creditLimit: "N/A",
      amountDue: "N/A",
    ),
    CustomerDataModel(
      name: "Chris Glasser",
      address: "4130 Butternut Lane, Alton, IL 62002",
      phone: "(785) 712-6532",
      email: "dennis416@gmail.com",
      discount: 0,
      credit: 0,
      creditLimit: "N/A",
      amountDue: "N/A",
    ),
    CustomerDataModel(
      name: "Customer 1",
      address: "customer 1",
      phone: "(959) 123-456-789",
      email: "customer1@gmail.com",
      discount: 0,
      credit: 0,
      creditLimit: "N/A",
      amountDue: "N/A",
    ),
    CustomerDataModel(
      name: "Customer 2",
      address: "customer 2",
      phone: "(959) 123-456-789",
      email: "customer2@gmail.com",
      discount: 0,
      credit: 0,
      creditLimit: "N/A",
      amountDue: "N/A",
    ),
    CustomerDataModel(
      name: "Customer 3",
      address: "customer 3",
      phone: "(959) 123-456-789",
      email: "customer3@gmail.com",
      discount: 0,
      credit: 0,
      creditLimit: "N/A",
      amountDue: "N/A",
    ),
    CustomerDataModel(
      name: "Customer 3",
      address: "customer 3",
      phone: "(959) 123-456-789",
      email: "customer3@gmail.com",
      discount: 0,
      credit: 0,
      creditLimit: "N/A",
      amountDue: "N/A",
    ),
    CustomerDataModel(
      name: "Customer 3",
      address: "customer 3",
      phone: "(959) 123-456-789",
      email: "customer3@gmail.com",
      discount: 0,
      credit: 0,
      creditLimit: "N/A",
      amountDue: "N/A",
    ),
    CustomerDataModel(
      name: "Customer 3",
      address: "customer 3",
      phone: "(959) 123-456-789",
      email: "customer3@gmail.com",
      discount: 0,
      credit: 0,
      creditLimit: "N/A",
      amountDue: "N/A",
    ),
    CustomerDataModel(
      name: "Customer 3",
      address: "customer 3",
      phone: "(959) 123-456-789",
      email: "customer3@gmail.com",
      discount: 0,
      credit: 0,
      creditLimit: "N/A",
      amountDue: "N/A",
    ),
    CustomerDataModel(
      name: "Customer 3",
      address: "customer 3",
      phone: "(959) 123-456-789",
      email: "customer3@gmail.com",
      discount: 0,
      credit: 0,
      creditLimit: "N/A",
      amountDue: "N/A",
    ),
    CustomerDataModel(
      name: "Customer 3",
      address: "customer 3",
      phone: "(959) 123-456-789",
      email: "customer3@gmail.com",
      discount: 0,
      credit: 0,
      creditLimit: "N/A",
      amountDue: "N/A",
    ),
    CustomerDataModel(
      name: "Customer 3",
      address: "customer 3",
      phone: "(959) 123-456-789",
      email: "customer3@gmail.com",
      discount: 0,
      credit: 0,
      creditLimit: "N/A",
      amountDue: "N/A",
    ),
    CustomerDataModel(
      name: "Customer 3",
      address: "customer 3",
      phone: "(959) 123-456-789",
      email: "customer3@gmail.com",
      discount: 0,
      credit: 0,
      creditLimit: "N/A",
      amountDue: "N/A",
    ),
    CustomerDataModel(
      name: "Customer 3",
      address: "customer 3",
      phone: "(959) 123-456-789",
      email: "customer3@gmail.com",
      discount: 0,
      credit: 0,
      creditLimit: "N/A",
      amountDue: "N/A",
    ),
    CustomerDataModel(
      name: "Customer 3",
      address: "customer 3",
      phone: "(959) 123-456-789",
      email: "customer3@gmail.com",
      discount: 0,
      credit: 0,
      creditLimit: "N/A",
      amountDue: "N/A",
    ),
    CustomerDataModel(
      name: "Customer 3",
      address: "customer 3",
      phone: "(959) 123-456-789",
      email: "customer3@gmail.com",
      discount: 0,
      credit: 0,
      creditLimit: "N/A",
      amountDue: "N/A",
    ),
    CustomerDataModel(
      name: "Customer 3",
      address: "customer 3",
      phone: "(959) 123-456-789",
      email: "customer3@gmail.com",
      discount: 0,
      credit: 0,
      creditLimit: "N/A",
      amountDue: "N/A",
    ),
    CustomerDataModel(
      name: "Customer 3",
      address: "customer 3",
      phone: "(959) 123-456-789",
      email: "customer3@gmail.com",
      discount: 0,
      credit: 0,
      creditLimit: "N/A",
      amountDue: "N/A",
    ),
    CustomerDataModel(
      name: "Customer 3",
      address: "customer 3",
      phone: "(959) 123-456-789",
      email: "customer3@gmail.com",
      discount: 0,
      credit: 0,
      creditLimit: "N/A",
      amountDue: "N/A",
    ),
    CustomerDataModel(
      name: "Customer 3",
      address: "customer 3",
      phone: "(959) 123-456-789",
      email: "customer3@gmail.com",
      discount: 0,
      credit: 0,
      creditLimit: "N/A",
      amountDue: "N/A",
    ),
    CustomerDataModel(
      name: "Customer 3",
      address: "customer 3",
      phone: "(959) 123-456-789",
      email: "customer3@gmail.com",
      discount: 0,
      credit: 0,
      creditLimit: "N/A",
      amountDue: "N/A",
    ),
    CustomerDataModel(
      name: "Customer 3",
      address: "customer 3",
      phone: "(959) 123-456-789",
      email: "customer3@gmail.com",
      discount: 0,
      credit: 0,
      creditLimit: "N/A",
      amountDue: "N/A",
    ),
    CustomerDataModel(
      name: "Customer 3",
      address: "customer 3",
      phone: "(959) 123-456-789",
      email: "customer3@gmail.com",
      discount: 0,
      credit: 0,
      creditLimit: "N/A",
      amountDue: "N/A",
    ),
    CustomerDataModel(
      name: "Customer 3",
      address: "customer 3",
      phone: "(959) 123-456-789",
      email: "customer3@gmail.com",
      discount: 0,
      credit: 0,
      creditLimit: "N/A",
      amountDue: "N/A",
    ),
    CustomerDataModel(
      name: "Customer 3",
      address: "customer 3",
      phone: "(959) 123-456-789",
      email: "customer3@gmail.com",
      discount: 0,
      credit: 0,
      creditLimit: "N/A",
      amountDue: "N/A",
    ),
    CustomerDataModel(
      name: "Customer 3",
      address: "customer 3",
      phone: "(959) 123-456-789",
      email: "customer3@gmail.com",
      discount: 0,
      credit: 0,
      creditLimit: "N/A",
      amountDue: "N/A",
    ),
    CustomerDataModel(
      name: "Customer 3",
      address: "customer 3",
      phone: "(959) 123-456-789",
      email: "customer3@gmail.com",
      discount: 0,
      credit: 0,
      creditLimit: "N/A",
      amountDue: "N/A",
    ),
  ];

  static List<OrderHistoryDataModel> orderHistoryList = [
    OrderHistoryDataModel(
      name: "Easy 3 - POS 2/65358",
      orderRef: "Order 14151-140-0042",
      customer: "BG Bakery",
      date: "12-12-2023 12:30 PM",
      total: 467000,
      state: "Paid",
    ),
  ];

  static QuotationDataModel demoQuotationData = QuotationDataModel(
    order: "S02034",
    date: "12-12-2023 12:30 PM",
    customer: "BG Bakery",
    salePerson: "Admin",
    total: 467000,
    state: "Quotation",
  );

  static OrderDataModel demoOrderData = OrderDataModel(
    receiptNumber: "Order 14151-136-00001",
    date: "12-12-2023 12:30 PM",
    customer: "May Pearl",
    employee: "Easy 3-A Store Leader",
    total: 467000,
    state: "onGoing",
  );

  static DataColumn2 dataColumn({
    required String text,
    Function(int, bool)? onSort,
    double? fixedWidth,
    Color? textColor,
  }) {
    return DataColumn2(
      fixedWidth: fixedWidth,
      label: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: textColor ?? Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
      onSort: onSort,
    );
  }
}
