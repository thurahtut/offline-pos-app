import 'package:offline_pos/components/export_files.dart';

class ProductCommonActionTitle extends StatelessWidget {
  const ProductCommonActionTitle({super.key});

  @override
  Widget build(BuildContext context) {
    bool isTabletMode = CommonUtils.isTabletMode(context);
    bool isMobileMode = CommonUtils.isMobileMode(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(color: Constants.greyColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _textForDetailInfo(
            'Print Tables',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          SizedBox(
            width: 20,
          ),
          _textForDetailInfo(
            'Generate IR Code',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          SizedBox(
            width: 20,
          ),
          _textForDetailInfo(
            'Generate BarCode',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          SizedBox(
            width: 20,
          ),
          _textForDetailInfo(
            'Update Quantity',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          SizedBox(
            width: 20,
          ),
          _textForDetailInfo(
            'Replenish',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          if (isMobileMode != true && isTabletMode != true)
            Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  Widget _textForDetailInfo(
    String text, {
    FontWeight? fontWeight,
    double? fontSize,
    Color? textColor,
  }) {
    return Text(
      text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: textColor ?? Constants.textColor,
        fontSize: fontSize ?? 17,
        fontWeight: fontWeight ?? FontWeight.w500,
      ),
    );
  }
}
