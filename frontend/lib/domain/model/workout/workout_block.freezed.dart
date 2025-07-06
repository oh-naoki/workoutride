// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_block.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WorkoutBlock {
  int get id => throw _privateConstructorUsedError;
  int get workoutId => throw _privateConstructorUsedError;
  int get orderIndex => throw _privateConstructorUsedError;
  int get targetPower => throw _privateConstructorUsedError;
  int get durationSeconds => throw _privateConstructorUsedError;
  String get blockType => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Create a copy of WorkoutBlock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutBlockCopyWith<WorkoutBlock> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutBlockCopyWith<$Res> {
  factory $WorkoutBlockCopyWith(
          WorkoutBlock value, $Res Function(WorkoutBlock) then) =
      _$WorkoutBlockCopyWithImpl<$Res, WorkoutBlock>;
  @useResult
  $Res call(
      {int id,
      int workoutId,
      int orderIndex,
      int targetPower,
      int durationSeconds,
      String blockType,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$WorkoutBlockCopyWithImpl<$Res, $Val extends WorkoutBlock>
    implements $WorkoutBlockCopyWith<$Res> {
  _$WorkoutBlockCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutBlock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workoutId = null,
    Object? orderIndex = null,
    Object? targetPower = null,
    Object? durationSeconds = null,
    Object? blockType = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      workoutId: null == workoutId
          ? _value.workoutId
          : workoutId // ignore: cast_nullable_to_non_nullable
              as int,
      orderIndex: null == orderIndex
          ? _value.orderIndex
          : orderIndex // ignore: cast_nullable_to_non_nullable
              as int,
      targetPower: null == targetPower
          ? _value.targetPower
          : targetPower // ignore: cast_nullable_to_non_nullable
              as int,
      durationSeconds: null == durationSeconds
          ? _value.durationSeconds
          : durationSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      blockType: null == blockType
          ? _value.blockType
          : blockType // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkoutBlockImplCopyWith<$Res>
    implements $WorkoutBlockCopyWith<$Res> {
  factory _$$WorkoutBlockImplCopyWith(
          _$WorkoutBlockImpl value, $Res Function(_$WorkoutBlockImpl) then) =
      __$$WorkoutBlockImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int workoutId,
      int orderIndex,
      int targetPower,
      int durationSeconds,
      String blockType,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$WorkoutBlockImplCopyWithImpl<$Res>
    extends _$WorkoutBlockCopyWithImpl<$Res, _$WorkoutBlockImpl>
    implements _$$WorkoutBlockImplCopyWith<$Res> {
  __$$WorkoutBlockImplCopyWithImpl(
      _$WorkoutBlockImpl _value, $Res Function(_$WorkoutBlockImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkoutBlock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workoutId = null,
    Object? orderIndex = null,
    Object? targetPower = null,
    Object? durationSeconds = null,
    Object? blockType = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$WorkoutBlockImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      workoutId: null == workoutId
          ? _value.workoutId
          : workoutId // ignore: cast_nullable_to_non_nullable
              as int,
      orderIndex: null == orderIndex
          ? _value.orderIndex
          : orderIndex // ignore: cast_nullable_to_non_nullable
              as int,
      targetPower: null == targetPower
          ? _value.targetPower
          : targetPower // ignore: cast_nullable_to_non_nullable
              as int,
      durationSeconds: null == durationSeconds
          ? _value.durationSeconds
          : durationSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      blockType: null == blockType
          ? _value.blockType
          : blockType // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$WorkoutBlockImpl implements _WorkoutBlock {
  const _$WorkoutBlockImpl(
      {required this.id,
      required this.workoutId,
      required this.orderIndex,
      required this.targetPower,
      required this.durationSeconds,
      required this.blockType,
      required this.createdAt,
      required this.updatedAt});

  @override
  final int id;
  @override
  final int workoutId;
  @override
  final int orderIndex;
  @override
  final int targetPower;
  @override
  final int durationSeconds;
  @override
  final String blockType;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'WorkoutBlock(id: $id, workoutId: $workoutId, orderIndex: $orderIndex, targetPower: $targetPower, durationSeconds: $durationSeconds, blockType: $blockType, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutBlockImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.workoutId, workoutId) ||
                other.workoutId == workoutId) &&
            (identical(other.orderIndex, orderIndex) ||
                other.orderIndex == orderIndex) &&
            (identical(other.targetPower, targetPower) ||
                other.targetPower == targetPower) &&
            (identical(other.durationSeconds, durationSeconds) ||
                other.durationSeconds == durationSeconds) &&
            (identical(other.blockType, blockType) ||
                other.blockType == blockType) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, workoutId, orderIndex,
      targetPower, durationSeconds, blockType, createdAt, updatedAt);

  /// Create a copy of WorkoutBlock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutBlockImplCopyWith<_$WorkoutBlockImpl> get copyWith =>
      __$$WorkoutBlockImplCopyWithImpl<_$WorkoutBlockImpl>(this, _$identity);
}

abstract class _WorkoutBlock implements WorkoutBlock {
  const factory _WorkoutBlock(
      {required final int id,
      required final int workoutId,
      required final int orderIndex,
      required final int targetPower,
      required final int durationSeconds,
      required final String blockType,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$WorkoutBlockImpl;

  @override
  int get id;
  @override
  int get workoutId;
  @override
  int get orderIndex;
  @override
  int get targetPower;
  @override
  int get durationSeconds;
  @override
  String get blockType;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of WorkoutBlock
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutBlockImplCopyWith<_$WorkoutBlockImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
