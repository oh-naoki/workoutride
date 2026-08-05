import 'package:dio/dio.dart';
import 'package:workoutride/domain/model/error/app_exception.dart';

/// DioExceptionなどの外部例外を[AppException]へ分類する。
/// リポジトリ実装のcatchブロックから呼び出す。
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

  return AppException.unknown(error.toString());
}
