// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_result_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WorkoutResultDraft {
  int get workoutSummaryId => throw _privateConstructorUsedError;
  DateTime get startedAt => throw _privateConstructorUsedError;
  DateTime? get finishedAt => throw _privateConstructorUsedError;
  int get totalDurationSeconds => throw _privateConstructorUsedError;
  int? get averagePower => throw _privateConstructorUsedError;
  int? get maxPower => throw _privateConstructorUsedError;
  int? get averageCadence => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  List<WorkoutBlockResultDraft> get blockResults =>
      throw _privateConstructorUsedError;

  /// Create a copy of WorkoutResultDraft
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutResultDraftCopyWith<WorkoutResultDraft> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutResultDraftCopyWith<$Res> {
  factory $WorkoutResultDraftCopyWith(
          WorkoutResultDraft value, $Res Function(WorkoutResultDraft) then) =
      _$WorkoutResultDraftCopyWithImpl<$Res, WorkoutResultDraft>;
  @useResult
  $Res call(
      {int workoutSummaryId,
      DateTime startedAt,
      DateTime? finishedAt,
      int totalDurationSeconds,
      int? averagePower,
      int? maxPower,
      int? averageCadence,
      String status,
      List<WorkoutBlockResultDraft> blockResults});
}

/// @nodoc
class _$WorkoutResultDraftCopyWithImpl<$Res, $Val extends WorkoutResultDraft>
    implements $WorkoutResultDraftCopyWith<$Res> {
  _$WorkoutResultDraftCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutResultDraft
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workoutSummaryId = null,
    Object? startedAt = null,
    Object? finishedAt = freezed,
    Object? totalDurationSeconds = null,
    Object? averagePower = freezed,
    Object? maxPower = freezed,
    Object? averageCadence = freezed,
    Object? status = null,
    Object? blockResults = null,
  }) {
    return _then(_value.copyWith(
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
      blockResults: null == blockResults
          ? _value.blockResults
          : blockResults // ignore: cast_nullable_to_non_nullable
              as List<WorkoutBlockResultDraft>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkoutResultDraftImplCopyWith<$Res>
    implements $WorkoutResultDraftCopyWith<$Res> {
  factory _$$WorkoutResultDraftImplCopyWith(_$WorkoutResultDraftImpl value,
          $Res Function(_$WorkoutResultDraftImpl) then) =
      __$$WorkoutResultDraftImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int workoutSummaryId,
      DateTime startedAt,
      DateTime? finishedAt,
      int totalDurationSeconds,
      int? averagePower,
      int? maxPower,
      int? averageCadence,
      String status,
      List<WorkoutBlockResultDraft> blockResults});
}

/// @nodoc
class __$$WorkoutResultDraftImplCopyWithImpl<$Res>
    extends _$WorkoutResultDraftCopyWithImpl<$Res, _$WorkoutResultDraftImpl>
    implements _$$WorkoutResultDraftImplCopyWith<$Res> {
  __$$WorkoutResultDraftImplCopyWithImpl(_$WorkoutResultDraftImpl _value,
      $Res Function(_$WorkoutResultDraftImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkoutResultDraft
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workoutSummaryId = null,
    Object? startedAt = null,
    Object? finishedAt = freezed,
    Object? totalDurationSeconds = null,
    Object? averagePower = freezed,
    Object? maxPower = freezed,
    Object? averageCadence = freezed,
    Object? status = null,
    Object? blockResults = null,
  }) {
    return _then(_$WorkoutResultDraftImpl(
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
      blockResults: null == blockResults
          ? _value._blockResults
          : blockResults // ignore: cast_nullable_to_non_nullable
              as List<WorkoutBlockResultDraft>,
    ));
  }
}

/// @nodoc

class _$WorkoutResultDraftImpl implements _WorkoutResultDraft {
  const _$WorkoutResultDraftImpl(
      {required this.workoutSummaryId,
      required this.startedAt,
      this.finishedAt,
      required this.totalDurationSeconds,
      this.averagePower,
      this.maxPower,
      this.averageCadence,
      required this.status,
      final List<WorkoutBlockResultDraft> blockResults = const []})
      : _blockResults = blockResults;

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
  final List<WorkoutBlockResultDraft> _blockResults;
  @override
  @JsonKey()
  List<WorkoutBlockResultDraft> get blockResults {
    if (_blockResults is EqualUnmodifiableListView) return _blockResults;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_blockResults);
  }

  @override
  String toString() {
    return 'WorkoutResultDraft(workoutSummaryId: $workoutSummaryId, startedAt: $startedAt, finishedAt: $finishedAt, totalDurationSeconds: $totalDurationSeconds, averagePower: $averagePower, maxPower: $maxPower, averageCadence: $averageCadence, status: $status, blockResults: $blockResults)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutResultDraftImpl &&
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
            const DeepCollectionEquality()
                .equals(other._blockResults, _blockResults));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      workoutSummaryId,
      startedAt,
      finishedAt,
      totalDurationSeconds,
      averagePower,
      maxPower,
      averageCadence,
      status,
      const DeepCollectionEquality().hash(_blockResults));

  /// Create a copy of WorkoutResultDraft
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutResultDraftImplCopyWith<_$WorkoutResultDraftImpl> get copyWith =>
      __$$WorkoutResultDraftImplCopyWithImpl<_$WorkoutResultDraftImpl>(
          this, _$identity);
}

abstract class _WorkoutResultDraft implements WorkoutResultDraft {
  const factory _WorkoutResultDraft(
          {required final int workoutSummaryId,
          required final DateTime startedAt,
          final DateTime? finishedAt,
          required final int totalDurationSeconds,
          final int? averagePower,
          final int? maxPower,
          final int? averageCadence,
          required final String status,
          final List<WorkoutBlockResultDraft> blockResults}) =
      _$WorkoutResultDraftImpl;

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
  List<WorkoutBlockResultDraft> get blockResults;

  /// Create a copy of WorkoutResultDraft
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutResultDraftImplCopyWith<_$WorkoutResultDraftImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$WorkoutBlockResultDraft {
  int get workoutBlockId => throw _privateConstructorUsedError;
  int? get averagePower => throw _privateConstructorUsedError;
  int? get maxPower => throw _privateConstructorUsedError;
  int? get averageCadence => throw _privateConstructorUsedError;
  int get durationSeconds => throw _privateConstructorUsedError;

  /// Create a copy of WorkoutBlockResultDraft
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutBlockResultDraftCopyWith<WorkoutBlockResultDraft> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutBlockResultDraftCopyWith<$Res> {
  factory $WorkoutBlockResultDraftCopyWith(WorkoutBlockResultDraft value,
          $Res Function(WorkoutBlockResultDraft) then) =
      _$WorkoutBlockResultDraftCopyWithImpl<$Res, WorkoutBlockResultDraft>;
  @useResult
  $Res call(
      {int workoutBlockId,
      int? averagePower,
      int? maxPower,
      int? averageCadence,
      int durationSeconds});
}

/// @nodoc
class _$WorkoutBlockResultDraftCopyWithImpl<$Res,
        $Val extends WorkoutBlockResultDraft>
    implements $WorkoutBlockResultDraftCopyWith<$Res> {
  _$WorkoutBlockResultDraftCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutBlockResultDraft
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workoutBlockId = null,
    Object? averagePower = freezed,
    Object? maxPower = freezed,
    Object? averageCadence = freezed,
    Object? durationSeconds = null,
  }) {
    return _then(_value.copyWith(
      workoutBlockId: null == workoutBlockId
          ? _value.workoutBlockId
          : workoutBlockId // ignore: cast_nullable_to_non_nullable
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
      durationSeconds: null == durationSeconds
          ? _value.durationSeconds
          : durationSeconds // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkoutBlockResultDraftImplCopyWith<$Res>
    implements $WorkoutBlockResultDraftCopyWith<$Res> {
  factory _$$WorkoutBlockResultDraftImplCopyWith(
          _$WorkoutBlockResultDraftImpl value,
          $Res Function(_$WorkoutBlockResultDraftImpl) then) =
      __$$WorkoutBlockResultDraftImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int workoutBlockId,
      int? averagePower,
      int? maxPower,
      int? averageCadence,
      int durationSeconds});
}

/// @nodoc
class __$$WorkoutBlockResultDraftImplCopyWithImpl<$Res>
    extends _$WorkoutBlockResultDraftCopyWithImpl<$Res,
        _$WorkoutBlockResultDraftImpl>
    implements _$$WorkoutBlockResultDraftImplCopyWith<$Res> {
  __$$WorkoutBlockResultDraftImplCopyWithImpl(
      _$WorkoutBlockResultDraftImpl _value,
      $Res Function(_$WorkoutBlockResultDraftImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkoutBlockResultDraft
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workoutBlockId = null,
    Object? averagePower = freezed,
    Object? maxPower = freezed,
    Object? averageCadence = freezed,
    Object? durationSeconds = null,
  }) {
    return _then(_$WorkoutBlockResultDraftImpl(
      workoutBlockId: null == workoutBlockId
          ? _value.workoutBlockId
          : workoutBlockId // ignore: cast_nullable_to_non_nullable
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
      durationSeconds: null == durationSeconds
          ? _value.durationSeconds
          : durationSeconds // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$WorkoutBlockResultDraftImpl implements _WorkoutBlockResultDraft {
  const _$WorkoutBlockResultDraftImpl(
      {required this.workoutBlockId,
      this.averagePower,
      this.maxPower,
      this.averageCadence,
      required this.durationSeconds});

  @override
  final int workoutBlockId;
  @override
  final int? averagePower;
  @override
  final int? maxPower;
  @override
  final int? averageCadence;
  @override
  final int durationSeconds;

  @override
  String toString() {
    return 'WorkoutBlockResultDraft(workoutBlockId: $workoutBlockId, averagePower: $averagePower, maxPower: $maxPower, averageCadence: $averageCadence, durationSeconds: $durationSeconds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutBlockResultDraftImpl &&
            (identical(other.workoutBlockId, workoutBlockId) ||
                other.workoutBlockId == workoutBlockId) &&
            (identical(other.averagePower, averagePower) ||
                other.averagePower == averagePower) &&
            (identical(other.maxPower, maxPower) ||
                other.maxPower == maxPower) &&
            (identical(other.averageCadence, averageCadence) ||
                other.averageCadence == averageCadence) &&
            (identical(other.durationSeconds, durationSeconds) ||
                other.durationSeconds == durationSeconds));
  }

  @override
  int get hashCode => Object.hash(runtimeType, workoutBlockId, averagePower,
      maxPower, averageCadence, durationSeconds);

  /// Create a copy of WorkoutBlockResultDraft
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutBlockResultDraftImplCopyWith<_$WorkoutBlockResultDraftImpl>
      get copyWith => __$$WorkoutBlockResultDraftImplCopyWithImpl<
          _$WorkoutBlockResultDraftImpl>(this, _$identity);
}

abstract class _WorkoutBlockResultDraft implements WorkoutBlockResultDraft {
  const factory _WorkoutBlockResultDraft(
      {required final int workoutBlockId,
      final int? averagePower,
      final int? maxPower,
      final int? averageCadence,
      required final int durationSeconds}) = _$WorkoutBlockResultDraftImpl;

  @override
  int get workoutBlockId;
  @override
  int? get averagePower;
  @override
  int? get maxPower;
  @override
  int? get averageCadence;
  @override
  int get durationSeconds;

  /// Create a copy of WorkoutBlockResultDraft
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutBlockResultDraftImplCopyWith<_$WorkoutBlockResultDraftImpl>
      get copyWith => throw _privateConstructorUsedError;
}
