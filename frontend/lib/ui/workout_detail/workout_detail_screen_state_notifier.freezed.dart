// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_detail_screen_state_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WorkoutDetailScreenUiState {
  List<WorkoutBlock> get workoutBlocks => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of WorkoutDetailScreenUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutDetailScreenUiStateCopyWith<WorkoutDetailScreenUiState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutDetailScreenUiStateCopyWith<$Res> {
  factory $WorkoutDetailScreenUiStateCopyWith(WorkoutDetailScreenUiState value,
          $Res Function(WorkoutDetailScreenUiState) then) =
      _$WorkoutDetailScreenUiStateCopyWithImpl<$Res,
          WorkoutDetailScreenUiState>;
  @useResult
  $Res call(
      {List<WorkoutBlock> workoutBlocks, bool isLoading, String? errorMessage});
}

/// @nodoc
class _$WorkoutDetailScreenUiStateCopyWithImpl<$Res,
        $Val extends WorkoutDetailScreenUiState>
    implements $WorkoutDetailScreenUiStateCopyWith<$Res> {
  _$WorkoutDetailScreenUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutDetailScreenUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workoutBlocks = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      workoutBlocks: null == workoutBlocks
          ? _value.workoutBlocks
          : workoutBlocks // ignore: cast_nullable_to_non_nullable
              as List<WorkoutBlock>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkoutDetailScreenUiStateImplCopyWith<$Res>
    implements $WorkoutDetailScreenUiStateCopyWith<$Res> {
  factory _$$WorkoutDetailScreenUiStateImplCopyWith(
          _$WorkoutDetailScreenUiStateImpl value,
          $Res Function(_$WorkoutDetailScreenUiStateImpl) then) =
      __$$WorkoutDetailScreenUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<WorkoutBlock> workoutBlocks, bool isLoading, String? errorMessage});
}

/// @nodoc
class __$$WorkoutDetailScreenUiStateImplCopyWithImpl<$Res>
    extends _$WorkoutDetailScreenUiStateCopyWithImpl<$Res,
        _$WorkoutDetailScreenUiStateImpl>
    implements _$$WorkoutDetailScreenUiStateImplCopyWith<$Res> {
  __$$WorkoutDetailScreenUiStateImplCopyWithImpl(
      _$WorkoutDetailScreenUiStateImpl _value,
      $Res Function(_$WorkoutDetailScreenUiStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkoutDetailScreenUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workoutBlocks = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$WorkoutDetailScreenUiStateImpl(
      workoutBlocks: null == workoutBlocks
          ? _value._workoutBlocks
          : workoutBlocks // ignore: cast_nullable_to_non_nullable
              as List<WorkoutBlock>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$WorkoutDetailScreenUiStateImpl
    with DiagnosticableTreeMixin
    implements _WorkoutDetailScreenUiState {
  const _$WorkoutDetailScreenUiStateImpl(
      {final List<WorkoutBlock> workoutBlocks = const [],
      this.isLoading = false,
      this.errorMessage})
      : _workoutBlocks = workoutBlocks;

  final List<WorkoutBlock> _workoutBlocks;
  @override
  @JsonKey()
  List<WorkoutBlock> get workoutBlocks {
    if (_workoutBlocks is EqualUnmodifiableListView) return _workoutBlocks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_workoutBlocks);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'WorkoutDetailScreenUiState(workoutBlocks: $workoutBlocks, isLoading: $isLoading, errorMessage: $errorMessage)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'WorkoutDetailScreenUiState'))
      ..add(DiagnosticsProperty('workoutBlocks', workoutBlocks))
      ..add(DiagnosticsProperty('isLoading', isLoading))
      ..add(DiagnosticsProperty('errorMessage', errorMessage));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutDetailScreenUiStateImpl &&
            const DeepCollectionEquality()
                .equals(other._workoutBlocks, _workoutBlocks) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_workoutBlocks),
      isLoading,
      errorMessage);

  /// Create a copy of WorkoutDetailScreenUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutDetailScreenUiStateImplCopyWith<_$WorkoutDetailScreenUiStateImpl>
      get copyWith => __$$WorkoutDetailScreenUiStateImplCopyWithImpl<
          _$WorkoutDetailScreenUiStateImpl>(this, _$identity);
}

abstract class _WorkoutDetailScreenUiState
    implements WorkoutDetailScreenUiState {
  const factory _WorkoutDetailScreenUiState(
      {final List<WorkoutBlock> workoutBlocks,
      final bool isLoading,
      final String? errorMessage}) = _$WorkoutDetailScreenUiStateImpl;

  @override
  List<WorkoutBlock> get workoutBlocks;
  @override
  bool get isLoading;
  @override
  String? get errorMessage;

  /// Create a copy of WorkoutDetailScreenUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutDetailScreenUiStateImplCopyWith<_$WorkoutDetailScreenUiStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
