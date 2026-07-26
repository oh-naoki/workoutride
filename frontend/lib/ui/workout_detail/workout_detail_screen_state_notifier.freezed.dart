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
  WorkoutSummary? get workoutSummary => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  double? get userWeight =>
      throw _privateConstructorUsedError; // 生の FTP。null は「未設定」を意味し、View 側でデフォルト200W扱い＋警告表示する。
  int? get userFtp => throw _privateConstructorUsedError;

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
      {List<WorkoutBlock> workoutBlocks,
      WorkoutSummary? workoutSummary,
      bool isLoading,
      String? errorMessage,
      double? userWeight,
      int? userFtp});

  $WorkoutSummaryCopyWith<$Res>? get workoutSummary;
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
    Object? workoutSummary = freezed,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? userWeight = freezed,
    Object? userFtp = freezed,
  }) {
    return _then(_value.copyWith(
      workoutBlocks: null == workoutBlocks
          ? _value.workoutBlocks
          : workoutBlocks // ignore: cast_nullable_to_non_nullable
              as List<WorkoutBlock>,
      workoutSummary: freezed == workoutSummary
          ? _value.workoutSummary
          : workoutSummary // ignore: cast_nullable_to_non_nullable
              as WorkoutSummary?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      userWeight: freezed == userWeight
          ? _value.userWeight
          : userWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      userFtp: freezed == userFtp
          ? _value.userFtp
          : userFtp // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  /// Create a copy of WorkoutDetailScreenUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WorkoutSummaryCopyWith<$Res>? get workoutSummary {
    if (_value.workoutSummary == null) {
      return null;
    }

    return $WorkoutSummaryCopyWith<$Res>(_value.workoutSummary!, (value) {
      return _then(_value.copyWith(workoutSummary: value) as $Val);
    });
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
      {List<WorkoutBlock> workoutBlocks,
      WorkoutSummary? workoutSummary,
      bool isLoading,
      String? errorMessage,
      double? userWeight,
      int? userFtp});

  @override
  $WorkoutSummaryCopyWith<$Res>? get workoutSummary;
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
    Object? workoutSummary = freezed,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? userWeight = freezed,
    Object? userFtp = freezed,
  }) {
    return _then(_$WorkoutDetailScreenUiStateImpl(
      workoutBlocks: null == workoutBlocks
          ? _value._workoutBlocks
          : workoutBlocks // ignore: cast_nullable_to_non_nullable
              as List<WorkoutBlock>,
      workoutSummary: freezed == workoutSummary
          ? _value.workoutSummary
          : workoutSummary // ignore: cast_nullable_to_non_nullable
              as WorkoutSummary?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      userWeight: freezed == userWeight
          ? _value.userWeight
          : userWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      userFtp: freezed == userFtp
          ? _value.userFtp
          : userFtp // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$WorkoutDetailScreenUiStateImpl
    with DiagnosticableTreeMixin
    implements _WorkoutDetailScreenUiState {
  const _$WorkoutDetailScreenUiStateImpl(
      {final List<WorkoutBlock> workoutBlocks = const [],
      this.workoutSummary = null,
      this.isLoading = false,
      this.errorMessage = null,
      this.userWeight = null,
      this.userFtp = null})
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
  final WorkoutSummary? workoutSummary;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final String? errorMessage;
  @override
  @JsonKey()
  final double? userWeight;
// 生の FTP。null は「未設定」を意味し、View 側でデフォルト200W扱い＋警告表示する。
  @override
  @JsonKey()
  final int? userFtp;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'WorkoutDetailScreenUiState(workoutBlocks: $workoutBlocks, workoutSummary: $workoutSummary, isLoading: $isLoading, errorMessage: $errorMessage, userWeight: $userWeight, userFtp: $userFtp)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'WorkoutDetailScreenUiState'))
      ..add(DiagnosticsProperty('workoutBlocks', workoutBlocks))
      ..add(DiagnosticsProperty('workoutSummary', workoutSummary))
      ..add(DiagnosticsProperty('isLoading', isLoading))
      ..add(DiagnosticsProperty('errorMessage', errorMessage))
      ..add(DiagnosticsProperty('userWeight', userWeight))
      ..add(DiagnosticsProperty('userFtp', userFtp));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutDetailScreenUiStateImpl &&
            const DeepCollectionEquality()
                .equals(other._workoutBlocks, _workoutBlocks) &&
            (identical(other.workoutSummary, workoutSummary) ||
                other.workoutSummary == workoutSummary) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.userWeight, userWeight) ||
                other.userWeight == userWeight) &&
            (identical(other.userFtp, userFtp) || other.userFtp == userFtp));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_workoutBlocks),
      workoutSummary,
      isLoading,
      errorMessage,
      userWeight,
      userFtp);

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
      final WorkoutSummary? workoutSummary,
      final bool isLoading,
      final String? errorMessage,
      final double? userWeight,
      final int? userFtp}) = _$WorkoutDetailScreenUiStateImpl;

  @override
  List<WorkoutBlock> get workoutBlocks;
  @override
  WorkoutSummary? get workoutSummary;
  @override
  bool get isLoading;
  @override
  String? get errorMessage;
  @override
  double? get userWeight; // 生の FTP。null は「未設定」を意味し、View 側でデフォルト200W扱い＋警告表示する。
  @override
  int? get userFtp;

  /// Create a copy of WorkoutDetailScreenUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutDetailScreenUiStateImplCopyWith<_$WorkoutDetailScreenUiStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
