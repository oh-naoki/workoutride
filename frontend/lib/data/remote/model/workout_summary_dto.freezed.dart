// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_summary_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WorkoutSummaryDto _$WorkoutSummaryDtoFromJson(Map<String, dynamic> json) {
  return _WorkoutSummaryDto.fromJson(json);
}

/// @nodoc
mixin _$WorkoutSummaryDto {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get total_duration => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get created_at => throw _privateConstructorUsedError;
  String get updated_at => throw _privateConstructorUsedError;

  /// Serializes this WorkoutSummaryDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkoutSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutSummaryDtoCopyWith<WorkoutSummaryDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutSummaryDtoCopyWith<$Res> {
  factory $WorkoutSummaryDtoCopyWith(
          WorkoutSummaryDto value, $Res Function(WorkoutSummaryDto) then) =
      _$WorkoutSummaryDtoCopyWithImpl<$Res, WorkoutSummaryDto>;
  @useResult
  $Res call(
      {int id,
      String name,
      int total_duration,
      String category,
      String created_at,
      String updated_at});
}

/// @nodoc
class _$WorkoutSummaryDtoCopyWithImpl<$Res, $Val extends WorkoutSummaryDto>
    implements $WorkoutSummaryDtoCopyWith<$Res> {
  _$WorkoutSummaryDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? total_duration = null,
    Object? category = null,
    Object? created_at = null,
    Object? updated_at = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      total_duration: null == total_duration
          ? _value.total_duration
          : total_duration // ignore: cast_nullable_to_non_nullable
              as int,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      created_at: null == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as String,
      updated_at: null == updated_at
          ? _value.updated_at
          : updated_at // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkoutSummaryDtoImplCopyWith<$Res>
    implements $WorkoutSummaryDtoCopyWith<$Res> {
  factory _$$WorkoutSummaryDtoImplCopyWith(_$WorkoutSummaryDtoImpl value,
          $Res Function(_$WorkoutSummaryDtoImpl) then) =
      __$$WorkoutSummaryDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      int total_duration,
      String category,
      String created_at,
      String updated_at});
}

/// @nodoc
class __$$WorkoutSummaryDtoImplCopyWithImpl<$Res>
    extends _$WorkoutSummaryDtoCopyWithImpl<$Res, _$WorkoutSummaryDtoImpl>
    implements _$$WorkoutSummaryDtoImplCopyWith<$Res> {
  __$$WorkoutSummaryDtoImplCopyWithImpl(_$WorkoutSummaryDtoImpl _value,
      $Res Function(_$WorkoutSummaryDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkoutSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? total_duration = null,
    Object? category = null,
    Object? created_at = null,
    Object? updated_at = null,
  }) {
    return _then(_$WorkoutSummaryDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      total_duration: null == total_duration
          ? _value.total_duration
          : total_duration // ignore: cast_nullable_to_non_nullable
              as int,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      created_at: null == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as String,
      updated_at: null == updated_at
          ? _value.updated_at
          : updated_at // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkoutSummaryDtoImpl implements _WorkoutSummaryDto {
  const _$WorkoutSummaryDtoImpl(
      {required this.id,
      required this.name,
      required this.total_duration,
      required this.category,
      required this.created_at,
      required this.updated_at});

  factory _$WorkoutSummaryDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkoutSummaryDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final int total_duration;
  @override
  final String category;
  @override
  final String created_at;
  @override
  final String updated_at;

  @override
  String toString() {
    return 'WorkoutSummaryDto(id: $id, name: $name, total_duration: $total_duration, category: $category, created_at: $created_at, updated_at: $updated_at)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutSummaryDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.total_duration, total_duration) ||
                other.total_duration == total_duration) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.created_at, created_at) ||
                other.created_at == created_at) &&
            (identical(other.updated_at, updated_at) ||
                other.updated_at == updated_at));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, total_duration, category, created_at, updated_at);

  /// Create a copy of WorkoutSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutSummaryDtoImplCopyWith<_$WorkoutSummaryDtoImpl> get copyWith =>
      __$$WorkoutSummaryDtoImplCopyWithImpl<_$WorkoutSummaryDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkoutSummaryDtoImplToJson(
      this,
    );
  }
}

abstract class _WorkoutSummaryDto implements WorkoutSummaryDto {
  const factory _WorkoutSummaryDto(
      {required final int id,
      required final String name,
      required final int total_duration,
      required final String category,
      required final String created_at,
      required final String updated_at}) = _$WorkoutSummaryDtoImpl;

  factory _WorkoutSummaryDto.fromJson(Map<String, dynamic> json) =
      _$WorkoutSummaryDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  int get total_duration;
  @override
  String get category;
  @override
  String get created_at;
  @override
  String get updated_at;

  /// Create a copy of WorkoutSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutSummaryDtoImplCopyWith<_$WorkoutSummaryDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
