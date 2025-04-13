// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'power_meter_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PowerMeterData {
  int get power => throw _privateConstructorUsedError;
  int get cadence => throw _privateConstructorUsedError;

  /// Create a copy of PowerMeterData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PowerMeterDataCopyWith<PowerMeterData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PowerMeterDataCopyWith<$Res> {
  factory $PowerMeterDataCopyWith(
          PowerMeterData value, $Res Function(PowerMeterData) then) =
      _$PowerMeterDataCopyWithImpl<$Res, PowerMeterData>;
  @useResult
  $Res call({int power, int cadence});
}

/// @nodoc
class _$PowerMeterDataCopyWithImpl<$Res, $Val extends PowerMeterData>
    implements $PowerMeterDataCopyWith<$Res> {
  _$PowerMeterDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PowerMeterData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? power = null,
    Object? cadence = null,
  }) {
    return _then(_value.copyWith(
      power: null == power
          ? _value.power
          : power // ignore: cast_nullable_to_non_nullable
              as int,
      cadence: null == cadence
          ? _value.cadence
          : cadence // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PowerMeterDataImplCopyWith<$Res>
    implements $PowerMeterDataCopyWith<$Res> {
  factory _$$PowerMeterDataImplCopyWith(_$PowerMeterDataImpl value,
          $Res Function(_$PowerMeterDataImpl) then) =
      __$$PowerMeterDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int power, int cadence});
}

/// @nodoc
class __$$PowerMeterDataImplCopyWithImpl<$Res>
    extends _$PowerMeterDataCopyWithImpl<$Res, _$PowerMeterDataImpl>
    implements _$$PowerMeterDataImplCopyWith<$Res> {
  __$$PowerMeterDataImplCopyWithImpl(
      _$PowerMeterDataImpl _value, $Res Function(_$PowerMeterDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of PowerMeterData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? power = null,
    Object? cadence = null,
  }) {
    return _then(_$PowerMeterDataImpl(
      power: null == power
          ? _value.power
          : power // ignore: cast_nullable_to_non_nullable
              as int,
      cadence: null == cadence
          ? _value.cadence
          : cadence // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$PowerMeterDataImpl implements _PowerMeterData {
  const _$PowerMeterDataImpl({required this.power, required this.cadence});

  @override
  final int power;
  @override
  final int cadence;

  @override
  String toString() {
    return 'PowerMeterData(power: $power, cadence: $cadence)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PowerMeterDataImpl &&
            (identical(other.power, power) || other.power == power) &&
            (identical(other.cadence, cadence) || other.cadence == cadence));
  }

  @override
  int get hashCode => Object.hash(runtimeType, power, cadence);

  /// Create a copy of PowerMeterData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PowerMeterDataImplCopyWith<_$PowerMeterDataImpl> get copyWith =>
      __$$PowerMeterDataImplCopyWithImpl<_$PowerMeterDataImpl>(
          this, _$identity);
}

abstract class _PowerMeterData implements PowerMeterData {
  const factory _PowerMeterData(
      {required final int power,
      required final int cadence}) = _$PowerMeterDataImpl;

  @override
  int get power;
  @override
  int get cadence;

  /// Create a copy of PowerMeterData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PowerMeterDataImplCopyWith<_$PowerMeterDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
