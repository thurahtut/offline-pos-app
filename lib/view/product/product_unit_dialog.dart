import 'package:offline_pos/components/export_files.dart';

class ProductUntiDialog {
  static Future<dynamic> productUnitWidget(
    BuildContext context, {
    required Product product,
  }) {
    Widget spacer = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Divider(
        thickness: 1.3,
        color: Constants.disableColor.withOpacity(0.96),
      ),
    );
    return CommonUtils.showGeneralDialogWidget(
      context,
      (bContext, anim1, anim2) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          content: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width / 4,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width / 4,
                      maxHeight: 85,
                    ),
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        )),
                    child: Center(
                      child: Text(
                        'Product Packages ${product.barcode != null ? " [${product.barcode}]" : ""} \n ${product.productName}',
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  packagesWidget(context, product),
                  spacer,
                  SizedBox(height: 16),
                  CommonUtils.okCancelWidget(
                    okLabel: "Add",
                    okCallback: () {
                      Navigator.pop(context);
                    },
                    cancelCallback: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: 26),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget packagesWidget(BuildContext context, Product product) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _eachPackageWdget(context, product),
        _eachPackageWdget(context, product),
      ],
    );
  }

  static Widget _eachPackageWdget(BuildContext context, Product product) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(18),
          margin: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Constants.calculatorBgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 28.0),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Constants.accentColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Constants.greyColor2.withOpacity(0.3),
                        blurRadius: 4,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    '${0} Ks/ Unit', //product.price
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 28.0),
                child: CommonUtils.svgIconActionButton(
                  "assets/svg/inventory_2.svg",
                  width: 50,
                  height: 50,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Quantity : ${0}', //product.qtyInBags
                style: TextStyle(
                  color: Constants.textColor.withOpacity(0.9),
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Text(
          '[${product.productId}]',
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Constants.textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width / 8.5,
            minWidth: MediaQuery.of(context).size.width / 8.5,
            maxHeight: 80,
          ),
          child: Text(
            product.productName ?? '',
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Constants.textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}
