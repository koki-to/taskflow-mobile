// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TaskNotifier)
final taskProvider = TaskNotifierProvider._();

final class TaskNotifierProvider
    extends $NotifierProvider<TaskNotifier, TaskState> {
  TaskNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'taskProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$taskNotifierHash();

  @$internal
  @override
  TaskNotifier create() => TaskNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskState>(value),
    );
  }
}

String _$taskNotifierHash() => r'834bb4079c4579ba3f4482429f68b47d24c5beb4';

abstract class _$TaskNotifier extends $Notifier<TaskState> {
  TaskState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<TaskState, TaskState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<TaskState, TaskState>, TaskState, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}
