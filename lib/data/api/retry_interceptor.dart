import 'dart:math';

import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.baseDelay = const Duration(seconds: 1),
  });

  final Dio dio;
  final int maxRetries;
  final Duration baseDelay;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    final attempt = _attemptFromExtra(err.requestOptions);

    if (attempt >= maxRetries || !_shouldRetry(statusCode)) {
      return handler.next(err);
    }

    final delay = _retryDelay(statusCode, err.response, attempt);
    await Future<void>.delayed(delay);

    final options = err.requestOptions;
    options.extra = {...options.extra, '_retryAttempt': attempt + 1};

    try {
      final response = await dio.fetch(options);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  int _attemptFromExtra(RequestOptions options) {
    return (options.extra['_retryAttempt'] as int?) ?? 0;
  }

  bool _shouldRetry(int? statusCode) {
    if (statusCode == null) return false;
    return statusCode == 429 || statusCode == 503;
  }

  Duration _retryDelay(
    int? statusCode,
    Response<dynamic>? response,
    int attempt,
  ) {
    if (statusCode == 429) {
      final retryAfter = response?.headers.value('retry-after');
      if (retryAfter != null) {
        final seconds = int.tryParse(retryAfter);
        if (seconds != null) return Duration(seconds: seconds);
      }
    }
    return baseDelay * pow(2, attempt);
  }
}
