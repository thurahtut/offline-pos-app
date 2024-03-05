import 'dart:math';

import 'package:offline_pos/components/export_files.dart';
import 'package:offline_pos/database/table/amount_tax_table.dart';
import 'package:offline_pos/database/table/pos_category_table.dart';
import 'package:offline_pos/database/table/product_packaging_table.dart';

class MorningsyncController with ChangeNotifier {
  final int allTask = 7;

  int _currentReachTask = 1;
  int get currentReachTask => _currentReachTask;
  set currentReachTask(int currentReachTask) {
    if (_currentReachTask == currentReachTask) return;
    _currentReachTask = currentReachTask;
    notifyListeners();
  }

  String _currentTaskTitle = "";
  String get currentTaskTitle => _currentTaskTitle;
  set currentTaskTitle(String currentTaskTitle) {
    if (_currentTaskTitle == currentTaskTitle) return;
    _currentTaskTitle = currentTaskTitle;
    notifyListeners();
  }

  double? _percentage = 0;
  double? get percentage => _percentage;
  set percentage(double? percentage) {
    if (_percentage == percentage) return;
    _percentage = percentage;
    notifyListeners();
  }

  Map<String, double?> _processingPercentage = {};
  Map<String, double?> get processingPercentage => _processingPercentage;
  void updateProcessingPercentage(String name, double? percentage) {
    _processingPercentage[name] = percentage;
    notifyListeners();
  }

  notify() {
    notifyListeners();
  }

  List<String> _doneActionList = [];
  List<String> get doneActionList => _doneActionList;
  set doneActionList(List<String> doneActionList) {
    _doneActionList = doneActionList;
    notifyListeners();
  }

  resetMorningsyncController() {
    _currentReachTask = 1;
    _currentTaskTitle = "";
    _percentage = 0;
    _doneActionList.clear();
    _processingPercentage = {};
    notifyListeners();
  }

  void getAllProductFromApi(
      String? lastSyncDate, int? locationId, Function()? callback) {
    currentTaskTitle = "Product List Sync....";
    currentReachTask = 1;
    Api.getAllProduct(
      lastSyncDate: lastSyncDate,
      locationId: locationId,
      onReceiveProgress: (sent, total) {
        double value = min(((sent / total) * 100), 100);
        percentage = value > 100 ? null : value;
        updateProcessingPercentage(DataSync.product.name, percentage);
      },
    ).then((response) {
      if (response != null &&
          response.statusCode == 200 &&
          response.data != null) {
        if (response.data is List) {
          ProductTable.insertOrUpdate(response.data)
              .then((value) => callback?.call());
        }
      }
    });
  }

  void getAllCustomerFromApi(String? lastSyncDate, Function()? callback) {
    currentTaskTitle = "Customer List Sync....";
    currentReachTask = 2;
    Api.getAllCustomer(
      lastSyncDate: lastSyncDate,
      onReceiveProgress: (sent, total) {
        double value = min(((sent / total) * 100), 100);
        percentage = value > 100 ? null : value;
        updateProcessingPercentage(DataSync.customer.name, percentage);
      },
    ).then((response) {
      if (response != null &&
          response.statusCode == 200 &&
          response.data != null) {
        if (response.data is List) {
          CustomerTable.insertOrUpdate(response.data)
              .then((value) => callback?.call());
        }
      }
    });
  }

  void getAllPriceListItemFromApi(
    String? lastSyncDate,
    int priceListId,
    Function()? callback,
  ) {
    currentTaskTitle = "Price Sync....";
    currentReachTask = 3;
    Api.getPriceListItemByID(
      lastSyncDate: lastSyncDate,
      priceListId: priceListId,
      onReceiveProgress: (sent, total) {
        double value = min(((sent / total) * 100), 100);
        percentage = value > 100 ? null : value;
        updateProcessingPercentage(DataSync.price.name, percentage);
      },
    ).then((response) {
      if (response != null &&
          response.statusCode == 200 &&
          response.data != null) {
        if (response.data is List) {
          PriceListItemTable.insertOrUpdate(response.data)
              .then((value) => callback?.call());
        }
      }
    });
  }

  void getAllPaymentMethodListItemFromApi(
      String? paymentMethodListStr, Function()? callback) {
    currentTaskTitle = "Payment Method Sync....";
    currentReachTask = 4;
    Api.getPaymentMethodListItemByID(
      paymentMethodListStr: paymentMethodListStr,
      onReceiveProgress: (sent, total) {
        double value = min(((sent / total) * 100), 100);
        percentage = value > 100 ? null : value;
        updateProcessingPercentage(DataSync.paymentMethod.name, percentage);
      },
    ).then((response) {
      if (response != null &&
          response.statusCode == 200 &&
          response.data != null) {
        if (response.data is List) {
          PaymentMethodTable.insertOrUpdate(response.data)
              .then((value) => callback?.call());
        }
      }
    });
  }

  void getAllPosCategory(Function()? callback) {
    currentTaskTitle = "Category List Sync....";
    currentReachTask = 5;
    Api.getPosCategory(
      onReceiveProgress: (sent, total) {
        double value = min(((sent / total) * 100), 100);
        percentage = value > 100 ? null : value;
        updateProcessingPercentage(DataSync.posCategory.name, percentage);
      },
    ).then((response) {
      if (response != null &&
          response.statusCode == 200 &&
          response.data != null) {
        if (response.data is List) {
          POSCategoryTable.insertOrUpdateWithList(response.data)
              .then((value) => callback?.call());
        }
      }
    });
  }

  void getAllAmountTax(Function()? callback) {
    currentTaskTitle = "Tax List Sync....";
    currentReachTask = 6;
    Api.getAllAmountTax(
      onReceiveProgress: (sent, total) {
        double value = min(((sent / total) * 100), 100);
        percentage = value > 100 ? null : value;
        updateProcessingPercentage(DataSync.amountTax.name, percentage);
      },
    ).then((response) {
      if (response != null &&
          response.statusCode == 200 &&
          response.data != null) {
        if (response.data is List) {
          AmountTaxTable.insertOrUpdate(response.data)
              .then((value) => callback?.call());
        }
      }
    });
  }

  void getAllProductPackaging(String? lastSyncDate, Function()? callback) {
    currentTaskTitle = "Product Packaging List Sync....";
    currentReachTask = 7;
    Api.getProductPackaging(
      lastSyncDate: lastSyncDate,
      onReceiveProgress: (sent, total) {
        double value = min(((sent / total) * 100), 100);
        percentage = value > 100 ? null : value;
        updateProcessingPercentage(DataSync.productPackaging.name, percentage);
      },
    ).then((response) {
      if (response != null &&
          response.statusCode == 200 &&
          response.data != null) {
        if (response.data is List) {
          ProductPackagingTable.insertOrUpdate(response.data)
              .then((value) => callback?.call());
        }
      }
    });
  }
}
