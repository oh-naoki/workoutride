import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workoutride/di/providers.dart';
import 'package:workoutride/domain/model/error/app_exception.dart';

part 'settings_screen_state_notifier.freezed.dart';
part 'settings_screen_state_notifier.g.dart';

@freezed
class SettingsScreenUiState with _$SettingsScreenUiState {
  const factory SettingsScreenUiState({
    @Default(false) bool isLoading,
    @Default(null) double? currentWeight,
    @Default(null) String? errorMessage,
  }) = _SettingsScreenUiState;
}

@riverpod
class SettingsScreenStateNotifier extends _$SettingsScreenStateNotifier {
  @override
  SettingsScreenUiState build() {
    _loadCurrentWeight();
    return const SettingsScreenUiState(isLoading: true);
  }

  Future<void> _loadCurrentWeight() async {
    try {
      final profile =
          await ref.read(userProfileRepositoryProvider).getUserProfile();

      state = state.copyWith(
        isLoading: false,
        currentWeight: profile?.weight,
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

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
