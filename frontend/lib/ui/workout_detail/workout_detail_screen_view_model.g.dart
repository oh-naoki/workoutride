// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_detail_screen_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$workoutDetailScreenViewModelHash() =>
    r'c09779afb838917b77ea8f88627ef101029a4919';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$WorkoutDetailScreenViewModel
    extends BuildlessAutoDisposeNotifier<WorkoutDetailScreenUiState> {
  late final int workoutId;

  WorkoutDetailScreenUiState build(
    int workoutId,
  );
}

/// See also [WorkoutDetailScreenViewModel].
@ProviderFor(WorkoutDetailScreenViewModel)
const workoutDetailScreenViewModelProvider =
    WorkoutDetailScreenViewModelFamily();

/// See also [WorkoutDetailScreenViewModel].
class WorkoutDetailScreenViewModelFamily
    extends Family<WorkoutDetailScreenUiState> {
  /// See also [WorkoutDetailScreenViewModel].
  const WorkoutDetailScreenViewModelFamily();

  /// See also [WorkoutDetailScreenViewModel].
  WorkoutDetailScreenViewModelProvider call(
    int workoutId,
  ) {
    return WorkoutDetailScreenViewModelProvider(
      workoutId,
    );
  }

  @override
  WorkoutDetailScreenViewModelProvider getProviderOverride(
    covariant WorkoutDetailScreenViewModelProvider provider,
  ) {
    return call(
      provider.workoutId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'workoutDetailScreenViewModelProvider';
}

/// See also [WorkoutDetailScreenViewModel].
class WorkoutDetailScreenViewModelProvider
    extends AutoDisposeNotifierProviderImpl<WorkoutDetailScreenViewModel,
        WorkoutDetailScreenUiState> {
  /// See also [WorkoutDetailScreenViewModel].
  WorkoutDetailScreenViewModelProvider(
    int workoutId,
  ) : this._internal(
          () => WorkoutDetailScreenViewModel()..workoutId = workoutId,
          from: workoutDetailScreenViewModelProvider,
          name: r'workoutDetailScreenViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$workoutDetailScreenViewModelHash,
          dependencies: WorkoutDetailScreenViewModelFamily._dependencies,
          allTransitiveDependencies:
              WorkoutDetailScreenViewModelFamily._allTransitiveDependencies,
          workoutId: workoutId,
        );

  WorkoutDetailScreenViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.workoutId,
  }) : super.internal();

  final int workoutId;

  @override
  WorkoutDetailScreenUiState runNotifierBuild(
    covariant WorkoutDetailScreenViewModel notifier,
  ) {
    return notifier.build(
      workoutId,
    );
  }

  @override
  Override overrideWith(WorkoutDetailScreenViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: WorkoutDetailScreenViewModelProvider._internal(
        () => create()..workoutId = workoutId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        workoutId: workoutId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<WorkoutDetailScreenViewModel,
      WorkoutDetailScreenUiState> createElement() {
    return _WorkoutDetailScreenViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkoutDetailScreenViewModelProvider &&
        other.workoutId == workoutId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, workoutId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WorkoutDetailScreenViewModelRef
    on AutoDisposeNotifierProviderRef<WorkoutDetailScreenUiState> {
  /// The parameter `workoutId` of this provider.
  int get workoutId;
}

class _WorkoutDetailScreenViewModelProviderElement
    extends AutoDisposeNotifierProviderElement<WorkoutDetailScreenViewModel,
        WorkoutDetailScreenUiState> with WorkoutDetailScreenViewModelRef {
  _WorkoutDetailScreenViewModelProviderElement(super.provider);

  @override
  int get workoutId =>
      (origin as WorkoutDetailScreenViewModelProvider).workoutId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
