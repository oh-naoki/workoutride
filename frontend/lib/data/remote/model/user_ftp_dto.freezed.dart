// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_ftp_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserFtpDto _$UserFtpDtoFromJson(Map<String, dynamic> json) {
  return _UserFtpDto.fromJson(json);
}

/// @nodoc
mixin _$UserFtpDto {
  int get id => throw _privateConstructorUsedError;
  int get ftp_value => throw _privateConstructorUsedError;
  String get created_at => throw _privateConstructorUsedError;
  String get updated_at => throw _privateConstructorUsedError;

  /// Serializes this UserFtpDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserFtpDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserFtpDtoCopyWith<UserFtpDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserFtpDtoCopyWith<$Res> {
  factory $UserFtpDtoCopyWith(
          UserFtpDto value, $Res Function(UserFtpDto) then) =
      _$UserFtpDtoCopyWithImpl<$Res, UserFtpDto>;
  @useResult
  $Res call({int id, int ftp_value, String created_at, String updated_at});
}

/// @nodoc
class _$UserFtpDtoCopyWithImpl<$Res, $Val extends UserFtpDto>
    implements $UserFtpDtoCopyWith<$Res> {
  _$UserFtpDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserFtpDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ftp_value = null,
    Object? created_at = null,
    Object? updated_at = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      ftp_value: null == ftp_value
          ? _value.ftp_value
          : ftp_value // ignore: cast_nullable_to_non_nullable
              as int,
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
abstract class _$$UserFtpDtoImplCopyWith<$Res>
    implements $UserFtpDtoCopyWith<$Res> {
  factory _$$UserFtpDtoImplCopyWith(
          _$UserFtpDtoImpl value, $Res Function(_$UserFtpDtoImpl) then) =
      __$$UserFtpDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, int ftp_value, String created_at, String updated_at});
}

/// @nodoc
class __$$UserFtpDtoImplCopyWithImpl<$Res>
    extends _$UserFtpDtoCopyWithImpl<$Res, _$UserFtpDtoImpl>
    implements _$$UserFtpDtoImplCopyWith<$Res> {
  __$$UserFtpDtoImplCopyWithImpl(
      _$UserFtpDtoImpl _value, $Res Function(_$UserFtpDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserFtpDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ftp_value = null,
    Object? created_at = null,
    Object? updated_at = null,
  }) {
    return _then(_$UserFtpDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      ftp_value: null == ftp_value
          ? _value.ftp_value
          : ftp_value // ignore: cast_nullable_to_non_nullable
              as int,
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
class _$UserFtpDtoImpl implements _UserFtpDto {
  const _$UserFtpDtoImpl(
      {required this.id,
      required this.ftp_value,
      required this.created_at,
      required this.updated_at});

  factory _$UserFtpDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserFtpDtoImplFromJson(json);

  @override
  final int id;
  @override
  final int ftp_value;
  @override
  final String created_at;
  @override
  final String updated_at;

  @override
  String toString() {
    return 'UserFtpDto(id: $id, ftp_value: $ftp_value, created_at: $created_at, updated_at: $updated_at)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserFtpDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ftp_value, ftp_value) ||
                other.ftp_value == ftp_value) &&
            (identical(other.created_at, created_at) ||
                other.created_at == created_at) &&
            (identical(other.updated_at, updated_at) ||
                other.updated_at == updated_at));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, ftp_value, created_at, updated_at);

  /// Create a copy of UserFtpDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserFtpDtoImplCopyWith<_$UserFtpDtoImpl> get copyWith =>
      __$$UserFtpDtoImplCopyWithImpl<_$UserFtpDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserFtpDtoImplToJson(
      this,
    );
  }
}

abstract class _UserFtpDto implements UserFtpDto {
  const factory _UserFtpDto(
      {required final int id,
      required final int ftp_value,
      required final String created_at,
      required final String updated_at}) = _$UserFtpDtoImpl;

  factory _UserFtpDto.fromJson(Map<String, dynamic> json) =
      _$UserFtpDtoImpl.fromJson;

  @override
  int get id;
  @override
  int get ftp_value;
  @override
  String get created_at;
  @override
  String get updated_at;

  /// Create a copy of UserFtpDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserFtpDtoImplCopyWith<_$UserFtpDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
