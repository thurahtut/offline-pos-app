import 'package:offline_pos/components/export_files.dart';
Color primaryColor = Color(0xFF207810); //007ACC
class CommonUtils {
  static bool isTabletMode(BuildContext context) {
    return MediaQuery.of(context).size.width < 1080;
  }
  static bool isMobileMode(BuildContext context) {
    return MediaQuery.of(context).size.width < 500;
  }

  static showSnackBar({required String message, Duration? duration}) {
    if (NavigationService.navigatorKey.currentContext != null) {
      ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!)
          .showSnackBar(SnackBar(
        content: Text(message),
        duration: duration ?? Duration(seconds: 2),
      ));
    }
  }

  static Widget svgIconActionButton(
    String svg, {
    double? width,
    double? height,
    double? radius,
    Color? iconColor,
    Function()? onPressed,
    bool? withContianer,
    Color? containerColor,
    bool? withBorder,
    Color? borderWithPrimaryColor,
    double? padding,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: withContianer != null ? EdgeInsets.all(padding ?? 3) : null,
        decoration: withContianer != null
            ? BoxDecoration(
                borderRadius:
                    BorderRadius.circular(radius ?? (((width ?? 27) / 2) + 10)),
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
            iconColor ?? primaryColor,
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
    double? padding,
    double? radius,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: withContianer != null ? EdgeInsets.all(padding ?? 3) : null,
        decoration: withContianer != null
            ? BoxDecoration(
                borderRadius:
                    BorderRadius.circular(radius ?? ((size ?? 50) / 2)),
                color: containerColor,
              )
            : null,
        child: Icon(
          icon,
          size: size ?? 27,
          color: iconColor ?? primaryColor,
        ),
      ),
    );
  }

  static Widget appBarActionButtonWithText(
    String svg,
    String text, {
    double? width,
    double? height,
    Color? iconColor,
    Color? textColor,
    double? fontSize,
    Function()? onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CommonUtils.svgIconActionButton(
            svg,
            width: width,
            height: height,
            iconColor: iconColor,
            onPressed: onPressed,
          ),
          SizedBox(width: 4),
          Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: textColor ?? Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }

  static Widget iconActionButtonWithText(
    IconData icon,
    String text, {
    double? size,
    Color? iconColor,
    Color? textColor,
    double? fontSize,
    Function()? onPressed,
    bool? switchChild,
    FontWeight? fontWeight,
  }) {
    List<Widget> list = [
      CommonUtils.iconActionButton(
        icon,
        size: size,
        iconColor: iconColor,
        onPressed: onPressed,
      ),
      SizedBox(width: 6),
      Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: textColor ?? Colors.black,
          fontWeight: fontWeight ?? FontWeight.w500,
          fontSize: fontSize,
        ),
      ),
    ];
    return InkWell(
      onTap: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [...switchChild == true ? list.reversed : list],
      ),
    );
  }


  static List sideBarList = [
    {
      "svgPicture": 'assets/svg/info.svg',
      "text": 'Info',
      "onTap": () {
        if (NavigationService.navigatorKey.currentContext != null) {
          ProductInfomationDialog.productInformationDialogWidget(
              NavigationService.navigatorKey.currentContext!);
        }
      },
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
          Navigator.pushNamed(
            NavigationService.navigatorKey.currentContext!,
            PaymentMethodScreen.routeName,
          );

          // PaymentDialog.paymentDialogWidget(
          //     NavigationService.navigatorKey.currentContext!);
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
                    color: iconColor ?? primaryColor,
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

  static Widget okCancelWidget({
    String? okLabel,
    String? cancelLabel,
    bool? switchBtns,
    double? width,
    double? textSize,
    Color? cancelContainerColor,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? outsidePadding,
    Function()? okCallback,
    Function()? cancelCallback,
  }) {
    List<Widget> list = [
      Expanded(
        child: BorderContainer(
          text: okLabel ?? 'OK',
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          containerColor: primaryColor,
          textColor: Colors.white,
          width: width ?? 140,
          textSize: textSize ?? 20,
          radius: 16,
          onTap: okCallback,
        ),
      ),
      SizedBox(width: 8),
      Expanded(
        child: BorderContainer(
          text: cancelLabel ?? 'Cancel',
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          containerColor: cancelContainerColor,
          borderWithPrimaryColor: cancelContainerColor != null ? true : false,
          width: width ?? 140,
          textSize: textSize ?? 20,
          radius: 16,
          onTap: cancelCallback,
        ),
      ),
    ];
    return Padding(
      padding: outsidePadding ?? EdgeInsets.all(16.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        ...(switchBtns == true) ? list.reversed : list,
      ]),
    );
  }

  static Future<Object?> showGeneralDialogWidget(
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

  static PaymentMethods demoPaymentMethod = PaymentMethods(
      method: "American Express Settlement(Easy 1)",
      journal: "American Express Settlement Easy 1",
      company: "SSS International Co.,Ltd",
      forPoint: false,
      identifyCustomer: false,
      outstandingAccount: "201397 POS Clearing Account_Bank (TD_Easy/Maxi)",
      intermediaryAccount: "202610 POS Accounts Receivable (MT)",
      allowPaymentViaWallet: true,
      shortCode: "1234567");

  static ProductPackaging demoProductPackaging = ProductPackaging(
    product: "100 Pipers whisky 175ML",
    containedQuantity: 49,
    barcode: "0101234567890128TEC-IT",
    routes: false,
    purchase: true,
    sale: true,
    company: true,
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
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
      onSort: onSort,
    );
  }
  static List<String> categoryList = [
    "Dry Grocery",
    "Food To Go",
    "Men Wears",
    "Women Wears",
    "B.W.S , Wine, Accessories and Tabacco",
    "Basic Grocery",
    "Beverage",
    "Bakery",
    "Butchery",
    "Cosmetic",
    "Kitchen Accessories",
    "Drink",
    "Alcohol",
    "Juice",
    "Water",
    "Tissue",
    "Electronic"
  ];

  static List<String> unitList = [
    "none",
    "mm",
    "cm",
    "in3",
    "inches",
    "ozs",
    "fl oz",
    "ft2",
  ];

  static List<String> brandList = [
    "None",
    "Flee",
    "Evenline",
    "OK",
    "OKAMOTO",
    "APPETON",
  ];

  static List<String> companyList = [
    "MZ Company",
    "Super Global Co., Ltd.",
    "SSS International Co.,ltd",
  ];
}
