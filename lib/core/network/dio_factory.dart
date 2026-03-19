import 'package:dio/dio.dart';

import '../config/app_environment.dart';

class DioFactory {
  static Dio create(AppEnvironment environment) {
    final BaseOptions options = BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      headers: <String, String>{
        'x-vibemarket-client': 'flutter',
        'x-vibemarket-flavor': environment.appFlavor,
      },
    );

    final Dio dio = Dio(options);
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions request, RequestInterceptorHandler handler) {
          request.headers['x-vibemarket-mode'] = environment.isDemoMode
              ? 'demo'
              : 'live';
          handler.next(request);
        },
      ),
    );
    return dio;
  }
}
