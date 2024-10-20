// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scan_screen_state_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ScanScreenUiState {
  List<ScanResult> get scanResults => throw _privateConstructorUsedError;

  /// Create a copy of ScanScreenUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScanScreenUiStateCopyWith<ScanScreenUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScanScreenUiStateCopyWith<$Res> {
  factory $ScanScreenUiStateCopyWith(
          ScanScreenUiState value, $Res Function(ScanScreenUiState) then) =
      _$ScanScreenUiStateCopyWithImpl<$Res, ScanScreenUiState>;
  @useResult
  $Res call({List<ScanResult> scanResults});
}

/// @nodoc
class _$ScanScreenUiStateCopyWithImpl<$Res, $Val extends ScanScreenUiState>
    implements $ScanScreenUiStateCopyWith<$Res> {
  _$ScanScreenUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScanScreenUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scanResults = null,
  }) {
    return _then(_value.copyWith(
      scanResults: null == scanResults
          ? _value.scanResults
          : scanResults // ignore: cast_nullable_to_non_nullable
              as List<ScanResult>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScanScreenUiStateImplCopyWith<$Res>
    implements $ScanScreenUiStateCopyWith<$Res> {
  factory _$$ScanScreenUiStateImplCopyWith(_$ScanScreenUiStateImpl value,
          $Res Function(_$ScanScreenUiStateImpl) then) =
      __$$ScanScreenUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ScanResult> scanResults});
}

/// @nodoc
class __$$ScanScreenUiStateImplCopyWithImpl<$Res>
    extends _$ScanScreenUiStateCopyWithImpl<$Res, _$ScanScreenUiStateImpl>
    implements _$$ScanScreenUiStateImplCopyWith<$Res> {
  __$$ScanScreenUiStateImplCopyWithImpl(_$ScanScreenUiStateImpl _value,
      $Res Function(_$ScanScreenUiStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ScanScreenUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scanResults = null,
  }) {
    return _then(_$ScanScreenUiStateImpl(
      scanResults: null == scanResults
          ? _value._scanResults
          : scanResults // ignore: cast_nullable_to_non_nullable
              as List<ScanResult>,
    ));
  }
}

/// @nodoc

class _$ScanScreenUiStateImpl
    with DiagnosticableTreeMixin
    implements _ScanScreenUiState {
  const _$ScanScreenUiStateImpl({final List<ScanResult> scanResults = const []})
      : _scanResults = scanResults;

  final List<ScanResult> _scanResults;
  @override
  @JsonKey()
  List<ScanResult> get scanResults {
    if (_scanResults is EqualUnmodifiableListView) return _scanResults;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scanResults);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ScanScreenUiState(scanResults: $scanResults)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ScanScreenUiState'))
      ..add(DiagnosticsProperty('scanResults', scanResults));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScanScreenUiStateImpl &&
            const DeepCollectionEquality()
                .equals(other._scanResults, _scanResults));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_scanResults));

  /// Create a copy of ScanScreenUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScanScreenUiStateImplCopyWith<_$ScanScreenUiStateImpl> get copyWith =>
      __$$ScanScreenUiStateImplCopyWithImpl<_$ScanScreenUiStateImpl>(
          this, _$identity);
}

abstract class _ScanScreenUiState implements ScanScreenUiState {
  const factory _ScanScreenUiState({final List<ScanResult> scanResults}) =
      _$ScanScreenUiStateImpl;

  @override
  List<ScanResult> get scanResults;

  /// Create a copy of ScanScreenUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScanScreenUiStateImplCopyWith<_$ScanScreenUiStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
