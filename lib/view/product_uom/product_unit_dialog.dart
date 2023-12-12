import 'package:offline_pos/components/export_files.dart';

class ProductUntiDialog {
  static Future<dynamic> productUnitWidget(
    BuildContext context, {
    required dynamic object,
  }) {
    Widget spacer = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Divider(
        thickness: 1.3,
        color: Constants.disableColor.withOpacity(0.96),
      ),
    );
    return showDialog(
      context: context,
      builder: (BuildContext bContext) {
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
                    width: MediaQuery.of(context).size.width / 4,
                    height: 70,
                    decoration: BoxDecoration(
                        color: Constants.primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        )),
                    child: Center(
                      child: Text(
                        'Product Packages [${object["id"]}] \n ${object["name"]}',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  packagesWidget(object),
                  spacer,
                  SizedBox(height: 16),
                  CommonUtils.okCancelWidget(
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

  static Widget packagesWidget(dynamic object) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _eachPackageWdget(object),
        _eachPackageWdget(object),
      ],
    );
  }

  static Widget _eachPackageWdget(dynamic object) {
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
                    '9000 Ks/ Unit',
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
                'Quantity : 12',
                style: TextStyle(
                  color: Constants.textColor.withOpacity(0.9),
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Text(
          '[${object["id"]}]',
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Constants.textColor,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        Text(
          object["name"],
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Constants.textColor,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        )
      ],
    );
  }
}
