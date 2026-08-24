import 'dart:io';

import 'package:dio/dio.dart';

String friendlyError(Object error) {
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Check your internet and try again.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Check your network and try again.';
      case DioExceptionType.badResponse:
        return _fromStatusCode(error.response?.statusCode);
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
  if (error is SocketException) {
    return 'No internet connection. Check your network and try again.';
  }
  return 'Something went wrong. Please try again.';
}

String _fromStatusCode(int? code) {
  if (code == null) return 'Something went wrong. Please try again.';
  if (code == 401) return 'Authentication failed. Check your API key.';
  if (code == 404) return 'Content not found.';
  if (code == 429) return 'Too many requests. Please wait a moment.';
  if (code >= 500) return 'TMDB is having issues. Try again later.';
  return 'Request failed (HTTP $code). Please try again.';
}
