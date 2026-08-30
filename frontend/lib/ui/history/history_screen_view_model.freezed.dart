// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history_screen_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HistoryScreenUiState {
  List<WorkoutResult> get workoutResults => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of HistoryScreenUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HistoryScreenUiStateCopyWith<HistoryScreenUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HistoryScreenUiStateCopyWith<$Res> {
  factory $HistoryScreenUiStateCopyWith(HistoryScreenUiState value,
          $Res Function(HistoryScreenUiState) then) =
      _$HistoryScreenUiStateCopyWithImpl<$Res, HistoryScreenUiState>;
  @useResult
  $Res call(
      {List<WorkoutResult> workoutResults,
      bool isLoading,
      String? errorMessage});
}

/// @nodoc
class _$HistoryScreenUiStateCopyWithImpl<$Res,
        $Val extends HistoryScreenUiState>
    implements $HistoryScreenUiStateCopyWith<$Res> {
  _$HistoryScreenUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HistoryScreenUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workoutResults = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      workoutResults: null == workoutResults
          ? _value.workoutResults
          : workoutResults // ignore: cast_nullable_to_non_nullable
              as List<WorkoutResult>,
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
abstract class _$$HistoryScreenUiStateImplCopyWith<$Res>
    implements $HistoryScreenUiStateCopyWith<$Res> {
  factory _$$HistoryScreenUiStateImplCopyWith(_$HistoryScreenUiStateImpl value,
          $Res Function(_$HistoryScreenUiStateImpl) then) =
      __$$HistoryScreenUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<WorkoutResult> workoutResults,
      bool isLoading,
      String? errorMessage});
}

/// @nodoc
class __$$HistoryScreenUiStateImplCopyWithImpl<$Res>
    extends _$HistoryScreenUiStateCopyWithImpl<$Res, _$HistoryScreenUiStateImpl>
    implements _$$HistoryScreenUiStateImplCopyWith<$Res> {
  __$$HistoryScreenUiStateImplCopyWithImpl(_$HistoryScreenUiStateImpl _value,
      $Res Function(_$HistoryScreenUiStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of HistoryScreenUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workoutResults = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$HistoryScreenUiStateImpl(
      workoutResults: null == workoutResults
          ? _value._workoutResults
          : workoutResults // ignore: cast_nullable_to_non_nullable
              as List<WorkoutResult>,
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

class _$HistoryScreenUiStateImpl
    with DiagnosticableTreeMixin
    implements _HistoryScreenUiState {
  const _$HistoryScreenUiStateImpl(
      {final List<WorkoutResult> workoutResults = const [],
      this.isLoading = false,
      this.errorMessage})
      : _workoutResults = workoutResults;

  final List<WorkoutResult> _workoutResults;
  @override
  @JsonKey()
  List<WorkoutResult> get workoutResults {
    if (_workoutResults is EqualUnmodifiableListView) return _workoutResults;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_workoutResults);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'HistoryScreenUiState(workoutResults: $workoutResults, isLoading: $isLoading, errorMessage: $errorMessage)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'HistoryScreenUiState'))
      ..add(DiagnosticsProperty('workoutResults', workoutResults))
      ..add(DiagnosticsProperty('isLoading', isLoading))
      ..add(DiagnosticsProperty('errorMessage', errorMessage));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HistoryScreenUiStateImpl &&
            const DeepCollectionEquality()
                .equals(other._workoutResults, _workoutResults) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_workoutResults),
      isLoading,
      errorMessage);

  /// Create a copy of HistoryScreenUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HistoryScreenUiStateImplCopyWith<_$HistoryScreenUiStateImpl>
      get copyWith =>
          __$$HistoryScreenUiStateImplCopyWithImpl<_$HistoryScreenUiStateImpl>(
              this, _$identity);
}

abstract class _HistoryScreenUiState implements HistoryScreenUiState {
  const factory _HistoryScreenUiState(
      {final List<WorkoutResult> workoutResults,
      final bool isLoading,
      final String? errorMessage}) = _$HistoryScreenUiStateImpl;

  @override
  List<WorkoutResult> get workoutResults;
  @override
  bool get isLoading;
  @override
  String? get errorMessage;

  /// Create a copy of HistoryScreenUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HistoryScreenUiStateImplCopyWith<_$HistoryScreenUiStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
