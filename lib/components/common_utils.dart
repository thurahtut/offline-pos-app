import 'dart:convert';

import 'package:excel/excel.dart' as exl;
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:offline_pos/components/export_files.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

Color primaryColor = Color(0xFF207810); //007ACC

class CommonUtils {
  static bool isTabletMode(BuildContext context) {
    return MediaQuery.of(context).size.width < 1080;
  }

  static bool isMobileMode(BuildContext context) {
    return MediaQuery.of(context).size.width < 500;
  }

  static showSnackBar(
      {BuildContext? context, required String message, Duration? duration}) {
    if (context != null ||
        NavigationService.navigatorKey.currentContext != null) {
      ScaffoldMessenger.of(
              context ?? NavigationService.navigatorKey.currentContext!)
          .showSnackBar(SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        duration: duration ?? Duration(seconds: 2),
      ));
    }
  }

  static final NumberFormat priceFormat = NumberFormat("#,##0.##", "en_US");

  static Widget svgIconActionButton(
    String svg, {
    double? width,
    double? height,
    double? radius,
    Color? iconColor,
    Function()? onPressed,
    bool? withContianer,
    Color? containerColor,
    bool? withBorder,
    Color? borderWithPrimaryColor,
    double? padding,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: withContianer != null ? EdgeInsets.all(padding ?? 3) : null,
        decoration: withContianer != null
            ? BoxDecoration(
                borderRadius:
                    BorderRadius.circular(radius ?? (((width ?? 27) / 2) + 10)),
                color: containerColor,
                border: withBorder == true
                    ? Border.all(
                        color: borderWithPrimaryColor ??
                            containerColor ??
                            Colors.transparent,
                      )
                    : null,
              )
            : null,
        child: SvgPicture.asset(
          svg,
          width: width ?? 27,
          height: height ?? 27,
          colorFilter: ColorFilter.mode(
            iconColor ?? primaryColor,
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
    double? padding,
    double? radius,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: withContianer != null ? EdgeInsets.all(padding ?? 3) : null,
        decoration: withContianer != null
            ? BoxDecoration(
                borderRadius:
                    BorderRadius.circular(radius ?? ((size ?? 50) / 2)),
                color: containerColor,
              )
            : null,
        child: Icon(
          icon,
          size: size ?? 27,
          color: iconColor ?? primaryColor,
        ),
      ),
    );
  }

  static Widget appBarActionButtonWithText(
    String svg,
    String text, {
    double? width,
    double? height,
    Color? iconColor,
    Color? textColor,
    double? fontSize,
    Widget Function(Widget child)? iconParentWidget,
    Function()? onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconParentWidget != null
              ? iconParentWidget(CommonUtils.svgIconActionButton(
                  svg,
                  width: width,
                  height: height,
                  iconColor: iconColor,
                  onPressed: onPressed,
                ))
              : CommonUtils.svgIconActionButton(
                  svg,
                  width: width,
                  height: height,
                  iconColor: iconColor,
                  onPressed: onPressed,
                ),
          SizedBox(width: 4),
          Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: textColor ?? Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }

  static Widget iconActionButtonWithText(
    IconData icon,
    String text, {
    double? size,
    Color? iconColor,
    Color? textColor,
    double? fontSize,
    Function()? onPressed,
    bool? switchChild,
    FontWeight? fontWeight,
  }) {
    List<Widget> list = [
      CommonUtils.iconActionButton(
        icon,
        size: size,
        iconColor: iconColor,
        onPressed: onPressed,
      ),
      SizedBox(width: 6),
      Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: textColor ?? Colors.black,
          fontWeight: fontWeight ?? FontWeight.w500,
          fontSize: fontSize,
        ),
      ),
    ];
    return InkWell(
      onTap: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [...switchChild == true ? list.reversed : list],
      ),
    );
  }

  static List sideBarList = [
    // {
    //   "svgPicture": 'assets/svg/info.svg',
    //   "text": 'Info',
    //   "onTap": () {
    //     if (NavigationService.navigatorKey.currentContext != null) {
    //       ProductInfomationDialog.productInformationDialogWidget(
    //           NavigationService.navigatorKey.currentContext!);
    //     }
    //   },
    // },
    {
      "svgPicture": 'assets/svg/refresh.svg',
      "text": 'Refund',
      "onTap": () {
        if (NavigationService.navigatorKey.currentContext != null) {
          NavigationService.navigatorKey.currentContext!
              .read<OrderListController>()
              .isRefund = true;
          NavigationService.navigatorKey.currentContext!
              .read<OrderListController>()
              .typefilterValue = OrderState.paid.text;
          Navigator.pushNamed(
            NavigationService.navigatorKey.currentContext!,
            OrderListScreen.routeName,
          );
        }
      },
    },
    // {
    //   "svgPicture": 'assets/svg/qr_code.svg',
    //   "text": 'QR',
    //   "onTap": () {},
    // },
    {
      "svgPicture": 'assets/svg/sell.svg',
      "text": 'Print Summary Report',
      "onTap": () {
        if (NavigationService.navigatorKey.currentContext != null) {
          Navigator.pushNamed(
            NavigationService.navigatorKey.currentContext!,
            SummaryReportScreen.routeName,
          );
        }
      },
    },
    {
      "svgPicture": 'assets/svg/history.svg',
      "text": 'Order History',
      "onTap": () {
        if (NavigationService.navigatorKey.currentContext != null) {
          Navigator.pushNamed(
            NavigationService.navigatorKey.currentContext!,
            OrderListScreen.routeName,
          );
        }
      },
    },
    // {
    //   "svgPicture": 'assets/svg/payments.svg',
    //   "text": 'Cash In/Out Statement',
    //   "onTap": () {
    //     if (NavigationService.navigatorKey.currentContext != null) {
    //       PrintStatementDialog.printStatementDialogWidget(
    //           NavigationService.navigatorKey.currentContext!);
    //     }
    //   },
    // },
    {
      "svgPicture": 'assets/svg/credit_card.svg',
      "text": 'Payments',
      "onTap": () {
        if (NavigationService.navigatorKey.currentContext != null) {
          Navigator.pushNamed(
            NavigationService.navigatorKey.currentContext!,
            PaymentMethodScreen.routeName,
          );

          // PaymentDialog.paymentDialogWidget(
          //     NavigationService.navigatorKey.currentContext!);
        }
      },
    },
    // {
    //   "svgPicture": 'assets/svg/link.svg',
    //   "text": 'Quotation / Order',
    //   "onTap": () {
    //     if (NavigationService.navigatorKey.currentContext != null) {
    //       Navigator.pushNamed(
    //         NavigationService.navigatorKey.currentContext!,
    //         QuotationOrderListScreen.routeName,
    //       );
    //     }
    //   },
    // },
    // {
    //   "svgPicture": 'assets/svg/sell.svg',
    //   "text": 'Change UOM',
    //   "onTap": () {},
    // },
    // {
    //   "svgPicture": 'assets/svg/assignment.svg',
    //   "text": 'Template Products',
    //   "onTap": () {},
    // },
    // {
    //   "svgPicture": 'assets/svg/sync.svg',
    //   "text": 'Sync',
    //   "onTap": () {},
    // },
  ];

  static Widget eachCalculateButtonWidget({
    String? text,
    IconData? icon,
    String? prefixSvg,
    Color? iconColor,
    Color? containerColor,
    Color? textColor,
    Color? svgColor,
    double? width,
    double? height,
    double? iconSize,
    double? textSize,
    int? maxLines,
    Function()? onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: width ?? 50,
        height: height ?? 50,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color:
              containerColor ?? Constants.calculatorBgColor.withOpacity(0.77),
        ),
        child: Row(
          mainAxisAlignment: prefixSvg != null
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (prefixSvg != null) SizedBox(width: 4),
            if (prefixSvg != null)
              svgIconActionButton(
                prefixSvg,
                iconColor: svgColor,
              ),
            if (prefixSvg != null) SizedBox(width: 4),
            if (icon != null)
              Icon(
                icon,
                size: iconSize ?? 24,
                color: iconColor ?? primaryColor,
              ),
            if (text != null)
              Expanded(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: maxLines ?? 1,
                  style: TextStyle(
                    color: textColor ?? Constants.textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: textSize ?? 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  static Widget okCancelWidget({
    String? okLabel,
    String? cancelLabel,
    bool? switchBtns,
    double? width,
    double? textSize,
    Color? cancelContainerColor,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? outsidePadding,
    Function()? okCallback,
    Function()? cancelCallback,
  }) {
    List<Widget> list = [
      Expanded(
        child: BorderContainer(
          text: okLabel ?? 'OK',
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          containerColor: primaryColor,
          textColor: Colors.white,
          width: width ?? 140,
          textSize: textSize ?? 20,
          radius: 16,
          onTap: okCallback,
        ),
      ),
      SizedBox(width: 8),
      Expanded(
        child: BorderContainer(
          text: cancelLabel ?? 'Cancel',
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          containerColor: cancelContainerColor,
          borderWithPrimaryColor: cancelContainerColor != null ? true : false,
          width: width ?? 140,
          textSize: textSize ?? 20,
          radius: 16,
          onTap: cancelCallback,
        ),
      ),
    ];
    return Padding(
      padding: outsidePadding ?? EdgeInsets.all(16.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        ...(switchBtns == true) ? list.reversed : list,
      ]),
    );
  }

  static Future<Object?> showGeneralDialogWidget(
    BuildContext mainContext,
    Widget Function(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) pageBuilder,
  ) {
    return showGeneralDialog(
      context: mainContext,
      barrierDismissible: true,
      barrierLabel: "Label",
      transitionDuration: Duration(milliseconds: 300),
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
      pageBuilder: pageBuilder,
    );
  }

  static QuotationDataModel demoQuotationData = QuotationDataModel(
    order: "S02034",
    date: "12-12-2023 12:30 PM",
    customer: "BG Bakery",
    salePerson: "Admin",
    total: 467000,
    state: "Quotation",
  );

  // static ProductPackaging demoProductPackaging = ProductPackaging(
  //   product: "100 Pipers whisky 175ML",
  //   containedQuantity: 49,
  //   barcode: "0101234567890128TEC-IT",
  //   routes: false,
  //   purchase: true,
  //   sale: true,
  //   company: true,
  // );

  static DataColumn2 dataColumn({
    required String text,
    Function(int, bool)? onSort,
    double? fixedWidth,
    Color? textColor,
  }) {
    return DataColumn2(
      fixedWidth: fixedWidth,
      label: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: textColor ?? Colors.white,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
      onSort: onSort,
    );
  }

  static void showAlertDialogWithOkButton(
    BuildContext context, {
    String? title,
    String? content,
    Function()? callback,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title != null ? Text(title) : null,
          content: content != null ? Text(content) : null,
          actions: [
            TextButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
                callback?.call();
              },
            ),
          ],
        );
      },
    );
  }

  static List<String> unitList = [
    "none",
    "mm",
    "cm",
    "in3",
    "inches",
    "ozs",
    "fl oz",
    "ft2",
  ];

  static List<String> brandList = [
    "None",
    "Flee",
    "Evenline",
    "OK",
    "OKAMOTO",
    "APPETON",
  ];

  static String getLocaleDateTime(String dateFormat, String? dateTime) {
    DateTime? date = dateTime != null ? DateTime.parse(dateTime) : null;
    date = date?.add(Duration(hours: 6, minutes: 30));
    return date != null ? (DateFormat(dateFormat).format(date).toString()) : '';
  }

  static Future<void> saveDeletedItemLogs(
      List<DeletedProductLog> deletedProductLogs) async {
    if (kIsWeb) {
      return;
    }
    String externalDir =
        await externalDirectoryPath("Offline Pos Deleted Product Log");

    String customDate = CommonUtils.getLocaleDateTime(
      "dd-MM-yyyy",
      CommonUtils.getDateTimeNow().toString(),
    );
    var filePath =
        '$externalDir/${customDate}_deleted_products_excel_file.xlsx';
    File deletedLogExcel = File(filePath);
    Map<String, dynamic> map = {};
    exl.Excel excel;
    if (await deletedLogExcel.exists()) {
      var bytes = deletedLogExcel.readAsBytesSync();
      excel = exl.Excel.decodeBytes(bytes);
      map = addDataToExcel(excel, false, deletedProductLogs);
    } else {
      excel = exl.Excel.createExcel();
      map = addDataToExcel(excel, true, deletedProductLogs);
    }
    if (map["isUpdated"]) {
      excel = map["excel"];
      // excel.encode()?.then((onValue) {
      //   File(filePath).writeAsBytesSync(onValue);
      //   print("New data added to existing Excel file: $filePath");
      // });
      var bytes = excel.encode();
      if (bytes?.isNotEmpty ?? false) {
        await deletedLogExcel.writeAsBytes(bytes!);
      }
    }

    // Open file (using third-party package like `open_file`)
    // await OpenFile.open(file.path);
  }

  static Future<String> externalDirectoryPath(String folderName) async {
    Directory? externalDir;
    // Check if external storage is available
    if (!kIsWeb && Platform.isWindows) {
      //bool isExist = await Directory('C:/').exists();
      if (await Directory('C:/').exists()) {
        String path = "C:/$folderName"; // Path to the folder you want to create
        await Directory(path)
            .create(recursive: true) // Create the folder recursively
            .then((Directory directory) {
          externalDir = directory;
        }).catchError((error) {
          externalDir = Directory('C:/');
        });
      }
    }
    // If external storage is not available or not supported, save in the user directory
    externalDir ??= await getApplicationDocumentsDirectory();
    return externalDir!.path;
  }

  static Map<String, dynamic> addDataToExcel(
    exl.Excel? excel,
    bool isNew,
    List<DeletedProductLog> deletedProductLogs,
  ) {
    bool isUpdated = false;
    if (excel != null && deletedProductLogs.isNotEmpty) {
      exl.Sheet sheetObject = excel['Sheet1'];

      if (isNew) {
        // Add data to cells
        sheetObject.cell(exl.CellIndex.indexByString('A1')).value =
            exl.TextCellValue('Order Id');
        sheetObject.cell(exl.CellIndex.indexByString('B1')).value =
            exl.TextCellValue('Product Id');
        sheetObject.cell(exl.CellIndex.indexByString('C1')).value =
            exl.TextCellValue('Product Name');
        sheetObject.cell(exl.CellIndex.indexByString('D1')).value =
            exl.TextCellValue('Employee Id');
        sheetObject.cell(exl.CellIndex.indexByString('E1')).value =
            exl.TextCellValue('Employee Name');
        sheetObject.cell(exl.CellIndex.indexByString('F1')).value =
            exl.TextCellValue('Original Quantity');
        sheetObject.cell(exl.CellIndex.indexByString('G1')).value =
            exl.TextCellValue('Updated Quantity');
        sheetObject.cell(exl.CellIndex.indexByString('H1')).value =
            exl.TextCellValue('Session Id');
        sheetObject.cell(exl.CellIndex.indexByString('I1')).value =
            exl.TextCellValue('Date');
      }

      int nextRowIndex = sheetObject.maxRows;
      for (int row = 0; row < deletedProductLogs.length; row++) {
        DeletedProductLog eachData = deletedProductLogs[row];
        List list = eachData.toJson().values.toList();
        for (int col = 0; col < list.length; col++) {
          if (!isUpdated) {
            isUpdated = true;
          }
          String eachKey = list[col]?.toString() ?? '';
          sheetObject
              .cell(exl.CellIndex.indexByColumnRow(
                  rowIndex: nextRowIndex + row, columnIndex: col))
              .value = exl.TextCellValue(eachKey);
        }
      }
    }
    return {"isUpdated": isUpdated, "excel": excel};
  }

  static double getPercentAmountTaxOnProduct(Product? product) {
    double taxPercent = 0;
    if (product != null &&
        product.amountTax != null &&
        (double.tryParse(product.amountTax!.description?.replaceAll('%', "") ??
                    '') ??
                0) >
            0) {
      taxPercent =
          double.parse(product.amountTax!.description!.replaceAll('%', ""));
    }
    return taxPercent / 100;
  }

  static sessionLoginMethod(
    BuildContext context,
    bool navigate,
  ) {
    int sessionId = context.read<LoginUserController>().posSession?.id ?? 0;
    return ChooseCashierDialog.chooseCashierDialogWidget(context)
        .then((value) async {
      if (value == true) {
        LoginUserController controller = context.read<LoginUserController>();
        CurrentOrderController currentOrderController =
            context.read<CurrentOrderController>();

        PendingOrderTable.getPendingOrder().then((orderHistory) async {
          if (orderHistory == null) {
            createSessionAndGoToMainScreen(
              context,
              navigate,
              controller,
            );
            return;
          }
          currentOrderController.orderHistory = orderHistory;
          if (orderHistory.partnerId != null && orderHistory.partnerId != 0) {
            await CustomerTable.getCustomerNameByCustomerId(
                    customerId: orderHistory.partnerId)
                .then((customerName) =>
                    currentOrderController.selectedCustomer = Customer(
                      id: orderHistory.partnerId,
                      name: customerName,
                    ));
          }
          PendingOrderTable.getPendingCurrentOrderList(sessionId: sessionId)
              .then((productList) async {
            currentOrderController.currentOrderList = productList;
            createSessionAndGoToMainScreen(
              context,
              navigate,
              controller,
              resetController: false,
            );
          });
        });
      }
    });
  }

  static createSessionAndGoToMainScreen(
    BuildContext context,
    bool navigate,
    LoginUserController controller, {
    bool? resetController,
  }) {
    if (controller.posSession != null) {
      if (navigate) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => MainScreen(
                    resetController: resetController,
                  )),
          ModalRoute.withName("/Home"),
        );
      }
    } else {
      return CreateSessionDialog.createSessionDialogWidget(context, true)
          .then((value) {
        if (value == true) {
          context.read<ThemeSettingController>().notify();
          if (navigate) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => MainScreen(
                        resetController: resetController,
                      )),
              ModalRoute.withName("/Home"),
            );
          }
        }
      });
    }
  }

  static Future<void> saveAPIErrorLogs(String logs) async {
    if (kIsWeb) {
      return;
    }
    String externalDir =
        await externalDirectoryPath("Offline Pos Api Error Logs");

    String customDate = CommonUtils.getLocaleDateTime(
      "dd-MM-yyyy",
      CommonUtils.getDateTimeNow().toString(),
    );
    var filePath = '$externalDir/${customDate}_api_error_log_excel_file.xlsx';
    File deletedLogExcel = File(filePath);
    Map<String, dynamic> map = {};
    exl.Excel excel;
    if (await deletedLogExcel.exists()) {
      var bytes = deletedLogExcel.readAsBytesSync();
      excel = exl.Excel.decodeBytes(bytes);
      map = addApiErrorDataToExcel(excel, false, logs);
    } else {
      excel = exl.Excel.createExcel();
      map = addApiErrorDataToExcel(excel, true, logs);
    }
    if (map["isUpdated"]) {
      excel = map["excel"];
      var bytes = excel.encode();
      if (bytes?.isNotEmpty ?? false) {
        await deletedLogExcel.writeAsBytes(bytes!);
      }
    }
  }

  static Map<String, dynamic> addApiErrorDataToExcel(
    exl.Excel? excel,
    bool isNew,
    String logs,
  ) {
    bool isUpdated = false;
    if (excel != null && logs.isNotEmpty) {
      exl.Sheet sheetObject = excel['Sheet1'];

      if (isNew) {
        sheetObject.cell(exl.CellIndex.indexByString('A1')).value =
            exl.TextCellValue('Time');
        sheetObject.cell(exl.CellIndex.indexByString('B1')).value =
            exl.TextCellValue('Error');
      }

      int nextRowIndex = sheetObject.maxRows;

      sheetObject
          .cell(exl.CellIndex.indexByColumnRow(
              rowIndex: nextRowIndex, columnIndex: 0))
          .value = exl.TextCellValue(CommonUtils.getDateTimeNow().toString());

      sheetObject
          .cell(exl.CellIndex.indexByColumnRow(
              rowIndex: nextRowIndex, columnIndex: 1))
          .value = exl.TextCellValue(logs);
      isUpdated = true;
    }
    return {"isUpdated": isUpdated, "excel": excel};
  }

  static Future<void> saveOrderDeleteLogs(String logs) async {
    if (kIsWeb) {
      return;
    }
    String externalDir =
        await externalDirectoryPath("Offline Pos Deleted Order Logs");

    String customDate = CommonUtils.getLocaleDateTime(
      "dd-MM-yyyy",
      CommonUtils.getDateTimeNow().toString(),
    );
    var filePath =
        '$externalDir/${customDate}_order_history_log_excel_file.xlsx';
    File deletedLogExcel = File(filePath);
    Map<String, dynamic> map = {};
    exl.Excel excel;
    if (await deletedLogExcel.exists()) {
      var bytes = deletedLogExcel.readAsBytesSync();
      excel = exl.Excel.decodeBytes(bytes);
      map = addOrderDeletedDataToExcel(excel, false, logs);
    } else {
      excel = exl.Excel.createExcel();
      map = addOrderDeletedDataToExcel(excel, true, logs);
    }
    if (map["isUpdated"]) {
      excel = map["excel"];
      var bytes = excel.encode();
      if (bytes?.isNotEmpty ?? false) {
        await deletedLogExcel.writeAsBytes(bytes!);
      }
    }
  }

  static Map<String, dynamic> addOrderDeletedDataToExcel(
    exl.Excel? excel,
    bool isNew,
    String logs,
  ) {
    bool isUpdated = false;
    if (excel != null && logs.isNotEmpty) {
      exl.Sheet sheetObject = excel['Sheet1'];

      if (isNew) {
        sheetObject.cell(exl.CellIndex.indexByString('A1')).value =
            exl.TextCellValue('Time');
        sheetObject.cell(exl.CellIndex.indexByString('B1')).value =
            exl.TextCellValue('Deleted Orders');
      }

      int nextRowIndex = sheetObject.maxRows;

      sheetObject
          .cell(exl.CellIndex.indexByColumnRow(
              rowIndex: nextRowIndex, columnIndex: 0))
          .value = exl.TextCellValue(CommonUtils.getDateTimeNow().toString());

      sheetObject
          .cell(exl.CellIndex.indexByColumnRow(
              rowIndex: nextRowIndex, columnIndex: 1))
          .value = exl.TextCellValue(logs);
      isUpdated = true;
    }
    return {"isUpdated": isUpdated, "excel": excel};
  }

  static String splitTimeToReadable(DateTime dateTime) {
    String time = dateTime.millisecondsSinceEpoch.toString();
    List<String> list = [];
    String first = time.substring(0, 5);
    String second = time.replaceFirst(first, '').substring(0, 3);
    String remainingStr = time.replaceFirst(first, '').replaceFirst(second, '');
    String splittedStr = remainingStr;
    for (int i = 0; i < remainingStr.length; i += 4) {
      if (splittedStr.length > 4) {
        String toSplitStr = splittedStr.substring(0, 4);
        list.add(toSplitStr);
        splittedStr = splittedStr.replaceFirst(toSplitStr, '');
      } else {
        list.add(splittedStr);
        break;
      }
    }
    return "${first}_${second}_${list.join("_")}";
  }

  static Future<void> createOrderHistory(BuildContext context) async {
    CurrentOrderController currentOrderController =
        context.read<CurrentOrderController>();
    DateTime orderDate = CommonUtils.getDateTimeNow();
    String changedTimeToReadable = CommonUtils.splitTimeToReadable(orderDate);
    Map<String, double> map = currentOrderController
        .getTotalQty(context.read<CurrentOrderController>().currentOrderList);

    OrderHistory orderHistory = currentOrderController.orderHistory ??
        OrderHistory(
          dateOrder: orderDate.toString(),
          createDate: orderDate.toString(),
          createUid:
              context.read<LoginUserController>().loginUser?.userData?.id ?? 0,
          partnerId: currentOrderController.selectedCustomer?.id,
          partnerName: currentOrderController.selectedCustomer?.name,
          employeeId:
              context.read<LoginUserController>().loginEmployee?.id ?? 0,
          employeeName:
              context.read<LoginUserController>().loginEmployee?.name ?? '',
          configId: context.read<LoginUserController>().posConfig?.id ?? 0,
          sessionId: context.read<LoginUserController>().posSession?.id ?? 0,
          sessionName:
              context.read<LoginUserController>().posSession?.name ?? '',
          sequenceNumber: changedTimeToReadable,
          name:
              "${context.read<LoginUserController>().posConfig?.name}/ $changedTimeToReadable",
          state: OrderState.draft.text,
          amountReturn: 0,
          loyaltyPoints: 0,
          nbPrint: 0,
          pointsWon: "0.00",
          pricelistId:
              context.read<LoginUserController>().posConfig?.pricelistId ?? 0,
          qrDt: orderDate.toString(),
          returnStatus: "nothing_return",
          tipAmount: 0,
          toInvoice: true,
          toShip: false,
          userId:
              context.read<LoginUserController>().loginUser?.userData?.id ?? 0,
          sequenceId:
              context.read<LoginUserController>().posConfig?.sequenceId ?? 0,
          sequenceLineId:
              context.read<LoginUserController>().posConfig?.sequenceLineId ??
                  0,
          amountPaid: 0,
          orderCondition: OrderCondition.unsync.text,
        );

    orderHistory.amountTotal = map["total"]?.toInt() ?? 0;
    orderHistory.totalQty = map["qty"]?.toInt() ?? 0;
    orderHistory.totalItem = currentOrderController.currentOrderList.length;
    orderHistory.amountTax = map["tax"] ?? 0;
    orderHistory.amountUntaxed = map["untaxed"] ?? 0;

    final Database db = await DatabaseHelper().db;
    await OrderHistoryTable.insertOrUpdate(db, orderHistory)
        .then((value) async {
      if (value <= 0) {
        CommonUtils.showSnackBar(
            context: context,
            message: "Creating/Updating order : something was wrong!");
        return;
      }
      orderHistory.id = value;
      currentOrderController.orderHistory = orderHistory;
    });

    PendingOrderTable.insertOrUpdatePendingOrderWithDB(
        db: db, value: jsonEncode(orderHistory));
  }

  static Future<void> uploadOrderHistoryToDatabase(BuildContext context,
      {bool? isNavigate = true}) async {
    LoginUserController loginUserController =
        context.read<LoginUserController>();
    CurrentOrderController currentOrderController =
        context.read<CurrentOrderController>();
    DateTime orderDate = CommonUtils.getDateTimeNow();

    Map<String, double> map = currentOrderController
        .getTotalQty(context.read<CurrentOrderController>().currentOrderList);
    if (currentOrderController.orderHistory == null) {
      await createOrderHistory(context);
    }

    currentOrderController.orderHistory!.writeDate = orderDate.toString();
    currentOrderController.orderHistory!.writeUid =
        loginUserController.loginUser?.userData?.id ?? 0;
    currentOrderController.orderHistory!.partnerId =
        currentOrderController.selectedCustomer?.id;

    currentOrderController.orderHistory?.amountTotal =
        map["total"]?.toInt() ?? 0;
    currentOrderController.orderHistory?.totalQty = map["qty"]?.toInt() ?? 0;
    currentOrderController.orderHistory?.totalItem =
        currentOrderController.currentOrderList.length;
    currentOrderController.orderHistory?.amountTax = map["tax"] ?? 0;
    currentOrderController.orderHistory?.amountUntaxed = map["untaxed"] ?? 0;
    List<OrderLineID> orderLineIdList = [];

    final Database db = await DatabaseHelper().db;
    await OrderLineIdTable.deleteByOrderId(
            db: db, orderID: currentOrderController.orderHistory?.id ?? 0)
        .then((deletedValue) async {
      double totalTax = 0;
      for (var data in currentOrderController.currentOrderList) {
        if ((data.onhandQuantity ?? 0) <= 0) {
          CommonUtils.showSnackBar(
              context: context,
              message: '${data.productName} is something wrong!');
        }
        double priceSubtotal = (((data.onhandQuantity?.toDouble() ?? 0) *
                ((data.priceListItem?.fixedPrice ?? 0) -
                    (CommonUtils.getPercentAmountTaxOnProduct(data) > 0
                        ? ((data.priceListItem?.fixedPrice ?? 0) *
                            CommonUtils.getPercentAmountTaxOnProduct(data))
                        : 0))) -
            (((double.tryParse(data.onhandQuantity?.toString() ?? "0") ?? 0) *
                    (double.tryParse(
                            data.priceListItem?.fixedPrice?.toString() ??
                                "0") ??
                        0)) *
                ((data.discount ?? 0) / 100)));

        double priceSubtotalIncl = (((data.onhandQuantity?.toDouble() ?? 0) *
                (data.priceListItem?.fixedPrice ?? 0).toDouble()) -
            (((double.tryParse(data.onhandQuantity?.toString() ?? "0") ?? 0) *
                    (double.tryParse(
                            data.priceListItem?.fixedPrice?.toString() ??
                                "0") ??
                        0)) *
                ((data.discount ?? 0) / 100)));

        OrderLineID orderLineID = OrderLineID(
          orderId: currentOrderController.orderHistory?.id ?? 0,
          productId: data.productVariantIds ?? 0,
          qty: data.onhandQuantity?.toDouble() != 0
              ? ((currentOrderController.isRefund ? -1 : 1) *
                  (data.onhandQuantity?.toDouble() ?? 0))
              : 0,
          priceUnit: (data.priceListItem?.fixedPrice ?? 0).toDouble().abs(),
          priceSubtotal: priceSubtotal,
          priceSubtotalIncl: priceSubtotalIncl,
          fullProductName:
              '${data.barcode != null ? '[${data.barcode}] ' : ''}${data.productName}',
          createDate: orderDate.toString(),
          createUid:
              context.read<LoginUserController>().loginUser?.userData?.id ?? 0,
          discount: data.discount ?? 0,
          shDiscountCode: data.shDiscountCode,
          shDiscountReason: data.shDiscountReason,
          parentPromotionId: data.parentPromotionId,
          isPromoItem: data.isPromoItem,
          onOrderPromo: data.onOrderPromo,
          referenceOrderlineId:
              currentOrderController.isRefund == true ? data.lineId : null,
          refundedOrderLineId: currentOrderController.isRefund == true
              ? data.refundedOrderLineId
              : null,
          odooOrderLineId: currentOrderController.isRefund == true
              ? data.odooOrderLineId
              : null,
        );
        // todo: check and set refund_orderLineId
        orderLineIdList.add(orderLineID);
        totalTax = (data.onhandQuantity?.toDouble() ?? 0) *
            (CommonUtils.getPercentAmountTaxOnProduct(data) > 0
                ? ((data.priceListItem?.fixedPrice ?? 0) *
                    CommonUtils.getPercentAmountTaxOnProduct(data))
                : 0);
      }
      currentOrderController.orderHistory?.amountTax = totalTax;
      currentOrderController.orderHistory?.amountUntaxed =
          ((currentOrderController.orderHistory?.amountTotal ?? 0) - totalTax);
      if (currentOrderController.orderHistory == null) {
        CommonUtils.showSnackBar(
            context: context,
            message: "Creating/Updating order : something was wrong!");
        return;
      }
      await OrderHistoryTable.insertOrUpdate(
              db, currentOrderController.orderHistory!)
          .then((value) async {
        if (value <= 0) {
          CommonUtils.showSnackBar(
              context: context,
              message: "Creating/Updating order : something was wrong!");
          return;
        }
        await insertOrderLines(db, orderLineIdList).then((lineValue) async {
          await OrderLineIdTable.getOrderLinesByOrderId(
                  currentOrderController.orderHistory?.id ?? 0)
              .then((lineIds) {
            currentOrderController.orderHistory?.lineIds = lineIds;

            PendingOrderTable.insertOrUpdatePendingOrderWithDB(
                db: db, value: jsonEncode(currentOrderController.orderHistory));

            PendingOrderTable.insertOrUpdateCurrentOrderListWithDB(
                db: db,
                productList:
                    jsonEncode(currentOrderController.currentOrderList));
            if (isNavigate == true) {
              Navigator.pushNamed(context, OrderPaymentScreen.routeName);
            }
          });
        });
      });
    });
  }

  static Future<void> insertOrderLines(
    final Database db,
    List<OrderLineID> orderLineIdList,
  ) async {
    for (var data in orderLineIdList) {
      await OrderLineIdTable.insertOrUpdate(db: db, orderLineID: data);
    }
  }

  static DateTime getDateTimeNow() {
    return DateTime.now().toUtc();
  }
}
