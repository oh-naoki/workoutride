// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_screen_state_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WorkoutScreenUiState {
  List<WorkoutSummary> get workoutSummaries =>
      throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of WorkoutScreenUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutScreenUiStateCopyWith<WorkoutScreenUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutScreenUiStateCopyWith<$Res> {
  factory $WorkoutScreenUiStateCopyWith(WorkoutScreenUiState value,
          $Res Function(WorkoutScreenUiState) then) =
      _$WorkoutScreenUiStateCopyWithImpl<$Res, WorkoutScreenUiState>;
  @useResult
  $Res call(
      {List<WorkoutSummary> workoutSummaries,
      bool isLoading,
      String? errorMessage});
}

/// @nodoc
class _$WorkoutScreenUiStateCopyWithImpl<$Res,
        $Val extends WorkoutScreenUiState>
    implements $WorkoutScreenUiStateCopyWith<$Res> {
  _$WorkoutScreenUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutScreenUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workoutSummaries = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
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
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkoutScreenUiStateImplCopyWith<$Res>
    implements $WorkoutScreenUiStateCopyWith<$Res> {
  factory _$$WorkoutScreenUiStateImplCopyWith(_$WorkoutScreenUiStateImpl value,
          $Res Function(_$WorkoutScreenUiStateImpl) then) =
      __$$WorkoutScreenUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<WorkoutSummary> workoutSummaries,
      bool isLoading,
      String? errorMessage});
}

/// @nodoc
class __$$WorkoutScreenUiStateImplCopyWithImpl<$Res>
    extends _$WorkoutScreenUiStateCopyWithImpl<$Res, _$WorkoutScreenUiStateImpl>
    implements _$$WorkoutScreenUiStateImplCopyWith<$Res> {
  __$$WorkoutScreenUiStateImplCopyWithImpl(_$WorkoutScreenUiStateImpl _value,
      $Res Function(_$WorkoutScreenUiStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkoutScreenUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workoutSummaries = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$WorkoutScreenUiStateImpl(
      workoutSummaries: null == workoutSummaries
          ? _value._workoutSummaries
          : workoutSummaries // ignore: cast_nullable_to_non_nullable
              as List<WorkoutSummary>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$WorkoutScreenUiStateImpl
    with DiagnosticableTreeMixin
    implements _WorkoutScreenUiState {
  const _$WorkoutScreenUiStateImpl(
      {final List<WorkoutSummary> workoutSummaries = const [],
      this.isLoading = false,
      this.errorMessage})
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
  final String? errorMessage;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'WorkoutScreenUiState(workoutSummaries: $workoutSummaries, isLoading: $isLoading, errorMessage: $errorMessage)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'WorkoutScreenUiState'))
      ..add(DiagnosticsProperty('workoutSummaries', workoutSummaries))
      ..add(DiagnosticsProperty('isLoading', isLoading))
      ..add(DiagnosticsProperty('errorMessage', errorMessage));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutScreenUiStateImpl &&
            const DeepCollectionEquality()
                .equals(other._workoutSummaries, _workoutSummaries) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_workoutSummaries),
      isLoading,
      errorMessage);

  /// Create a copy of WorkoutScreenUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutScreenUiStateImplCopyWith<_$WorkoutScreenUiStateImpl>
      get copyWith =>
          __$$WorkoutScreenUiStateImplCopyWithImpl<_$WorkoutScreenUiStateImpl>(
              this, _$identity);
}

abstract class _WorkoutScreenUiState implements WorkoutScreenUiState {
  const factory _WorkoutScreenUiState(
      {final List<WorkoutSummary> workoutSummaries,
      final bool isLoading,
      final String? errorMessage}) = _$WorkoutScreenUiStateImpl;

  @override
  List<WorkoutSummary> get workoutSummaries;
  @override
  bool get isLoading;
  @override
  String? get errorMessage;

  /// Create a copy of WorkoutScreenUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutScreenUiStateImplCopyWith<_$WorkoutScreenUiStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
