// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_timer_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WorkoutTimerState {
  int get elapsedSeconds => throw _privateConstructorUsedError;
  bool get isRunning => throw _privateConstructorUsedError;

  /// Create a copy of WorkoutTimerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutTimerStateCopyWith<WorkoutTimerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutTimerStateCopyWith<$Res> {
  factory $WorkoutTimerStateCopyWith(
          WorkoutTimerState value, $Res Function(WorkoutTimerState) then) =
      _$WorkoutTimerStateCopyWithImpl<$Res, WorkoutTimerState>;
  @useResult
  $Res call({int elapsedSeconds, bool isRunning});
}

/// @nodoc
class _$WorkoutTimerStateCopyWithImpl<$Res, $Val extends WorkoutTimerState>
    implements $WorkoutTimerStateCopyWith<$Res> {
  _$WorkoutTimerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutTimerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? elapsedSeconds = null,
    Object? isRunning = null,
  }) {
    return _then(_value.copyWith(
      elapsedSeconds: null == elapsedSeconds
          ? _value.elapsedSeconds
          : elapsedSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      isRunning: null == isRunning
          ? _value.isRunning
          : isRunning // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkoutTimerStateImplCopyWith<$Res>
    implements $WorkoutTimerStateCopyWith<$Res> {
  factory _$$WorkoutTimerStateImplCopyWith(_$WorkoutTimerStateImpl value,
          $Res Function(_$WorkoutTimerStateImpl) then) =
      __$$WorkoutTimerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int elapsedSeconds, bool isRunning});
}

/// @nodoc
class __$$WorkoutTimerStateImplCopyWithImpl<$Res>
    extends _$WorkoutTimerStateCopyWithImpl<$Res, _$WorkoutTimerStateImpl>
    implements _$$WorkoutTimerStateImplCopyWith<$Res> {
  __$$WorkoutTimerStateImplCopyWithImpl(_$WorkoutTimerStateImpl _value,
      $Res Function(_$WorkoutTimerStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkoutTimerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? elapsedSeconds = null,
    Object? isRunning = null,
  }) {
    return _then(_$WorkoutTimerStateImpl(
      elapsedSeconds: null == elapsedSeconds
          ? _value.elapsedSeconds
          : elapsedSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      isRunning: null == isRunning
          ? _value.isRunning
          : isRunning // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$WorkoutTimerStateImpl implements _WorkoutTimerState {
  const _$WorkoutTimerStateImpl(
      {this.elapsedSeconds = 0, this.isRunning = false});

  @override
  @JsonKey()
  final int elapsedSeconds;
  @override
  @JsonKey()
  final bool isRunning;

  @override
  String toString() {
    return 'WorkoutTimerState(elapsedSeconds: $elapsedSeconds, isRunning: $isRunning)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutTimerStateImpl &&
            (identical(other.elapsedSeconds, elapsedSeconds) ||
                other.elapsedSeconds == elapsedSeconds) &&
            (identical(other.isRunning, isRunning) ||
                other.isRunning == isRunning));
  }

  @override
  int get hashCode => Object.hash(runtimeType, elapsedSeconds, isRunning);

  /// Create a copy of WorkoutTimerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutTimerStateImplCopyWith<_$WorkoutTimerStateImpl> get copyWith =>
      __$$WorkoutTimerStateImplCopyWithImpl<_$WorkoutTimerStateImpl>(
          this, _$identity);
}

abstract class _WorkoutTimerState implements WorkoutTimerState {
  const factory _WorkoutTimerState(
      {final int elapsedSeconds,
      final bool isRunning}) = _$WorkoutTimerStateImpl;

  @override
  int get elapsedSeconds;
  @override
  bool get isRunning;

  /// Create a copy of WorkoutTimerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutTimerStateImplCopyWith<_$WorkoutTimerStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
