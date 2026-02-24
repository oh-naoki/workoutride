// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WorkoutResult {
  int get id => throw _privateConstructorUsedError;
  int get workoutSummaryId => throw _privateConstructorUsedError;
  DateTime get startedAt => throw _privateConstructorUsedError;
  DateTime? get finishedAt => throw _privateConstructorUsedError;
  int get totalDurationSeconds => throw _privateConstructorUsedError;
  int? get averagePower => throw _privateConstructorUsedError;
  int? get maxPower => throw _privateConstructorUsedError;
  int? get averageCadence => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  List<WorkoutBlockResult> get workoutBlockResults =>
      throw _privateConstructorUsedError;

  /// Create a copy of WorkoutResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutResultCopyWith<WorkoutResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutResultCopyWith<$Res> {
  factory $WorkoutResultCopyWith(
          WorkoutResult value, $Res Function(WorkoutResult) then) =
      _$WorkoutResultCopyWithImpl<$Res, WorkoutResult>;
  @useResult
  $Res call(
      {int id,
      int workoutSummaryId,
      DateTime startedAt,
      DateTime? finishedAt,
      int totalDurationSeconds,
      int? averagePower,
      int? maxPower,
      int? averageCadence,
      String status,
      DateTime createdAt,
      DateTime updatedAt,
      List<WorkoutBlockResult> workoutBlockResults});
}

/// @nodoc
class _$WorkoutResultCopyWithImpl<$Res, $Val extends WorkoutResult>
    implements $WorkoutResultCopyWith<$Res> {
  _$WorkoutResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workoutSummaryId = null,
    Object? startedAt = null,
    Object? finishedAt = freezed,
    Object? totalDurationSeconds = null,
    Object? averagePower = freezed,
    Object? maxPower = freezed,
    Object? averageCadence = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? workoutBlockResults = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      workoutSummaryId: null == workoutSummaryId
          ? _value.workoutSummaryId
          : workoutSummaryId // ignore: cast_nullable_to_non_nullable
              as int,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      finishedAt: freezed == finishedAt
          ? _value.finishedAt
          : finishedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalDurationSeconds: null == totalDurationSeconds
          ? _value.totalDurationSeconds
          : totalDurationSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      averagePower: freezed == averagePower
          ? _value.averagePower
          : averagePower // ignore: cast_nullable_to_non_nullable
              as int?,
      maxPower: freezed == maxPower
          ? _value.maxPower
          : maxPower // ignore: cast_nullable_to_non_nullable
              as int?,
      averageCadence: freezed == averageCadence
          ? _value.averageCadence
          : averageCadence // ignore: cast_nullable_to_non_nullable
              as int?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      workoutBlockResults: null == workoutBlockResults
          ? _value.workoutBlockResults
          : workoutBlockResults // ignore: cast_nullable_to_non_nullable
              as List<WorkoutBlockResult>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkoutResultImplCopyWith<$Res>
    implements $WorkoutResultCopyWith<$Res> {
  factory _$$WorkoutResultImplCopyWith(
          _$WorkoutResultImpl value, $Res Function(_$WorkoutResultImpl) then) =
      __$$WorkoutResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int workoutSummaryId,
      DateTime startedAt,
      DateTime? finishedAt,
      int totalDurationSeconds,
      int? averagePower,
      int? maxPower,
      int? averageCadence,
      String status,
      DateTime createdAt,
      DateTime updatedAt,
      List<WorkoutBlockResult> workoutBlockResults});
}

/// @nodoc
class __$$WorkoutResultImplCopyWithImpl<$Res>
    extends _$WorkoutResultCopyWithImpl<$Res, _$WorkoutResultImpl>
    implements _$$WorkoutResultImplCopyWith<$Res> {
  __$$WorkoutResultImplCopyWithImpl(
      _$WorkoutResultImpl _value, $Res Function(_$WorkoutResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkoutResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workoutSummaryId = null,
    Object? startedAt = null,
    Object? finishedAt = freezed,
    Object? totalDurationSeconds = null,
    Object? averagePower = freezed,
    Object? maxPower = freezed,
    Object? averageCadence = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? workoutBlockResults = null,
  }) {
    return _then(_$WorkoutResultImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      workoutSummaryId: null == workoutSummaryId
          ? _value.workoutSummaryId
          : workoutSummaryId // ignore: cast_nullable_to_non_nullable
              as int,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      finishedAt: freezed == finishedAt
          ? _value.finishedAt
          : finishedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalDurationSeconds: null == totalDurationSeconds
          ? _value.totalDurationSeconds
          : totalDurationSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      averagePower: freezed == averagePower
          ? _value.averagePower
          : averagePower // ignore: cast_nullable_to_non_nullable
              as int?,
      maxPower: freezed == maxPower
          ? _value.maxPower
          : maxPower // ignore: cast_nullable_to_non_nullable
              as int?,
      averageCadence: freezed == averageCadence
          ? _value.averageCadence
          : averageCadence // ignore: cast_nullable_to_non_nullable
              as int?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      workoutBlockResults: null == workoutBlockResults
          ? _value._workoutBlockResults
          : workoutBlockResults // ignore: cast_nullable_to_non_nullable
              as List<WorkoutBlockResult>,
    ));
  }
}

/// @nodoc

class _$WorkoutResultImpl implements _WorkoutResult {
  const _$WorkoutResultImpl(
      {required this.id,
      required this.workoutSummaryId,
      required this.startedAt,
      this.finishedAt,
      required this.totalDurationSeconds,
      this.averagePower,
      this.maxPower,
      this.averageCadence,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      final List<WorkoutBlockResult> workoutBlockResults = const []})
      : _workoutBlockResults = workoutBlockResults;

  @override
  final int id;
  @override
  final int workoutSummaryId;
  @override
  final DateTime startedAt;
  @override
  final DateTime? finishedAt;
  @override
  final int totalDurationSeconds;
  @override
  final int? averagePower;
  @override
  final int? maxPower;
  @override
  final int? averageCadence;
  @override
  final String status;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  final List<WorkoutBlockResult> _workoutBlockResults;
  @override
  @JsonKey()
  List<WorkoutBlockResult> get workoutBlockResults {
    if (_workoutBlockResults is EqualUnmodifiableListView)
      return _workoutBlockResults;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_workoutBlockResults);
  }

  @override
  String toString() {
    return 'WorkoutResult(id: $id, workoutSummaryId: $workoutSummaryId, startedAt: $startedAt, finishedAt: $finishedAt, totalDurationSeconds: $totalDurationSeconds, averagePower: $averagePower, maxPower: $maxPower, averageCadence: $averageCadence, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, workoutBlockResults: $workoutBlockResults)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutResultImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.workoutSummaryId, workoutSummaryId) ||
                other.workoutSummaryId == workoutSummaryId) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.finishedAt, finishedAt) ||
                other.finishedAt == finishedAt) &&
            (identical(other.totalDurationSeconds, totalDurationSeconds) ||
                other.totalDurationSeconds == totalDurationSeconds) &&
            (identical(other.averagePower, averagePower) ||
                other.averagePower == averagePower) &&
            (identical(other.maxPower, maxPower) ||
                other.maxPower == maxPower) &&
            (identical(other.averageCadence, averageCadence) ||
                other.averageCadence == averageCadence) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other._workoutBlockResults, _workoutBlockResults));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      workoutSummaryId,
      startedAt,
      finishedAt,
      totalDurationSeconds,
      averagePower,
      maxPower,
      averageCadence,
      status,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_workoutBlockResults));

  /// Create a copy of WorkoutResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutResultImplCopyWith<_$WorkoutResultImpl> get copyWith =>
      __$$WorkoutResultImplCopyWithImpl<_$WorkoutResultImpl>(this, _$identity);
}

abstract class _WorkoutResult implements WorkoutResult {
  const factory _WorkoutResult(
          {required final int id,
          required final int workoutSummaryId,
          required final DateTime startedAt,
          final DateTime? finishedAt,
          required final int totalDurationSeconds,
          final int? averagePower,
          final int? maxPower,
          final int? averageCadence,
          required final String status,
          required final DateTime createdAt,
          required final DateTime updatedAt,
          final List<WorkoutBlockResult> workoutBlockResults}) =
      _$WorkoutResultImpl;

  @override
  int get id;
  @override
  int get workoutSummaryId;
  @override
  DateTime get startedAt;
  @override
  DateTime? get finishedAt;
  @override
  int get totalDurationSeconds;
  @override
  int? get averagePower;
  @override
  int? get maxPower;
  @override
  int? get averageCadence;
  @override
  String get status;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  List<WorkoutBlockResult> get workoutBlockResults;

  /// Create a copy of WorkoutResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutResultImplCopyWith<_$WorkoutResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
