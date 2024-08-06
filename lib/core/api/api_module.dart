import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:contact_number_demo/core/api/api_end_points.dart';
import 'package:contact_number_demo/core/api/interceptor/custom_interceptors.dart';
import 'package:contact_number_demo/core/api/interceptor/internet_interceptor.dart';
import 'package:contact_number_demo/core/locator/locator.dart';
import 'package:contact_number_demo/data/remote/auth_api.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiModule {
  Future<void> provides() async {
    final dio = await setup();

    /// register [Dio] to [GetIt]
    locator.registerSingleton(dio);

    /// register APIs implementations
    locator.registerSingleton(AuthApi(dio));
  }

  static FutureOr<Dio> setup() async {
    final Dio dio = Dio()
      ..options = BaseOptions(
        baseUrl: APIEndPoints.baseUrl,
        validateStatus: (status) {
          if (status == null) return true;
          if (status == 401 || status >= 500) return false;
          return true;
        },
        responseType: ResponseType.plain,
        headers: {
          'content-type': 'text/plain',
          'contentType': 'text/plain',
          'responseType': 'text/plain',
        },
      );

    /// Disable logging into production
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestBody: true,
          responseBody: false,
        ),
      );
    }
    dio.interceptors.add(CustomInterceptors());

    /// Disable logging into production
    if (!kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          request: false,
          responseHeader: true,
        ),
      );
    }
    dio.interceptors.add(InternetInterceptors());

    return dio;
  }
}
