// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_screen_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$workoutScreenViewModelHash() =>
    r'0012b1c837a7edfc6ae0633252c6a018299df471';

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

abstract class _$WorkoutScreenViewModel
    extends BuildlessAutoDisposeNotifier<WorkoutScreenUiState> {
  late final int workoutId;

  WorkoutScreenUiState build(
    int workoutId,
  );
}

/// See also [WorkoutScreenViewModel].
@ProviderFor(WorkoutScreenViewModel)
const workoutScreenViewModelProvider = WorkoutScreenViewModelFamily();

/// See also [WorkoutScreenViewModel].
class WorkoutScreenViewModelFamily extends Family<WorkoutScreenUiState> {
  /// See also [WorkoutScreenViewModel].
  const WorkoutScreenViewModelFamily();

  /// See also [WorkoutScreenViewModel].
  WorkoutScreenViewModelProvider call(
    int workoutId,
  ) {
    return WorkoutScreenViewModelProvider(
      workoutId,
    );
  }

  @override
  WorkoutScreenViewModelProvider getProviderOverride(
    covariant WorkoutScreenViewModelProvider provider,
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
  String? get name => r'workoutScreenViewModelProvider';
}

/// See also [WorkoutScreenViewModel].
class WorkoutScreenViewModelProvider extends AutoDisposeNotifierProviderImpl<
    WorkoutScreenViewModel, WorkoutScreenUiState> {
  /// See also [WorkoutScreenViewModel].
  WorkoutScreenViewModelProvider(
    int workoutId,
  ) : this._internal(
          () => WorkoutScreenViewModel()..workoutId = workoutId,
          from: workoutScreenViewModelProvider,
          name: r'workoutScreenViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$workoutScreenViewModelHash,
          dependencies: WorkoutScreenViewModelFamily._dependencies,
          allTransitiveDependencies:
              WorkoutScreenViewModelFamily._allTransitiveDependencies,
          workoutId: workoutId,
        );

  WorkoutScreenViewModelProvider._internal(
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
  WorkoutScreenUiState runNotifierBuild(
    covariant WorkoutScreenViewModel notifier,
  ) {
    return notifier.build(
      workoutId,
    );
  }

  @override
  Override overrideWith(WorkoutScreenViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: WorkoutScreenViewModelProvider._internal(
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
  AutoDisposeNotifierProviderElement<WorkoutScreenViewModel,
      WorkoutScreenUiState> createElement() {
    return _WorkoutScreenViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkoutScreenViewModelProvider &&
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
mixin WorkoutScreenViewModelRef
    on AutoDisposeNotifierProviderRef<WorkoutScreenUiState> {
  /// The parameter `workoutId` of this provider.
  int get workoutId;
}

class _WorkoutScreenViewModelProviderElement
    extends AutoDisposeNotifierProviderElement<WorkoutScreenViewModel,
        WorkoutScreenUiState> with WorkoutScreenViewModelRef {
  _WorkoutScreenViewModelProviderElement(super.provider);

  @override
  int get workoutId => (origin as WorkoutScreenViewModelProvider).workoutId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
