import 'package:offline_pos/components/export_files.dart';

class ProductCommonActionTitle extends StatelessWidget {
  const ProductCommonActionTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        constraints: BoxConstraints(
          minHeight: 50,
          maxHeight: 70,
          // maxWidth: 50,
          // maxWidth: MediaQuery.of(context).size.width,
          // minWidth: MediaQuery.of(context).size.width,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Constants.greyColor2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _actionTitleList(context).length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            // if (_actionTitleList(context)[index] is SizedBox) {
            //   return _actionTitleList(context)[index];
            // }
            return Center(
                child:
                    // Container(
                    //     padding: EdgeInsets.all(12),
                    //     decoration: BoxDecoration(
                    //       border: Border.all(color: Constants.greyColor2),
                    //       borderRadius: BorderRadius.circular(4),
                    //     ),
                    //     child:
                    Padding(
              padding: const EdgeInsets.all(8.0),
              child: _actionTitleList(context)[index],
            )
                //  ),
                );
          },
          separatorBuilder: (BuildContext context, int index) {
            return VerticalDivider(color: Constants.greyColor2);
          },
        )

        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   children: [

        //     // _textForDetailInfo(
        //     //   'Print Tables',
        //     //   fontWeight: FontWeight.bold,
        //     //   fontSize: 16,
        //     // ),
        //     // SizedBox(
        //     //   width: 20,
        //     // ),
        //     // _textForDetailInfo(
        //     //   'Generate IR Code',
        //     //   fontWeight: FontWeight.bold,
        //     //   fontSize: 16,
        //     // ),
        //     // SizedBox(
        //     //   width: 20,
        //     // ),
        //     // _textForDetailInfo(
        //     //   'Generate BarCode',
        //     //   fontWeight: FontWeight.bold,
        //     //   fontSize: 16,
        //     // ),
        //     // SizedBox(
        //     //   width: 20,
        //     // ),
        //     _textForDetailInfo(
        //       'Update Quantity',
        //       fontWeight: FontWeight.bold,
        //       fontSize: 16,
        //     ),
        //     SizedBox(
        //       width: 20,
        //     ),
        //     _textForDetailInfo(
        //       'Replenish',
        //       fontWeight: FontWeight.bold,
        //       fontSize: 16,
        //     ),
        //     if (isMobileMode != true && isTabletMode != true)
        //       Expanded(child: SizedBox()),
        //   ],
        // ),

        );
  }

  List<Widget> _actionTitleList(BuildContext context) {
    // bool isTabletMode = CommonUtils.isTabletMode(context);
    // bool isMobileMode = CommonUtils.isMobileMode(context);
    return [
      _textForDetailInfo(
        'Update Quantity',
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      _textForDetailInfo(
        'Replenish',
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
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
