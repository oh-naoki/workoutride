// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_id.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WorkoutId {
  int get id => throw _privateConstructorUsedError;

  /// Create a copy of WorkoutId
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutIdCopyWith<WorkoutId> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutIdCopyWith<$Res> {
  factory $WorkoutIdCopyWith(WorkoutId value, $Res Function(WorkoutId) then) =
      _$WorkoutIdCopyWithImpl<$Res, WorkoutId>;
  @useResult
  $Res call({int id});
}

/// @nodoc
class _$WorkoutIdCopyWithImpl<$Res, $Val extends WorkoutId>
    implements $WorkoutIdCopyWith<$Res> {
  _$WorkoutIdCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutId
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkoutIdImplCopyWith<$Res>
    implements $WorkoutIdCopyWith<$Res> {
  factory _$$WorkoutIdImplCopyWith(
          _$WorkoutIdImpl value, $Res Function(_$WorkoutIdImpl) then) =
      __$$WorkoutIdImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id});
}

/// @nodoc
class __$$WorkoutIdImplCopyWithImpl<$Res>
    extends _$WorkoutIdCopyWithImpl<$Res, _$WorkoutIdImpl>
    implements _$$WorkoutIdImplCopyWith<$Res> {
  __$$WorkoutIdImplCopyWithImpl(
      _$WorkoutIdImpl _value, $Res Function(_$WorkoutIdImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkoutId
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
  }) {
    return _then(_$WorkoutIdImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$WorkoutIdImpl implements _WorkoutId {
  const _$WorkoutIdImpl({required this.id});

  @override
  final int id;

  @override
  String toString() {
    return 'WorkoutId(id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutIdImpl &&
            (identical(other.id, id) || other.id == id));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id);

  /// Create a copy of WorkoutId
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutIdImplCopyWith<_$WorkoutIdImpl> get copyWith =>
      __$$WorkoutIdImplCopyWithImpl<_$WorkoutIdImpl>(this, _$identity);
}

abstract class _WorkoutId implements WorkoutId {
  const factory _WorkoutId({required final int id}) = _$WorkoutIdImpl;

  @override
  int get id;

  /// Create a copy of WorkoutId
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutIdImplCopyWith<_$WorkoutIdImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
