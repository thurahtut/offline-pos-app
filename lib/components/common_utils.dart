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
      "onTap": () {},
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

  static Widget _eachCalculateButtonWidget({
    String? text,
    IconData? icon,
    Color? iconColor,
    double? size,
    Function()? onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: size ?? 50,
        height: size ?? 50,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Constants.calculatorBgColor.withOpacity(0.77),
        ),
        child: Center(
          child: icon != null
              ? Icon(
                  icon,
                  size: 24,
                  color: iconColor ?? Constants.primaryColor,
                )
              : Text(
                  text ?? '',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }

  static List<Widget> calculatorActionWidgetList = [
    _eachCalculateButtonWidget(text: "1", onPressed: () {}),
    _eachCalculateButtonWidget(text: "2", onPressed: () {}),
    _eachCalculateButtonWidget(text: "3", onPressed: () {}),
    _eachCalculateButtonWidget(text: "Qty", onPressed: () {}),
    _eachCalculateButtonWidget(
        icon: Icons.keyboard_arrow_down_rounded, onPressed: () {}),
    _eachCalculateButtonWidget(text: "4", onPressed: () {}),
    _eachCalculateButtonWidget(text: "5", onPressed: () {}),
    _eachCalculateButtonWidget(text: "6", onPressed: () {}),
    _eachCalculateButtonWidget(text: "Disc", onPressed: () {}),
    _eachCalculateButtonWidget(text: "Price", onPressed: () {}),
    _eachCalculateButtonWidget(text: "7", onPressed: () {}),
    _eachCalculateButtonWidget(text: "8", onPressed: () {}),
    _eachCalculateButtonWidget(text: "9", onPressed: () {}),
    _eachCalculateButtonWidget(text: "+/-", onPressed: () {}),
    _eachCalculateButtonWidget(icon: Icons.arrow_forward_ios, onPressed: () {}),
    _eachCalculateButtonWidget(text: ".", onPressed: () {}),
    _eachCalculateButtonWidget(text: "0", onPressed: () {}),
    _eachCalculateButtonWidget(
        icon: Icons.backspace_outlined,
        iconColor: Constants.alertColor,
        onPressed: () {}),
    _eachCalculateButtonWidget(text: "Customer", size: 100, onPressed: () {}),
  ];
}
