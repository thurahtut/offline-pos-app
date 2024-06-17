// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:offline_pos/components/export_files.dart';
import 'package:offline_pos/model/cash_register.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

class ApiServiceConfig {
  static const int apiVersion = 1;
  static const int loadPagePerCount = 40;
  static const Duration sendTimeout = Duration(milliseconds: 60000);
  static const Duration receiveTimeout = Duration(milliseconds: 60000);

  static const int connectionTimeout = 15000;
  static get apiServiceBaseOptions => BaseOptions(
          baseUrl: Api.baseUrl,
          connectTimeout: sendTimeout,
          receiveTimeout: receiveTimeout,
          headers: {
            "Cache-Control": "no-cache",
            "Accept": "*/*",
          });

  static DioExceptionType dioErrorHandler(
    DioException dioException, {
    String? errorSpecificmessage,
    Duration? errorSpecificmessageDuration,
  }) {
    if (dioException.type == DioExceptionType.connectionTimeout) {
      CommonUtils.showSnackBar(message: "Request Timeout");
      return DioExceptionType.connectionTimeout;
    }

    if (dioException.type == DioExceptionType.receiveTimeout) {
      CommonUtils.showSnackBar(message: "Receive Timeout");
      return DioExceptionType.receiveTimeout;
    }

    if (dioException.type == DioExceptionType.sendTimeout) {
      CommonUtils.showSnackBar(message: "Send Timeout");
      return DioExceptionType.sendTimeout;
    }

    if (dioException.response != null) {
      if (errorSpecificmessage != null) {
        CommonUtils.showSnackBar(message: errorSpecificmessage);
      } else {
        log(
          dioException.response?.statusCode.toString() ?? "Unknown Status Code",
        );

        if (dioException.response?.statusCode == 401) {
          return DioExceptionType.badCertificate;
        }

        CommonUtils.showSnackBar(
          message: dioException.response?.data != null &&
                  dioException.response!.data is String &&
                  dioException.response!.data.toString().trim().isNotEmpty
              ? dioException.response!.data.toString()
              : (dioException.response?.statusMessage ?? 'Something was wrong'),
        );
      }
    } else {
      CommonUtils.showSnackBar(
        message:
            'Something was wrong. Please check your internet connection and try again.',
      );
    }

    return DioExceptionType.unknown;
  }
}

extension OnApiEndPoint on String {
  String onApiEndPoint() {
    return "${Api.baseUrl}/api$this";
  }
}

// extension OnEndPoint on String {
//   String onEndPoint() {
//     return Constants.baseUrl + this;
//   }
// }

extension OnEndPoint on String {
  String onEndPoint() => Api.currentAppUrl + this;
}

Dio dio = Dio(ApiServiceConfig.apiServiceBaseOptions);

enum Method {
  GET,
  POST,
  PUT,
  DELETE,
}

class Api {
  static const String apiType = "live";
  static const String baseUrl = "http://54.255.217.85:3000/api";

  // static const String apiType = "uat";
  // static const String baseUrl ="http://103.105.175.186:3000/api";

//--------------------------------------------------------------------------------------
  static const String version1 = "/v1";
  static const String currentVersion = version1;
  static const String currentAppUrl = baseUrl + currentVersion;
  static const int receiveTimeout = 60000;
  static const int connectionTimeout = 60000;

  static final TalkerDioLogger dioPreetyLoger = TalkerDioLogger(
    settings: const TalkerDioLoggerSettings(
      printRequestHeaders: true,
      // printResponseHeaders: true,
      // printResponseMessage: true,
      printResponseData: true,
    ),
  );

  static openConsoleLoging() {
    dio.interceptors.add(dioPreetyLoger);
  }

  static void resetDio() {
    dio.close(force: true);
    dio = Dio(ApiServiceConfig.apiServiceBaseOptions);
  }

  static debugingResponse({Response<dynamic>? response}) {
    if (response != null) {
      log("RESPONSE CODE : ${response.statusCode}");
      log("RESPONSE CODE MESSAGE : ${response.statusMessage}");
      log("RESPONSE DATA : ${response.data}");
    } else {
      log("UNKNOWN RESPONSE");
    }
  }

  //!---------------------------Request--------------------------------
  static Future<Response<dynamic>?> request({
    required String endpoint,
    String? method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    Function()? callback,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      var response = await dio.request(
        endpoint,
        options: options ??
            Options(
              method: method,
              contentType: "application/json",
              receiveTimeout: receiveTimeout,
              sendTimeout: sendTimeout,
            ),
        data: data,
        queryParameters: queryParameters,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
      );
      callback?.call();
      return response;
    } on DioException catch (dioException) {
      ApiServiceConfig.dioErrorHandler(dioException);
      // final error = ApiServiceConfig.dioErrorHandler(dioException);

      // if (error == DioExceptionType.badCertificate) {
      //   refreshToken().then((reponse) async {
      //     if (reponse != null && reponse.statusCode == 200) {
      //       if (dio.options.headers['Authorization']?.isNotEmpty) {
      //         String? accessToken = await Utils.getAccessToken();
      //         dio.options.headers['Authorization'] = 'Bearer $accessToken';
      //       }
      //       return await request(
      //         endpoint: endpoint,
      //         method: method,
      //         data: data,
      //         queryParameters: queryParameters,
      //         cancelToken: cancelToken,
      //         options: options,
      //         onSendProgress: onSendProgress,
      //         onReceiveProgress: onReceiveProgress,
      //       );
      //     } else {
      //       NavigationService.navigatorKey.currentContext
      //           ?.read<UserCredentialProvider>()
      //           .deleteCredential();
      //       NavigationService.navigatorKey.currentContext
      //           ?.goNamed(LoginScreen.routeName);
      //     }
      //   });
      // } else {}

      callback?.call();
      if (dioException.response?.data["error"]?.isNotEmpty ??
          dioException.response?.statusMessage?.isNotEmpty ??
          false) {
        CommonUtils.saveAPIErrorLogs(dioException.response?.data["error"] ??
            dioException.response!.statusMessage!);
      }
      return dioException.response;
    } catch (e) {
      callback?.call();
      CommonUtils.saveAPIErrorLogs(e.toString());
      return null;
    }
  }

  static Future<Response?> login({
    String? email,
    String? password,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
    };
    return request(
      endpoint: '/login'.onEndPoint(),
      method: Method.POST.name,
      data: jsonEncode({
        "email": email,
        "password": password,
      }),
    );
  }

  static Future<Response?> getAllProduct({
    int? locationId,
    String? lastSyncDate,
    void Function(int, int)? onReceiveProgress,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> map = {
      "location_id": locationId,
    };
    if (lastSyncDate != null) {
      map.putIfAbsent("last_sync_date", () => lastSyncDate);
    }
    return request(
      endpoint: '/products'.onEndPoint(),
      method: Method.GET.name,
      onReceiveProgress: onReceiveProgress,
      queryParameters: map,
      receiveTimeout: Duration(milliseconds: 900000),
      sendTimeout: Duration(milliseconds: 900000),
    );
  }

  static Future<Response?> getProductByID({
    String? productId,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
    };
    return request(
      endpoint: '/products/$productId'.onEndPoint(),
      method: Method.GET.name,
    );
  }

  static Future<Response?> getAllCustomer({
    String? lastSyncDate,
    void Function(int, int)? onReceiveProgress,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> map = {};
    if (lastSyncDate != null) {
      map.putIfAbsent("last_sync_date", () => lastSyncDate);
    }
    return request(
      endpoint: '/customers'.onEndPoint(),
      method: Method.GET.name,
      onReceiveProgress: onReceiveProgress,
      queryParameters: map,
      receiveTimeout: Duration(milliseconds: 900000),
      sendTimeout: Duration(milliseconds: 900000),
    );
  }

  static Future<Response?> getAllAmountTax({
    // String? lastSyncDate,
    void Function(int, int)? onReceiveProgress,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
    };
    // Map<String, dynamic> map = {};
    // if (lastSyncDate != null) {
    //   map.putIfAbsent("last_sync_date", () => lastSyncDate);
    // }
    return request(
      endpoint: '/accounttaxes'.onEndPoint(),
      method: Method.GET.name,
      onReceiveProgress: onReceiveProgress,
      receiveTimeout: Duration(milliseconds: 900000),
      sendTimeout: Duration(milliseconds: 900000),
    );
  }

  static Future<Response?> getPosConfigByID({
    int? inventoryId,
    void Function(int, int)? onReceiveProgress,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
    };
    return request(
      endpoint: '/posconfig/$inventoryId'.onEndPoint(),
      method: Method.GET.name,
      onReceiveProgress: onReceiveProgress,
    );
  }

  static Future<Response?> getPosSessionByID({
    int? configId,
    void Function(int, int)? onReceiveProgress,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
    };
    return request(
      endpoint: '/posconfig/session/$configId'.onEndPoint(),
      method: Method.GET.name,
      onReceiveProgress: onReceiveProgress,
    );
  }

  static Future<Response?> getPriceListItemByID({
    int? priceListId,
    String? lastSyncDate,
    void Function(int, int)? onReceiveProgress,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> map = {};
    if (lastSyncDate != null) {
      map.putIfAbsent("last_sync_date", () => lastSyncDate);
    }
    return request(
      endpoint: '/pricelist/items/$priceListId'.onEndPoint(),
      method: Method.GET.name,
      onReceiveProgress: onReceiveProgress,
      queryParameters: map,
      receiveTimeout: Duration(milliseconds: 1200000), //20 mins
      sendTimeout: Duration(milliseconds: 1200000),
    );
  }

  static Future<Response?> getPaymentMethodListItemByID({
    String? paymentMethodListStr,
    void Function(int, int)? onReceiveProgress,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
    };
    return request(
      endpoint: '/paymethod'.onEndPoint(),
      method: Method.GET.name,
      queryParameters: {
        "ids": paymentMethodListStr,
      },
      onReceiveProgress: onReceiveProgress,
    );
  }

  static Future<Response?> createSession({
    required CreateSession createSession,
    void Function(int, int)? onReceiveProgress,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
    };
    return request(
      endpoint: '/posconfig/session'.onEndPoint(),
      method: Method.POST.name,
      data: jsonEncode(createSession.toJson()),
      onReceiveProgress: onReceiveProgress,
    );
  }

  static Future<Response?> cashRegister({
    required CashRegister cashRegister,
    void Function(int, int)? onReceiveProgress,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
    };
    return request(
      endpoint: '/cashregister'.onEndPoint(),
      method: Method.POST.name,
      data: jsonEncode(cashRegister.toJson()),
      onReceiveProgress: onReceiveProgress,
    );
  }

  static Future<Response?> getPosCategory({
    void Function(int, int)? onReceiveProgress,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
    };
    return request(
      endpoint: '/pos-categ'.onEndPoint(),
      method: Method.GET.name,
      onReceiveProgress: onReceiveProgress,
    );
  }

  static Future<Response?> syncOrders({
    int? sessionId,
    required Map<String, dynamic> orderMap,
    void Function(int, int)? onReceiveProgress,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
    };
    return request(
      endpoint: '/order'.onEndPoint(),
      method: Method.POST.name,
      data: orderMap,
      onReceiveProgress: onReceiveProgress,
    );
  }

  static Future<Response?> closeSessionAndCloseCashRegister({
    int? sessionId,
    required CloseSession closeSession,
    void Function(int, int)? onReceiveProgress,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
    };
    return request(
      endpoint: '/posconfig/session/$sessionId'.onEndPoint(),
      method: Method.PUT.name,
      data: closeSession,
      onReceiveProgress: onReceiveProgress,
    );
  }

  static Future<Response?> getProductPackaging({
    String? lastSyncDate,
    void Function(int, int)? onReceiveProgress,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> map = {};
    if (lastSyncDate != null) {
      map.putIfAbsent("last_sync_date", () => lastSyncDate);
    }
    return request(
      endpoint: '/product/packagings'.onEndPoint(),
      method: Method.GET.name,
      onReceiveProgress: onReceiveProgress,
      queryParameters: map,
      receiveTimeout: Duration(milliseconds: 900000),
      sendTimeout: Duration(milliseconds: 900000),
    );
  }

  static Future<Response?> getCouponAndPromoByConfigId({
    required int configId,
    void Function(int, int)? onReceiveProgress,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
    };
    return request(
      endpoint: '/promotion/$configId'.onEndPoint(),
      method: Method.GET.name,
      onReceiveProgress: onReceiveProgress,
      receiveTimeout: Duration(milliseconds: 900000),
      sendTimeout: Duration(milliseconds: 900000),
    );
  }

  static Future<Response?> getPromotionRules({
    required int configId,
    void Function(int, int)? onReceiveProgress,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
    };
    return request(
      endpoint: '/promotion/$configId/rules'.onEndPoint(),
      method: Method.GET.name,
      onReceiveProgress: onReceiveProgress,
      receiveTimeout: Duration(milliseconds: 900000),
      sendTimeout: Duration(milliseconds: 900000),
    );
  }

  static Future<Response?> getDiscountList({
    void Function(int, int)? onReceiveProgress,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
    };
    return request(
      endpoint: '/discount'.onEndPoint(),
      method: Method.GET.name,
      onReceiveProgress: onReceiveProgress,
      receiveTimeout: Duration(milliseconds: 900000),
      sendTimeout: Duration(milliseconds: 900000),
    );
  }
}
