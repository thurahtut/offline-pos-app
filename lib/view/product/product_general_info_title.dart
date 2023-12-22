import 'package:offline_pos/components/export_files.dart';

class ProductGeneralInfoTitle extends StatelessWidget {
  const ProductGeneralInfoTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thickness: MediaQuery.of(context).size.width > 1080 ? 0 : 6,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Constants.greyColor2),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: MediaQuery.of(context).size.width > 1080
              ? NeverScrollableScrollPhysics()
              : AlwaysScrollableScrollPhysics(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ..._itemInfoTitleList().map((e) {
                if (e is SizedBox) {
                  return e;
                }
                return SizedBox(
                  width: MediaQuery.of(context).size.width > 1080
                      ? MediaQuery.of(context).size.width /
                          ((_itemInfoTitleList().length / 2) + 0.5)
                      : 250,
                  child: e,
                );
              }).toList()
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _itemInfoTitleList() {
    return [
      _textForDetailInfo(
        'General Information',
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      SizedBox(width: 4),
      _textForDetailInfo(
        'POS UOM',
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      SizedBox(width: 4),
      _textForDetailInfo(
        'Attributes and Variants',
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      SizedBox(width: 4),
      _textForDetailInfo(
        'Sales',
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      SizedBox(width: 4),
      _textForDetailInfo(
        'Suggestion',
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      SizedBox(width: 4),
      _textForDetailInfo(
        'Purchase',
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      SizedBox(width: 4),
      _textForDetailInfo(
        'Inventory',
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      SizedBox(width: 4),
      _textForDetailInfo(
        'Accounting',
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      SizedBox(width: 4),
      _textForDetailInfo(
        'UOM',
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      SizedBox(width: 4),
      _textForDetailInfo(
        'Additional Information',
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      SizedBox(width: 4),
    ];
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
