import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workoutride/di/providers.dart';
import 'package:workoutride/domain/model/user_profile.dart';

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
      final useCase = ref.read(getUserProfileUseCaseProvider);
      final profile = await useCase();
      
      state = state.copyWith(
        isLoading: false,
        currentWeight: profile?.weight,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load user profile',
      );
    }
  }

  Future<void> updateWeight(double weight) async {
    state = state.copyWith(isLoading: true);
    
    try {
      final useCase = ref.read(saveUserWeightUseCaseProvider);
      await useCase(weight);
      
      state = state.copyWith(
        isLoading: false,
        currentWeight: weight,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to save weight',
      );
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}