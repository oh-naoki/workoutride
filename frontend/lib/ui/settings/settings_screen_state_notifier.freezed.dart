// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_screen_state_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SettingsScreenUiState {
  bool get isLoading => throw _privateConstructorUsedError;
  double? get currentWeight => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of SettingsScreenUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SettingsScreenUiStateCopyWith<SettingsScreenUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsScreenUiStateCopyWith<$Res> {
  factory $SettingsScreenUiStateCopyWith(SettingsScreenUiState value,
          $Res Function(SettingsScreenUiState) then) =
      _$SettingsScreenUiStateCopyWithImpl<$Res, SettingsScreenUiState>;
  @useResult
  $Res call({bool isLoading, double? currentWeight, String? errorMessage});
}

/// @nodoc
class _$SettingsScreenUiStateCopyWithImpl<$Res,
        $Val extends SettingsScreenUiState>
    implements $SettingsScreenUiStateCopyWith<$Res> {
  _$SettingsScreenUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SettingsScreenUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? currentWeight = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      currentWeight: freezed == currentWeight
          ? _value.currentWeight
          : currentWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SettingsScreenUiStateImplCopyWith<$Res>
    implements $SettingsScreenUiStateCopyWith<$Res> {
  factory _$$SettingsScreenUiStateImplCopyWith(
          _$SettingsScreenUiStateImpl value,
          $Res Function(_$SettingsScreenUiStateImpl) then) =
      __$$SettingsScreenUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading, double? currentWeight, String? errorMessage});
}

/// @nodoc
class __$$SettingsScreenUiStateImplCopyWithImpl<$Res>
    extends _$SettingsScreenUiStateCopyWithImpl<$Res,
        _$SettingsScreenUiStateImpl>
    implements _$$SettingsScreenUiStateImplCopyWith<$Res> {
  __$$SettingsScreenUiStateImplCopyWithImpl(_$SettingsScreenUiStateImpl _value,
      $Res Function(_$SettingsScreenUiStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of SettingsScreenUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? currentWeight = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_$SettingsScreenUiStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      currentWeight: freezed == currentWeight
          ? _value.currentWeight
          : currentWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$SettingsScreenUiStateImpl implements _SettingsScreenUiState {
  const _$SettingsScreenUiStateImpl(
      {this.isLoading = false,
      this.currentWeight = null,
      this.errorMessage = null});

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final double? currentWeight;
  @override
  @JsonKey()
  final String? errorMessage;

  @override
  String toString() {
    return 'SettingsScreenUiState(isLoading: $isLoading, currentWeight: $currentWeight, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingsScreenUiStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.currentWeight, currentWeight) ||
                other.currentWeight == currentWeight) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isLoading, currentWeight, errorMessage);

  /// Create a copy of SettingsScreenUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SettingsScreenUiStateImplCopyWith<_$SettingsScreenUiStateImpl>
      get copyWith => __$$SettingsScreenUiStateImplCopyWithImpl<
          _$SettingsScreenUiStateImpl>(this, _$identity);
}

abstract class _SettingsScreenUiState implements SettingsScreenUiState {
  const factory _SettingsScreenUiState(
      {final bool isLoading,
      final double? currentWeight,
      final String? errorMessage}) = _$SettingsScreenUiStateImpl;

  @override
  bool get isLoading;
  @override
  double? get currentWeight;
  @override
  String? get errorMessage;

  /// Create a copy of SettingsScreenUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SettingsScreenUiStateImplCopyWith<_$SettingsScreenUiStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
