import 'dart:math';

import 'package:offline_pos/components/export_files.dart';

class ProductPackagingDialog {
  static Future<dynamic> productPackagingDialogWidget(
    BuildContext context, {
    required Product product,
    required List<ProductPackaging> productPackagings,
  }) {
    Widget spacer = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Divider(
        thickness: 1.3,
        color: Constants.disableColor.withOpacity(0.96),
      ),
    );
    TextEditingController qtyEditingController = TextEditingController();
    context
        .read<OrderProductPackagingController>()
        .resetOrderProductPackagingController();
    return CommonUtils.showGeneralDialogWidget(
      context,
      (bContext, anim1, anim2) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          content: SingleChildScrollView(
            child: Container(
              // width: MediaQuery.of(context).size.width / 4,
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
                      // maxWidth: MediaQuery.of(context).size.width / 4,
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
                  packagesWidget(
                    context,
                    product,
                    productPackagings,
                    qtyEditingController,
                  ),
                  spacer,
                  _selectedPackageWidget(
                      context, qtyEditingController, product),
                  spacer,
                  SizedBox(height: 16),
                  CommonUtils.okCancelWidget(
                    okLabel: "Add",
                    okCallback: () {
                      Product pro = Product.fromJson(
                        product.toJson(removed: false),
                      );
                      // if (qtyEditingController.text.isNotEmpty) {
                      //   pro.onhandQuantity =
                      //       int.tryParse(qtyEditingController.text) ?? 0;
                      //   pro.priceListItem = context
                      //       .read<OrderProductPackagingController>()
                      //       .selectedProductPackaging
                      //       ?.priceListItem;
                      // }
                      OrderProductPackagingController packagingController =
                          context.read<OrderProductPackagingController>();
                      pro.priceListItem = packagingController
                          .selectedProductPackaging?.priceListItem;
                      pro.packaging =
                          packagingController.selectedProductPackaging?.name;

                      pro.packageId =
                          packagingController.selectedProductPackaging?.id;

                      pro.packageQty =
                          packagingController.selectedProductPackaging?.qty;
                      context.read<CurrentOrderController>().addItemToList(
                            pro,
                            qty: int.tryParse(qtyEditingController.text),
                          );
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

  static Widget packagesWidget(
    BuildContext context,
    Product product,
    List<ProductPackaging> productPackagings,
    TextEditingController qtyEditingController,
  ) {
    List<Widget> list = [];
    List<ProductPackaging> rowList = [];
    int itemCount = 3;
    for (var i = 0; i < productPackagings.length; i += (itemCount)) {
      int start = (list.length * (itemCount));
      int end = (itemCount) + (list.length * (itemCount));
      rowList.addAll(productPackagings.getRange(
          start, min(end, productPackagings.length)));
      list.add(Row(
        children: List.generate(
          rowList.length,
          (index) => _eachPackageWdget(
              context, product, rowList[index], qtyEditingController),
        ),
      ));
      rowList = [];
      if (context.read<ViewController>().isKeyboardHide) {
        break;
      }
    }
    return Column(
      children: list,
    );
  }

  static Widget _eachPackageWdget(
    BuildContext context,
    Product product,
    ProductPackaging productPackaging,
    TextEditingController qtyEditingController,
  ) {
    return InkWell(
      onTap: () {
        context
            .read<OrderProductPackagingController>()
            .selectedProductPackaging = productPackaging;
        qtyEditingController.text = "1";
        context.read<OrderProductPackagingController>().notify();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.width / 10,
              minHeight: MediaQuery.of(context).size.width / 10,
              minWidth: MediaQuery.of(context).size.width / 12,
              maxWidth: MediaQuery.of(context).size.width / 11,
            ),
            padding: EdgeInsets.all(18),
            margin: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Constants.calculatorBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: FittedBox(
                    child: Container(
                      margin: const EdgeInsets.only(left: 28.0),
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
                        '${productPackaging.priceListItem?.fixedPrice ?? 0} Ks${productPackaging.name?.toLowerCase() == 'unit' ? '/ Unit' : ''}', //product.price
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 28.0),
                  child: CommonUtils.svgIconActionButton(
                    "assets/svg/inventory_2.svg",
                    width: 40,
                    height: 40,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Quantity : ${productPackaging.qty ?? 0}', //product.qtyInBags
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
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width / 8.5,
              minWidth: MediaQuery.of(context).size.width / 8.5,
              maxHeight: 80,
            ),
            child: Text(
              productPackaging.name ?? '',
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                color: Constants.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  static Widget _selectedPackageWidget(
    BuildContext context,
    TextEditingController qtyEditingController,
    Product product,
  ) {
    TextStyle textStyle = TextStyle(
      fontSize: 16,
      color: Constants.textColor,
      fontWeight: FontWeight.bold,
    );
    return Consumer<OrderProductPackagingController>(
        builder: (_, controller, __) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Text('Quantity : ')),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    // initialValue: controller.selectedProductPackaging?.qty,
                    controller: qtyEditingController,
                    style: TextStyle(
                      color: Constants.textColor,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: '0.00',
                      hintStyle:
                          textStyle.copyWith(color: Constants.disableColor),
                      // contentPadding: EdgeInsets.all(20),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      controller.selectedProductPackaging?.qty =
                          value.toString();
                      // e.payingAmount = value;
                      controller.notify();
                    },
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: Text('Price : ')),
                Expanded(
                  flex: 2,
                  child: Text(
                    controller
                            .selectedProductPackaging?.priceListItem?.fixedPrice
                            ?.toString() ??
                        '0',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
