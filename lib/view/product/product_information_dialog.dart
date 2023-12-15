import '../../components/export_files.dart';

class ProductInfomationDialog {
  static Future<dynamic> productInformationDialogWidget(
    BuildContext context,
    //  {
    // required dynamic object,
    // }
  ) {
    bool isTabletMode = CommonUtils.isTabletMode(context);
    Widget spacer = Divider(
      thickness: 1.3,
      color: Constants.disableColor.withOpacity(0.96),
    );
    return CommonUtils.showGeneralDialogWidget(context,
        (bContext, anim1, anim2) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        content: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width / (isTabletMode ? 1 : 2),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width /
                      (isTabletMode ? 1 : 2),
                  height: 70,
                  decoration: BoxDecoration(
                      color: Constants.primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )),
                  child: Center(
                    child: Text(
                      'Product Information',
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
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(height: 8),
                      Row(
                        children: const [
                          Expanded(
                            child: Text(
                              '[8836000017357] 100 Plus Isotonic Drink Original 23007160 - 8349028809304',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Text(
                            '900.00 Ks',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Constants.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Financials',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        children: const [
                          Text(
                            'Price excl. VAT:',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                          Text(
                            '900.00 Ks',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 2, child: SizedBox()),
                        ],
                      ),
                      Row(
                        children: const [
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  'Cost:',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Expanded(flex: 1, child: SizedBox()),
                                Text(
                                  '0.00 Ks',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Expanded(flex: 2, child: SizedBox()),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  'EZ Price List:',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Expanded(flex: 2, child: SizedBox()),
                                Text(
                                  '900.00 Ks',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: const [
                          Text(
                            'Margin:',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                          Text(
                            '0.00 Ks (%)',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 2, child: SizedBox()),
                        ],
                      ),
                      spacer,
                      SizedBox(height: 10),
                      Text(
                        'Inventory',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        children: const [
                          Text(
                            'Main Warehouse:',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 2, child: SizedBox()),
                          Text(
                            '0 Unit available,',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                          Text(
                            '0 Forecasted',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                        ],
                      ),
                      Row(
                        children: const [
                          Text(
                            'Eazy 1:',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 2, child: SizedBox()),
                          Text(
                            '0 Unit available,',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                          Text(
                            '0 Forecasted',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                        ],
                      ),
                      Row(
                        children: const [
                          Text(
                            'Expiry WH:',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 2, child: SizedBox()),
                          Text(
                            '-2 Unit available,',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                          Text(
                            '-2 Forecasted',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                        ],
                      ),
                      Row(
                        children: const [
                          Text(
                            'Easy 2:',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 2, child: SizedBox()),
                          Text(
                            '0 Unit available,',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                          Text(
                            '0 Forecasted',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                        ],
                      ),
                      Row(
                        children: const [
                          Text(
                            'Easy 3:',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 2, child: SizedBox()),
                          Text(
                            '0 Unit available,',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                          Text(
                            '0 Forecasted',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                        ],
                      ),
                      Row(
                        children: const [
                          Text(
                            'Easy 4:',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 2, child: SizedBox()),
                          Text(
                            '0 Unit available,',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                          Text(
                            '0 Forecasted',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                        ],
                      ),
                      Row(
                        children: const [
                          Text(
                            'Easy 5:',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 2, child: SizedBox()),
                          Text(
                            '0 Unit available,',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                          Text(
                            '0 Forecasted',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                        ],
                      ),
                      Row(
                        children: const [
                          Text(
                            'Easy 6:',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 2, child: SizedBox()),
                          Text(
                            '0 Unit available,',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                          Text(
                            '0 Forecasted',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                        ],
                      ),
                      Row(
                        children: const [
                          Text(
                            'Easy 7:',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 2, child: SizedBox()),
                          Text(
                            '0 Unit available,',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                          Text(
                            '0 Forecasted',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                        ],
                      ),
                      Row(
                        children: const [
                          Text(
                            'SSS Office WH:',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 2, child: SizedBox()),
                          Text(
                            '0 Unit available,',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                          Text(
                            '0 Forecasted',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                        ],
                      ),
                      Row(
                        children: const [
                          Text(
                            'Transit Warehouse:',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 2, child: SizedBox()),
                          Text(
                            '0 Unit available,',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                          Text(
                            '0 Forecasted',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                        ],
                      ),
                      Row(
                        children: const [
                          Text(
                            'MZ Warehouse:',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 2, child: SizedBox()),
                          Text(
                            '0 Unit available,',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                          Text(
                            '0 Forecasted',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                        ],
                      ),
                      Row(
                        children: const [
                          Text(
                            'SSS International Co,Ltd Warehouse #47:',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 2, child: SizedBox()),
                          Text(
                            '0 Unit available,',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                          Text(
                            '0 Forecasted',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                        ],
                      ),
                      Row(
                        children: const [
                          Text(
                            'Easy 1:',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 2, child: SizedBox()),
                          Text(
                            '0 Unit available,',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                          Text(
                            '0 Forecasted',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                        ],
                      ),
                      Row(
                        children: const [
                          Text(
                            'Easy 1:',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 2, child: SizedBox()),
                          Text(
                            '0 Unit available,',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                          Text(
                            '0 Forecasted',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                        ],
                      ),
                      spacer,
                      SizedBox(height: 10),
                      Text(
                        'Replenishment',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'PREMIUM DISTIBUTION COMPANY LIMITED : 1 DAYS 0.00Ks',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      spacer,
                      SizedBox(height: 10),
                      Text(
                        'Order',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        children: const [
                          Text(
                            'Total Price excl. VAT:',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                          Text(
                            '900.00 Ks',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 3, child: SizedBox()),
                        ],
                      ),
                      Row(
                        children: const [
                          Text(
                            'Cost:',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                          Text(
                            '0.00 Ks',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 3, child: SizedBox()),
                        ],
                      ),
                      Row(
                        children: const [
                          Text(
                            'Margin:',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                          Text(
                            '0.00 Ks(0%)',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(flex: 3, child: SizedBox()),
                        ],
                      ),
                      spacer,
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: BorderContainer(
                          text: 'Close',
                          width: 200,
                          textSize: 18,
                          textColor: Constants.primaryColor,
                          onTap: () {
                            Navigator.pop(bContext);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
