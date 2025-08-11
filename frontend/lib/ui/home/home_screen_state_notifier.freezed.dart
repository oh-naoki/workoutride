// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_screen_state_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HomeScreenUiState {
  List<WorkoutSummary> get workoutSummaries =>
      throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isConnectingBle => throw _privateConstructorUsedError;
  bool get isBleConnected => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  String? get bleErrorMessage => throw _privateConstructorUsedError;

  /// Create a copy of HomeScreenUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HomeScreenUiStateCopyWith<HomeScreenUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeScreenUiStateCopyWith<$Res> {
  factory $HomeScreenUiStateCopyWith(
          HomeScreenUiState value, $Res Function(HomeScreenUiState) then) =
      _$HomeScreenUiStateCopyWithImpl<$Res, HomeScreenUiState>;
  @useResult
  $Res call(
      {List<WorkoutSummary> workoutSummaries,
      bool isLoading,
      bool isConnectingBle,
      bool isBleConnected,
      String? errorMessage,
      String? bleErrorMessage});
}

/// @nodoc
class _$HomeScreenUiStateCopyWithImpl<$Res, $Val extends HomeScreenUiState>
    implements $HomeScreenUiStateCopyWith<$Res> {
  _$HomeScreenUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomeScreenUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workoutSummaries = null,
    Object? isLoading = null,
    Object? isConnectingBle = null,
    Object? isBleConnected = null,
    Object? errorMessage = freezed,
    Object? bleErrorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      workoutSummaries: null == workoutSummaries
          ? _value.workoutSummaries
          : workoutSummaries // ignore: cast_nullable_to_non_nullable
              as List<WorkoutSummary>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isConnectingBle: null == isConnectingBle
          ? _value.isConnectingBle
          : isConnectingBle // ignore: cast_nullable_to_non_nullable
              as bool,
      isBleConnected: null == isBleConnected
          ? _value.isBleConnected
          : isBleConnected // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      bleErrorMessage: freezed == bleErrorMessage
          ? _value.bleErrorMessage
          : bleErrorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HomeScreenUiStateImplCopyWith<$Res>
    implements $HomeScreenUiStateCopyWith<$Res> {
  factory _$$HomeScreenUiStateImplCopyWith(_$HomeScreenUiStateImpl value,
          $Res Function(_$HomeScreenUiStateImpl) then) =
      __$$HomeScreenUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<WorkoutSummary> workoutSummaries,
      bool isLoading,
      bool isConnectingBle,
      bool isBleConnected,
      String? errorMessage,
      String? bleErrorMessage});
}

/// @nodoc
class __$$HomeScreenUiStateImplCopyWithImpl<$Res>
    extends _$HomeScreenUiStateCopyWithImpl<$Res, _$HomeScreenUiStateImpl>
    implements _$$HomeScreenUiStateImplCopyWith<$Res> {
  __$$HomeScreenUiStateImplCopyWithImpl(_$HomeScreenUiStateImpl _value,
      $Res Function(_$HomeScreenUiStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of HomeScreenUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workoutSummaries = null,
    Object? isLoading = null,
    Object? isConnectingBle = null,
    Object? isBleConnected = null,
    Object? errorMessage = freezed,
    Object? bleErrorMessage = freezed,
  }) {
    return _then(_$HomeScreenUiStateImpl(
      workoutSummaries: null == workoutSummaries
          ? _value._workoutSummaries
          : workoutSummaries // ignore: cast_nullable_to_non_nullable
              as List<WorkoutSummary>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isConnectingBle: null == isConnectingBle
          ? _value.isConnectingBle
          : isConnectingBle // ignore: cast_nullable_to_non_nullable
              as bool,
      isBleConnected: null == isBleConnected
          ? _value.isBleConnected
          : isBleConnected // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      bleErrorMessage: freezed == bleErrorMessage
          ? _value.bleErrorMessage
          : bleErrorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$HomeScreenUiStateImpl
    with DiagnosticableTreeMixin
    implements _HomeScreenUiState {
  const _$HomeScreenUiStateImpl(
      {final List<WorkoutSummary> workoutSummaries = const [],
      this.isLoading = false,
      this.isConnectingBle = false,
      this.isBleConnected = false,
      this.errorMessage,
      this.bleErrorMessage})
      : _workoutSummaries = workoutSummaries;

  final List<WorkoutSummary> _workoutSummaries;
  @override
  @JsonKey()
  List<WorkoutSummary> get workoutSummaries {
    if (_workoutSummaries is EqualUnmodifiableListView)
      return _workoutSummaries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_workoutSummaries);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isConnectingBle;
  @override
  @JsonKey()
  final bool isBleConnected;
  @override
  final String? errorMessage;
  @override
  final String? bleErrorMessage;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'HomeScreenUiState(workoutSummaries: $workoutSummaries, isLoading: $isLoading, isConnectingBle: $isConnectingBle, isBleConnected: $isBleConnected, errorMessage: $errorMessage, bleErrorMessage: $bleErrorMessage)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'HomeScreenUiState'))
      ..add(DiagnosticsProperty('workoutSummaries', workoutSummaries))
      ..add(DiagnosticsProperty('isLoading', isLoading))
      ..add(DiagnosticsProperty('isConnectingBle', isConnectingBle))
      ..add(DiagnosticsProperty('isBleConnected', isBleConnected))
      ..add(DiagnosticsProperty('errorMessage', errorMessage))
      ..add(DiagnosticsProperty('bleErrorMessage', bleErrorMessage));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeScreenUiStateImpl &&
            const DeepCollectionEquality()
                .equals(other._workoutSummaries, _workoutSummaries) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isConnectingBle, isConnectingBle) ||
                other.isConnectingBle == isConnectingBle) &&
            (identical(other.isBleConnected, isBleConnected) ||
                other.isBleConnected == isBleConnected) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.bleErrorMessage, bleErrorMessage) ||
                other.bleErrorMessage == bleErrorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_workoutSummaries),
      isLoading,
      isConnectingBle,
      isBleConnected,
      errorMessage,
      bleErrorMessage);

  /// Create a copy of HomeScreenUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeScreenUiStateImplCopyWith<_$HomeScreenUiStateImpl> get copyWith =>
      __$$HomeScreenUiStateImplCopyWithImpl<_$HomeScreenUiStateImpl>(
          this, _$identity);
}

abstract class _HomeScreenUiState implements HomeScreenUiState {
  const factory _HomeScreenUiState(
      {final List<WorkoutSummary> workoutSummaries,
      final bool isLoading,
      final bool isConnectingBle,
      final bool isBleConnected,
      final String? errorMessage,
      final String? bleErrorMessage}) = _$HomeScreenUiStateImpl;

  @override
  List<WorkoutSummary> get workoutSummaries;
  @override
  bool get isLoading;
  @override
  bool get isConnectingBle;
  @override
  bool get isBleConnected;
  @override
  String? get errorMessage;
  @override
  String? get bleErrorMessage;

  /// Create a copy of HomeScreenUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomeScreenUiStateImplCopyWith<_$HomeScreenUiStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
