import 'package:offline_pos/components/export_files.dart';

class ProductGeneralInfoTitle extends StatelessWidget {
  const ProductGeneralInfoTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thickness: MediaQuery.of(context).size.width > 1080 ? 0 : 6,
      child: Container(
          // width: MediaQuery.of(context).size.width,
          // margin: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          constraints: BoxConstraints(
            minHeight: 50,
            maxHeight: 60,
            // maxWidth: 50,
            // minWidth: 30,
          ),
        decoration: BoxDecoration(
            color: Colors.white,
          border: Border.all(color: Constants.greyColor2),
            borderRadius: BorderRadius.circular(4),
          ),
          // decoration: BoxDecoration(
          // border: Border.all(color: const Color.fromRGBO(140, 140, 140, 1)),
          // borderRadius: BorderRadius.only(
          //   topLeft: Radius.circular(12),
          //   topRight: Radius.circular(12),
          // ),
          // ),
          child:
              //  SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   physics: MediaQuery.of(context).size.width > 1080
              //       ? NeverScrollableScrollPhysics()
              //       : AlwaysScrollableScrollPhysics(),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       ..._itemInfoTitleList(context).map((e) {
              //         if (e is SizedBox) {
              //           return e;
              //         }
              //         return SizedBox(
              //           // width: MediaQuery.of(context).size.width > 1080
              //           //     ? MediaQuery.of(context).size.width /
              //           //         ((_itemInfoTitleList(context).length / 2) + 0.5)
              //           //     : 250,
              //           // height: 70,
              //           child: Container(
              //               padding: EdgeInsets.all(12),
              //               decoration: BoxDecoration(
              //                 border: Border.all(color: Constants.greyColor2),
              //                 borderRadius: BorderRadius.circular(4),
              //               ),
              //               child: Center(child: e)),
              //         );
              //       }).toList()
              //     ],
              //   ),
              // ),
              ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: _itemInfoTitleList(context).length,
            itemBuilder: (context, index) {
              return Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _itemInfoTitleList(context)[index],
              )
                  //  ),
                  );
            },
            separatorBuilder: (BuildContext context, int index) {
              return VerticalDivider(color: Constants.greyColor2);
            },
          )

      ),
    );
  }

  List<Widget> _itemInfoTitleList(BuildContext context) {
    return [
      _textForDetailInfo(
        'General Information',
        fontSize: 16,
        fontWeight: FontWeight.bold,
        textColor: !context.watch<ProductDetailController>().isBarcodeView
            ? Constants.primaryColor
            : Colors.black,
        onPressed: () {
          context.read<ProductDetailController>().isBarcodeView = false;
        },
      ),
      // SizedBox(width: 4),
      // _textForDetailInfo(
      //   'POS UOM',
      //   fontSize: 12,
      //   fontWeight: FontWeight.bold,
      // ),
      // SizedBox(width: 4),
      // _textForDetailInfo(
      //   'Attributes and Variants',
      //   fontSize: 12,
      //   fontWeight: FontWeight.bold,
      // ),
      // SizedBox(width: 4),
      // _textForDetailInfo(
      //   'Sales',
      //   fontSize: 12,
      //   fontWeight: FontWeight.bold,
      // ),
      // SizedBox(width: 4),
      // _textForDetailInfo(
      //   'Suggestion',
      //   fontSize: 12,
      //   fontWeight: FontWeight.bold,
      // ),
      // SizedBox(width: 4),
      // _textForDetailInfo(
      //   'Purchase',
      //   fontSize: 12,
      //   fontWeight: FontWeight.bold,
      // ),
      // SizedBox(width: 4),
      // _textForDetailInfo(
      //   'Inventory',
      //   fontSize: 12,
      //   fontWeight: FontWeight.bold,
      // ),
      // SizedBox(width: 4),
      // _textForDetailInfo(
      //   'Accounting',
      //   fontSize: 12,
      //   fontWeight: FontWeight.bold,
      // ),
      // SizedBox(width: 4),
      // _textForDetailInfo(
      //   'UOM',
      //   fontSize: 12,
      //   fontWeight: FontWeight.bold,
      // ),
      // SizedBox(width: 4),
      // _textForDetailInfo(
      //   'Additional Information',
      //   fontSize: 12,
      //   fontWeight: FontWeight.bold,
      // ),
      // SizedBox(width: 4),
      _textForDetailInfo(
        'Barcode',
        fontSize: 16,
        fontWeight: FontWeight.bold,
        textColor: context.watch<ProductDetailController>().isBarcodeView
            ? Constants.primaryColor
            : Colors.black,
        onPressed: () {
          context.read<ProductDetailController>().isBarcodeView = true;
        },
      ),
    ];
  }

  Widget _textForDetailInfo(
    String text, {
    FontWeight? fontWeight,
    double? fontSize,
    Color? textColor,
    Function()? onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Text(
        text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: textColor ?? Constants.textColor,
          fontSize: fontSize ?? 17,
          fontWeight: fontWeight ?? FontWeight.w500,
        ),
      ),
    );
  }
}
