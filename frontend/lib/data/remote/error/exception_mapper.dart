import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:workoutride/domain/model/error/app_exception.dart';

/// DioExceptionなどの外部例外を[AppException]へ分類する。
/// リポジトリ実装からは直接呼ばず、[guardApiCall]経由で使う。
AppException mapToAppException(Object error) {
  if (error is AppException) return error;

  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const AppException.network();
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401) return const AppException.unauthorized();
        if (statusCode != null && statusCode >= 500) {
          return AppException.server(statusCode);
        }
        return AppException.unknown(error.message ?? error.toString());
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return const AppException.network();
    }
  }

  if (error is SocketException) return const AppException.network();

  // google_sign_in等プラットフォームプラグインは通信断をPlatformExceptionで返すことがある。
  if (error is PlatformException) {
    final code = error.code.toLowerCase();
    final message = (error.message ?? '').toLowerCase();
    if (code.contains('network') ||
        message.contains('network') ||
        message.contains('socket')) {
      return const AppException.network();
    }
  }

  return AppException.unknown(error.toString());
}

/// リポジトリ実装の各メソッドをこれで包み、例外を[AppException]へ変換して送出する。
Future<T> guardApiCall<T>(Future<T> Function() call) async {
  try {
    return await call();
  } catch (e) {
    throw mapToAppException(e);
  }
}
