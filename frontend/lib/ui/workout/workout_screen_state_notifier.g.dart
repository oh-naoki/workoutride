// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_screen_state_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$workoutScreenStateNotifierHash() =>
    r'7828a9998baeb35447801ca62c63680c4b1a1e24';

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

abstract class _$WorkoutScreenStateNotifier
    extends BuildlessAutoDisposeNotifier<WorkoutScreenUiState> {
  late final int workoutId;

  WorkoutScreenUiState build(
    int workoutId,
  );
}

/// See also [WorkoutScreenStateNotifier].
@ProviderFor(WorkoutScreenStateNotifier)
const workoutScreenStateNotifierProvider = WorkoutScreenStateNotifierFamily();

/// See also [WorkoutScreenStateNotifier].
class WorkoutScreenStateNotifierFamily extends Family<WorkoutScreenUiState> {
  /// See also [WorkoutScreenStateNotifier].
  const WorkoutScreenStateNotifierFamily();

  /// See also [WorkoutScreenStateNotifier].
  WorkoutScreenStateNotifierProvider call(
    int workoutId,
  ) {
    return WorkoutScreenStateNotifierProvider(
      workoutId,
    );
  }

  @override
  WorkoutScreenStateNotifierProvider getProviderOverride(
    covariant WorkoutScreenStateNotifierProvider provider,
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
  String? get name => r'workoutScreenStateNotifierProvider';
}

/// See also [WorkoutScreenStateNotifier].
class WorkoutScreenStateNotifierProvider
    extends AutoDisposeNotifierProviderImpl<WorkoutScreenStateNotifier,
        WorkoutScreenUiState> {
  /// See also [WorkoutScreenStateNotifier].
  WorkoutScreenStateNotifierProvider(
    int workoutId,
  ) : this._internal(
          () => WorkoutScreenStateNotifier()..workoutId = workoutId,
          from: workoutScreenStateNotifierProvider,
          name: r'workoutScreenStateNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$workoutScreenStateNotifierHash,
          dependencies: WorkoutScreenStateNotifierFamily._dependencies,
          allTransitiveDependencies:
              WorkoutScreenStateNotifierFamily._allTransitiveDependencies,
          workoutId: workoutId,
        );

  WorkoutScreenStateNotifierProvider._internal(
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
    covariant WorkoutScreenStateNotifier notifier,
  ) {
    return notifier.build(
      workoutId,
    );
  }

  @override
  Override overrideWith(WorkoutScreenStateNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: WorkoutScreenStateNotifierProvider._internal(
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
  AutoDisposeNotifierProviderElement<WorkoutScreenStateNotifier,
      WorkoutScreenUiState> createElement() {
    return _WorkoutScreenStateNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkoutScreenStateNotifierProvider &&
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
mixin WorkoutScreenStateNotifierRef
    on AutoDisposeNotifierProviderRef<WorkoutScreenUiState> {
  /// The parameter `workoutId` of this provider.
  int get workoutId;
}

class _WorkoutScreenStateNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<WorkoutScreenStateNotifier,
        WorkoutScreenUiState> with WorkoutScreenStateNotifierRef {
  _WorkoutScreenStateNotifierProviderElement(super.provider);

  @override
  int get workoutId => (origin as WorkoutScreenStateNotifierProvider).workoutId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
