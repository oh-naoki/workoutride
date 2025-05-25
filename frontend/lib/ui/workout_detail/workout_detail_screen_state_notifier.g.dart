// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_detail_screen_state_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$workoutDetailScreenStateNotifierHash() =>
    r'a46249a17fd627b661dcf47a8c4bdc9dadb310c8';

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

abstract class _$WorkoutDetailScreenStateNotifier
    extends BuildlessAutoDisposeNotifier<WorkoutDetailScreenUiState> {
  late final int workoutId;

  WorkoutDetailScreenUiState build(
    int workoutId,
  );
}

/// See also [WorkoutDetailScreenStateNotifier].
@ProviderFor(WorkoutDetailScreenStateNotifier)
const workoutDetailScreenStateNotifierProvider =
    WorkoutDetailScreenStateNotifierFamily();

/// See also [WorkoutDetailScreenStateNotifier].
class WorkoutDetailScreenStateNotifierFamily
    extends Family<WorkoutDetailScreenUiState> {
  /// See also [WorkoutDetailScreenStateNotifier].
  const WorkoutDetailScreenStateNotifierFamily();

  /// See also [WorkoutDetailScreenStateNotifier].
  WorkoutDetailScreenStateNotifierProvider call(
    int workoutId,
  ) {
    return WorkoutDetailScreenStateNotifierProvider(
      workoutId,
    );
  }

  @override
  WorkoutDetailScreenStateNotifierProvider getProviderOverride(
    covariant WorkoutDetailScreenStateNotifierProvider provider,
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
  String? get name => r'workoutDetailScreenStateNotifierProvider';
}

/// See also [WorkoutDetailScreenStateNotifier].
class WorkoutDetailScreenStateNotifierProvider
    extends AutoDisposeNotifierProviderImpl<WorkoutDetailScreenStateNotifier,
        WorkoutDetailScreenUiState> {
  /// See also [WorkoutDetailScreenStateNotifier].
  WorkoutDetailScreenStateNotifierProvider(
    int workoutId,
  ) : this._internal(
          () => WorkoutDetailScreenStateNotifier()..workoutId = workoutId,
          from: workoutDetailScreenStateNotifierProvider,
          name: r'workoutDetailScreenStateNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$workoutDetailScreenStateNotifierHash,
          dependencies: WorkoutDetailScreenStateNotifierFamily._dependencies,
          allTransitiveDependencies:
              WorkoutDetailScreenStateNotifierFamily._allTransitiveDependencies,
          workoutId: workoutId,
        );

  WorkoutDetailScreenStateNotifierProvider._internal(
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
    covariant WorkoutDetailScreenStateNotifier notifier,
  ) {
    return notifier.build(
      workoutId,
    );
  }

  @override
  Override overrideWith(WorkoutDetailScreenStateNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: WorkoutDetailScreenStateNotifierProvider._internal(
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
  AutoDisposeNotifierProviderElement<WorkoutDetailScreenStateNotifier,
      WorkoutDetailScreenUiState> createElement() {
    return _WorkoutDetailScreenStateNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkoutDetailScreenStateNotifierProvider &&
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
mixin WorkoutDetailScreenStateNotifierRef
    on AutoDisposeNotifierProviderRef<WorkoutDetailScreenUiState> {
  /// The parameter `workoutId` of this provider.
  int get workoutId;
}

class _WorkoutDetailScreenStateNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<WorkoutDetailScreenStateNotifier,
        WorkoutDetailScreenUiState> with WorkoutDetailScreenStateNotifierRef {
  _WorkoutDetailScreenStateNotifierProviderElement(super.provider);

  @override
  int get workoutId =>
      (origin as WorkoutDetailScreenStateNotifierProvider).workoutId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
