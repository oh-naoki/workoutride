import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workoutride/di/providers.dart';
import 'package:workoutride/domain/model/error/app_exception.dart';
import 'package:workoutride/domain/model/user_profile.dart';

part 'settings_screen_state_notifier.freezed.dart';
part 'settings_screen_state_notifier.g.dart';

@freezed
class SettingsScreenUiState with _$SettingsScreenUiState {
  const factory SettingsScreenUiState({
    @Default(false) bool isLoading,
    @Default(null) double? currentWeight,
    // null は「FTP 未設定」を意味する。
    @Default(null) int? currentFtp,
    @Default(null) String? errorMessage,
  }) = _SettingsScreenUiState;
}

@riverpod
class SettingsScreenStateNotifier extends _$SettingsScreenStateNotifier {
  @override
  SettingsScreenUiState build() {
    _loadProfile();
    return const SettingsScreenUiState(isLoading: true);
  }

  /// 体重と FTP をまとめて読む。以前は FTP だけ View の FutureBuilder が
  /// 取得しており、再ビルドのたびに API を叩き直すうえ更新後も古い値が
  /// 残っていた。取得経路をここへ一本化している。
  Future<void> _loadProfile() async {
    try {
      final repository = ref.read(userProfileRepositoryProvider);
      final results = await Future.wait([
        repository.getUserProfile(),
        repository.getFtp(),
      ]);

      state = state.copyWith(
        isLoading: false,
        currentWeight: (results[0] as UserProfile?)?.weight,
        currentFtp: results[1] as int?,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: AppException.messageFor(e),
      );
    }
  }

  Future<void> updateWeight(double weight) async {
    state = state.copyWith(isLoading: true);

    try {
      await ref.read(userProfileRepositoryProvider).saveWeight(weight);

      state = state.copyWith(
        isLoading: false,
        currentWeight: weight,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: AppException.messageFor(e),
      );
    }
  }

  Future<void> updateFtp(int ftp) async {
    state = state.copyWith(isLoading: true);

    try {
      await ref.read(userProfileRepositoryProvider).saveFtp(ftp);

      state = state.copyWith(
        isLoading: false,
        currentFtp: ftp,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: AppException.messageFor(e),
      );
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
