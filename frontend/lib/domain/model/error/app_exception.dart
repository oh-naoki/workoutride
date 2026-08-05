import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_exception.freezed.dart';

/// アプリ全体で使う分類済み例外。DioExceptionなどの外部例外は
/// data層のマッパー（[mapToAppException]）でこの型に変換してから
/// domain/uiへ伝播させる。
@freezed
class AppException with _$AppException implements Exception {
  const AppException._();

  const factory AppException.network() = NetworkException;
  const factory AppException.unauthorized() = UnauthorizedException;
  const factory AppException.server(int? statusCode) = ServerException;
  const factory AppException.unknown(String message) = UnknownException;

  /// UIにそのまま表示できる日本語メッセージ。
  String get userMessage => when(
        network: () => 'ネットワークに接続できませんでした。通信状況を確認してください。',
        unauthorized: () => 'ログインの有効期限が切れました。再度ログインしてください。',
        server: (_) => 'サーバーでエラーが発生しました。しばらくしてから再度お試しください。',
        unknown: (message) => 'エラーが発生しました。しばらくしてから再度お試しください。',
      );

  /// UI層はdata層のマッパーに依存できないため、この静的メソッド経由で
  /// 任意の例外からユーザー向けメッセージを取得する。
  /// [error]が[AppException]でなければ（data層でのマッピング漏れ）汎用メッセージを返す。
  static String messageFor(Object error) {
    if (error is AppException) return error.userMessage;
    return 'エラーが発生しました。しばらくしてから再度お試しください。';
  }
}
