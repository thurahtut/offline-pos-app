import 'dart:math';

import 'package:offline_pos/components/export_files.dart';
import 'package:offline_pos/view/payment/payment_screen.dart';

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
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: withContianer != null ? EdgeInsets.all(3) : null,
        decoration: withContianer != null
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(((width ?? 27) / 2) + 10),
                color: containerColor,
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
      "onTap": () {},
    },
    {
      "svgPicture": 'assets/svg/barcode_scanner.svg',
      "text": 'Enter Code',
      "onTap": () {},
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
      "onTap": () {},
    },
    {
      "svgPicture": 'assets/svg/payments.svg',
      "text": 'Cash In/Out Statement',
      "onTap": () {},
    },
    {
      "svgPicture": 'assets/svg/credit_card.svg',
      "text": 'Payments',
      "onTap": () {
        if (NavigationService.navigatorKey.currentContext != null) {
          Navigator.pushNamed(
            NavigationService.navigatorKey.currentContext!,
            PaymentScreen.routeName,
          );
        }
      },
    },
    {
      "svgPicture": 'assets/svg/link.svg',
      "text": 'Quotation / Order',
      "onTap": () {},
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
      onPressed: () {},
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
          children: rowList.map((e) {
            // var child = e.toString();
            return Expanded(
              //UnconstrainedBox
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
                child: e,
              ),
            );
          }).toList(),
        ),
      ));
      rowList = [];
    }

    return Column(
      children: list,
    );
  }


  static Widget okCancelWidget({
    Function()? okCallback,
    Function()? cancelCallback,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BorderContainer(
          text: 'OK',
          containerColor: Constants.primaryColor,
          textColor: Colors.white,
          width: 150,
          textSize: 20,
          onTap: okCallback,
        ),
        SizedBox(width: 4),
        BorderContainer(
          text: 'Cancel',
          width: 150,
          textSize: 20,
          onTap: cancelCallback,
        ),
      ],
    );
  }

}
