import 'package:offline_pos/components/export_files.dart';

class ProductDetailFilter extends StatelessWidget {
  const ProductDetailFilter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isTabletMode = CommonUtils.isTabletMode(context);
    bool isMobileMode = CommonUtils.isMobileMode(context);
    return Row(
      children: [
        SizedBox(width: 16),
        Expanded(
          child: Row(
            children: [
              BorderContainer(
                text: context.watch<ProductDetailController>().mode ==
                            ViewMode.create ||
                        context.watch<ProductDetailController>().mode ==
                            ViewMode.edit
                    ? 'Save'
                    : 'Edit',
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                containerColor: primaryColor,
                textColor: Colors.white,
                width: 150,
                textSize: 20,
                radius: 16,
                onTap: () async {
                  if (context.read<ProductDetailController>().mode ==
                      ViewMode.create) {
                    if (context
                            .read<ProductDetailController>()
                            .formKey
                            .currentState
                            ?.validate() ??
                        false) {
                      context
                          .read<ProductDetailController>()
                          .formKey
                          .currentState
                          ?.save();
                      await ProductTable.insert(context
                              .read<ProductDetailController>()
                              .creatingProduct)
                          .then((value) {
                        if (value > 0) {
                          context.read<ProductDetailController>().mode =
                              ViewMode.view;
                          context
                              .read<ProductDetailController>()
                              .creatingProduct = Product();
                          Navigator.pop(context);
                          ProductTable.getProductByProductId(value)
                              .then((product) {
                            if (product == null) {
                              CommonUtils.showSnackBar(
                                message: 'Inserting '
                                      '"${context.read<ProductDetailController>().creatingProduct.productName}"'
                                    ' does not have! Something was wrong!',
                              );
                              return;
                            }
                            int index = context
                                .read<ProductListController>()
                                .productList
                                .indexWhere((element) =>
                                    element.productId == product.productId);
                            if (index != -1) {
                              context
                                  .read<ProductListController>()
                                  .productList[index] = product;
                            } else {
                              context
                                  .read<ProductListController>()
                                  .productList
                                  .add(product);
                            }

                            context.read<ProductListController>().notify();
                            context
                                    .read<ProductListController>()
                                    .productInfoDataSource =
                                DataSourceForProductListScreen(
                                    context,
                                    context
                                        .read<ProductListController>()
                                        .productList,
                                    () {});
                          });
                        } else {
                          CommonUtils.showSnackBar(
                            message: 'Creating '
                                  '"${context.read<ProductDetailController>().creatingProduct.productName}"'
                                ' is failed!',
                          );
                        }
                      });
                    }
                    return;
                  }
                  if (context.read<ProductDetailController>().mode ==
                      ViewMode.edit) {
                    if (context
                            .read<ProductDetailController>()
                            .formKey
                            .currentState
                            ?.validate() ??
                        false) {
                      context
                          .read<ProductDetailController>()
                          .formKey
                          .currentState
                          ?.save();
                      await ProductTable.update(context
                              .read<ProductDetailController>()
                              .creatingProduct)
                          .then((value) {
                        if (value > 0) {
                          context.read<ProductDetailController>().mode =
                              ViewMode.view;
                          ProductTable.getProductByProductId(value)
                              .then((product) {
                            if (product == null) {
                              CommonUtils.showSnackBar(
                                message: 'Updating '
                                      '"${context.read<ProductDetailController>().creatingProduct.productName}"'
                                    ' does not have! Something was wrong!',
                              );
                              return;
                            }
                            int index = context
                                .read<ProductListController>()
                                .productList
                                .indexWhere((element) =>
                                    element.productId == product.productId);
                            if (index != -1) {
                              context
                                  .read<ProductListController>()
                                  .productList[index] = product;
                            } else {
                              context
                                  .read<ProductListController>()
                                  .productList
                                  .add(product);
                            }

                            context.read<ProductListController>().notify();
                            context
                                    .read<ProductListController>()
                                    .productInfoDataSource =
                                DataSourceForProductListScreen(
                                    context,
                                    context
                                        .read<ProductListController>()
                                        .productList,
                                    () {});
                          });
                        } else {
                          CommonUtils.showSnackBar(
                            message: 'Updating '
                                  '"${context.read<ProductDetailController>().creatingProduct.productName}"'
                                ' is failed!',
                          );
                        }
                      });
                    }
                    return;
                  }
                  context.read<ProductDetailController>().mode = ViewMode.edit;
                },
              ),
              SizedBox(width: 4),
              if (context.watch<ProductDetailController>().mode ==
                            ViewMode.create ||
                        context.watch<ProductDetailController>().mode ==
                      ViewMode.edit)
                BorderContainer(
                  text: 'Discard',
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                width: 150,
                textSize: 20,
                radius: 16,
                onTap: () {
                  if (context.read<ProductDetailController>().mode ==
                          ViewMode.create ||
                      context.read<ProductDetailController>().mode ==
                          ViewMode.edit) {
                    context.read<ProductDetailController>().mode =
                        ViewMode.view;
                    return;
                  }
                  context.read<ProductDetailController>().mode =
                      ViewMode.create;
                },
              ),
              SizedBox(width: 4),
              CommonUtils.appBarActionButtonWithText(
                'assets/svg/print.svg',
                'Print',
                // width: 25,
              ),
              SizedBox(width: 4),
              CommonUtils.iconActionButtonWithText(
                Icons.tune_rounded,
                'Action',
                // width: 25,
              ),
              (isTabletMode != true && isMobileMode != true)
                  ? Expanded(child: SizedBox())
                  : SizedBox(),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (isTabletMode != true && isMobileMode != true)
                Expanded(child: SizedBox()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CommonUtils.appBarActionButtonWithText(
                      'assets/svg/filter_alt.svg', 'Filters',
                      width: 35, height: 35),
                  SizedBox(width: 4),
                  CommonUtils.appBarActionButtonWithText(
                    'assets/svg/ad_group.svg',
                    'Group By',
                    // width: 25,
                  ),
                  SizedBox(width: 4),
                  CommonUtils.appBarActionButtonWithText(
                    'assets/svg/favorite.svg',
                    'Favorites',
                  ),
                  SizedBox(width: 4),
                  CommonUtils.svgIconActionButton('assets/svg/view_list.svg'),
                  SizedBox(width: 4),
                  CommonUtils.svgIconActionButton('assets/svg/grid_view.svg'),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: 16),
      ],
    );
  }
}
