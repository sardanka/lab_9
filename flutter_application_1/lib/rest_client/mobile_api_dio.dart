import 'package:dio/dio.dart';

import 'mobile_api.dart';

class MobileApiDio {
  late final Dio dio;
  late final MobileApi api;

  MobileApiDio() {
    dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        contentType: 'application/json',
      ),
    );

    api = MobileApi(dio);
  }
}