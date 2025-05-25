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
  List<WorkoutBlock> get workoutBlocks => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  int get power => throw _privateConstructorUsedError;
  int get cadence => throw _privateConstructorUsedError;
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
      {List<WorkoutBlock> workoutBlocks,
      bool isLoading,
      int power,
      int cadence,
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
    Object? workoutBlocks = null,
    Object? isLoading = null,
    Object? power = null,
    Object? cadence = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      workoutBlocks: null == workoutBlocks
          ? _value.workoutBlocks
          : workoutBlocks // ignore: cast_nullable_to_non_nullable
              as List<WorkoutBlock>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      power: null == power
          ? _value.power
          : power // ignore: cast_nullable_to_non_nullable
              as int,
      cadence: null == cadence
          ? _value.cadence
          : cadence // ignore: cast_nullable_to_non_nullable
              as int,
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
      {List<WorkoutBlock> workoutBlocks,
      bool isLoading,
      int power,
      int cadence,
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
    Object? workoutBlocks = null,
    Object? isLoading = null,
    Object? power = null,
    Object? cadence = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$WorkoutScreenUiStateImpl(
      workoutBlocks: null == workoutBlocks
          ? _value._workoutBlocks
          : workoutBlocks // ignore: cast_nullable_to_non_nullable
              as List<WorkoutBlock>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      power: null == power
          ? _value.power
          : power // ignore: cast_nullable_to_non_nullable
              as int,
      cadence: null == cadence
          ? _value.cadence
          : cadence // ignore: cast_nullable_to_non_nullable
              as int,
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
      {final List<WorkoutBlock> workoutBlocks = const [],
      this.isLoading = false,
      this.power = 0,
      this.cadence = 0,
      this.errorMessage})
      : _workoutBlocks = workoutBlocks;

  final List<WorkoutBlock> _workoutBlocks;
  @override
  @JsonKey()
  List<WorkoutBlock> get workoutBlocks {
    if (_workoutBlocks is EqualUnmodifiableListView) return _workoutBlocks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_workoutBlocks);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final int power;
  @override
  @JsonKey()
  final int cadence;
  @override
  final String? errorMessage;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'WorkoutScreenUiState(workoutBlocks: $workoutBlocks, isLoading: $isLoading, power: $power, cadence: $cadence, errorMessage: $errorMessage)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'WorkoutScreenUiState'))
      ..add(DiagnosticsProperty('workoutBlocks', workoutBlocks))
      ..add(DiagnosticsProperty('isLoading', isLoading))
      ..add(DiagnosticsProperty('power', power))
      ..add(DiagnosticsProperty('cadence', cadence))
      ..add(DiagnosticsProperty('errorMessage', errorMessage));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutScreenUiStateImpl &&
            const DeepCollectionEquality()
                .equals(other._workoutBlocks, _workoutBlocks) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.power, power) || other.power == power) &&
            (identical(other.cadence, cadence) || other.cadence == cadence) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_workoutBlocks),
      isLoading,
      power,
      cadence,
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
      {final List<WorkoutBlock> workoutBlocks,
      final bool isLoading,
      final int power,
      final int cadence,
      final String? errorMessage}) = _$WorkoutScreenUiStateImpl;

  @override
  List<WorkoutBlock> get workoutBlocks;
  @override
  bool get isLoading;
  @override
  int get power;
  @override
  int get cadence;
  @override
  String? get errorMessage;

  /// Create a copy of WorkoutScreenUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutScreenUiStateImplCopyWith<_$WorkoutScreenUiStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
