// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manage_workout_use_case.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$manageWorkoutUseCaseHash() =>
    r'7cec860201d72bb60dbae839e34d7ea6eaf883a3';

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

abstract class _$ManageWorkoutUseCase
    extends BuildlessAutoDisposeStreamNotifier<
        (WorkoutTimerState, WorkoutProgressState, PowerAlertMessage?)> {
  late final List<WorkoutBlock> blocks;

  Stream<(WorkoutTimerState, WorkoutProgressState, PowerAlertMessage?)> build(
    List<WorkoutBlock> blocks,
  );
}

/// See also [ManageWorkoutUseCase].
@ProviderFor(ManageWorkoutUseCase)
const manageWorkoutUseCaseProvider = ManageWorkoutUseCaseFamily();

/// See also [ManageWorkoutUseCase].
class ManageWorkoutUseCaseFamily extends Family<
    AsyncValue<(WorkoutTimerState, WorkoutProgressState, PowerAlertMessage?)>> {
  /// See also [ManageWorkoutUseCase].
  const ManageWorkoutUseCaseFamily();

  /// See also [ManageWorkoutUseCase].
  ManageWorkoutUseCaseProvider call(
    List<WorkoutBlock> blocks,
  ) {
    return ManageWorkoutUseCaseProvider(
      blocks,
    );
  }

  @override
  ManageWorkoutUseCaseProvider getProviderOverride(
    covariant ManageWorkoutUseCaseProvider provider,
  ) {
    return call(
      provider.blocks,
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
  String? get name => r'manageWorkoutUseCaseProvider';
}

/// See also [ManageWorkoutUseCase].
class ManageWorkoutUseCaseProvider
    extends AutoDisposeStreamNotifierProviderImpl<ManageWorkoutUseCase,
        (WorkoutTimerState, WorkoutProgressState, PowerAlertMessage?)> {
  /// See also [ManageWorkoutUseCase].
  ManageWorkoutUseCaseProvider(
    List<WorkoutBlock> blocks,
  ) : this._internal(
          () => ManageWorkoutUseCase()..blocks = blocks,
          from: manageWorkoutUseCaseProvider,
          name: r'manageWorkoutUseCaseProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$manageWorkoutUseCaseHash,
          dependencies: ManageWorkoutUseCaseFamily._dependencies,
          allTransitiveDependencies:
              ManageWorkoutUseCaseFamily._allTransitiveDependencies,
          blocks: blocks,
        );

  ManageWorkoutUseCaseProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.blocks,
  }) : super.internal();

  final List<WorkoutBlock> blocks;

  @override
  Stream<(WorkoutTimerState, WorkoutProgressState, PowerAlertMessage?)>
      runNotifierBuild(
    covariant ManageWorkoutUseCase notifier,
  ) {
    return notifier.build(
      blocks,
    );
  }

  @override
  Override overrideWith(ManageWorkoutUseCase Function() create) {
    return ProviderOverride(
      origin: this,
      override: ManageWorkoutUseCaseProvider._internal(
        () => create()..blocks = blocks,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        blocks: blocks,
      ),
    );
  }

  @override
  AutoDisposeStreamNotifierProviderElement<ManageWorkoutUseCase,
          (WorkoutTimerState, WorkoutProgressState, PowerAlertMessage?)>
      createElement() {
    return _ManageWorkoutUseCaseProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ManageWorkoutUseCaseProvider && other.blocks == blocks;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, blocks.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ManageWorkoutUseCaseRef on AutoDisposeStreamNotifierProviderRef<
    (WorkoutTimerState, WorkoutProgressState, PowerAlertMessage?)> {
  /// The parameter `blocks` of this provider.
  List<WorkoutBlock> get blocks;
}

class _ManageWorkoutUseCaseProviderElement
    extends AutoDisposeStreamNotifierProviderElement<ManageWorkoutUseCase,
        (WorkoutTimerState, WorkoutProgressState, PowerAlertMessage?)>
    with ManageWorkoutUseCaseRef {
  _ManageWorkoutUseCaseProviderElement(super.provider);

  @override
  List<WorkoutBlock> get blocks =>
      (origin as ManageWorkoutUseCaseProvider).blocks;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
