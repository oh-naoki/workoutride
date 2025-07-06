// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_progress_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WorkoutProgressState {
  List<WorkoutBlock> get blocks => throw _privateConstructorUsedError;
  int get currentBlockIndex => throw _privateConstructorUsedError;
  int get elapsedSeconds => throw _privateConstructorUsedError;
  int get totalSeconds => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;

  /// Create a copy of WorkoutProgressState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutProgressStateCopyWith<WorkoutProgressState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutProgressStateCopyWith<$Res> {
  factory $WorkoutProgressStateCopyWith(WorkoutProgressState value,
          $Res Function(WorkoutProgressState) then) =
      _$WorkoutProgressStateCopyWithImpl<$Res, WorkoutProgressState>;
  @useResult
  $Res call(
      {List<WorkoutBlock> blocks,
      int currentBlockIndex,
      int elapsedSeconds,
      int totalSeconds,
      bool isCompleted});
}

/// @nodoc
class _$WorkoutProgressStateCopyWithImpl<$Res,
        $Val extends WorkoutProgressState>
    implements $WorkoutProgressStateCopyWith<$Res> {
  _$WorkoutProgressStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutProgressState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? blocks = null,
    Object? currentBlockIndex = null,
    Object? elapsedSeconds = null,
    Object? totalSeconds = null,
    Object? isCompleted = null,
  }) {
    return _then(_value.copyWith(
      blocks: null == blocks
          ? _value.blocks
          : blocks // ignore: cast_nullable_to_non_nullable
              as List<WorkoutBlock>,
      currentBlockIndex: null == currentBlockIndex
          ? _value.currentBlockIndex
          : currentBlockIndex // ignore: cast_nullable_to_non_nullable
              as int,
      elapsedSeconds: null == elapsedSeconds
          ? _value.elapsedSeconds
          : elapsedSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      totalSeconds: null == totalSeconds
          ? _value.totalSeconds
          : totalSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkoutProgressStateImplCopyWith<$Res>
    implements $WorkoutProgressStateCopyWith<$Res> {
  factory _$$WorkoutProgressStateImplCopyWith(_$WorkoutProgressStateImpl value,
          $Res Function(_$WorkoutProgressStateImpl) then) =
      __$$WorkoutProgressStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<WorkoutBlock> blocks,
      int currentBlockIndex,
      int elapsedSeconds,
      int totalSeconds,
      bool isCompleted});
}

/// @nodoc
class __$$WorkoutProgressStateImplCopyWithImpl<$Res>
    extends _$WorkoutProgressStateCopyWithImpl<$Res, _$WorkoutProgressStateImpl>
    implements _$$WorkoutProgressStateImplCopyWith<$Res> {
  __$$WorkoutProgressStateImplCopyWithImpl(_$WorkoutProgressStateImpl _value,
      $Res Function(_$WorkoutProgressStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkoutProgressState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? blocks = null,
    Object? currentBlockIndex = null,
    Object? elapsedSeconds = null,
    Object? totalSeconds = null,
    Object? isCompleted = null,
  }) {
    return _then(_$WorkoutProgressStateImpl(
      blocks: null == blocks
          ? _value._blocks
          : blocks // ignore: cast_nullable_to_non_nullable
              as List<WorkoutBlock>,
      currentBlockIndex: null == currentBlockIndex
          ? _value.currentBlockIndex
          : currentBlockIndex // ignore: cast_nullable_to_non_nullable
              as int,
      elapsedSeconds: null == elapsedSeconds
          ? _value.elapsedSeconds
          : elapsedSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      totalSeconds: null == totalSeconds
          ? _value.totalSeconds
          : totalSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$WorkoutProgressStateImpl extends _WorkoutProgressState {
  const _$WorkoutProgressStateImpl(
      {final List<WorkoutBlock> blocks = const [],
      this.currentBlockIndex = 0,
      this.elapsedSeconds = 0,
      this.totalSeconds = 0,
      this.isCompleted = false})
      : _blocks = blocks,
        super._();

  final List<WorkoutBlock> _blocks;
  @override
  @JsonKey()
  List<WorkoutBlock> get blocks {
    if (_blocks is EqualUnmodifiableListView) return _blocks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_blocks);
  }

  @override
  @JsonKey()
  final int currentBlockIndex;
  @override
  @JsonKey()
  final int elapsedSeconds;
  @override
  @JsonKey()
  final int totalSeconds;
  @override
  @JsonKey()
  final bool isCompleted;

  @override
  String toString() {
    return 'WorkoutProgressState(blocks: $blocks, currentBlockIndex: $currentBlockIndex, elapsedSeconds: $elapsedSeconds, totalSeconds: $totalSeconds, isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutProgressStateImpl &&
            const DeepCollectionEquality().equals(other._blocks, _blocks) &&
            (identical(other.currentBlockIndex, currentBlockIndex) ||
                other.currentBlockIndex == currentBlockIndex) &&
            (identical(other.elapsedSeconds, elapsedSeconds) ||
                other.elapsedSeconds == elapsedSeconds) &&
            (identical(other.totalSeconds, totalSeconds) ||
                other.totalSeconds == totalSeconds) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_blocks),
      currentBlockIndex,
      elapsedSeconds,
      totalSeconds,
      isCompleted);

  /// Create a copy of WorkoutProgressState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutProgressStateImplCopyWith<_$WorkoutProgressStateImpl>
      get copyWith =>
          __$$WorkoutProgressStateImplCopyWithImpl<_$WorkoutProgressStateImpl>(
              this, _$identity);
}

abstract class _WorkoutProgressState extends WorkoutProgressState {
  const factory _WorkoutProgressState(
      {final List<WorkoutBlock> blocks,
      final int currentBlockIndex,
      final int elapsedSeconds,
      final int totalSeconds,
      final bool isCompleted}) = _$WorkoutProgressStateImpl;
  const _WorkoutProgressState._() : super._();

  @override
  List<WorkoutBlock> get blocks;
  @override
  int get currentBlockIndex;
  @override
  int get elapsedSeconds;
  @override
  int get totalSeconds;
  @override
  bool get isCompleted;

  /// Create a copy of WorkoutProgressState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutProgressStateImplCopyWith<_$WorkoutProgressStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
