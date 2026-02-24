import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:workoutride/domain/model/auth/user.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.unauthenticated() = Unauthenticated;
  const factory AuthState.authenticated({
    required User user,
  }) = Authenticated;
  const factory AuthState.loading() = Loading;
}
