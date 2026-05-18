// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TaskController)
final taskControllerProvider = TaskControllerProvider._();

final class TaskControllerProvider
    extends $AsyncNotifierProvider<TaskController, void> {
  TaskControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskControllerHash();

  @$internal
  @override
  TaskController create() => TaskController();
}

String _$taskControllerHash() => r'19ce9670c38c55fce57dfc881096ec71e9d0259b';

abstract class _$TaskController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(filteredTasks)
final filteredTasksProvider = FilteredTasksFamily._();

final class FilteredTasksProvider
    extends $FunctionalProvider<List<Task>, List<Task>, List<Task>>
    with $Provider<List<Task>> {
  FilteredTasksProvider._({
    required FilteredTasksFamily super.from,
    required ({TaskStatus? status, String? category}) super.argument,
  }) : super(
         retry: null,
         name: r'filteredTasksProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$filteredTasksHash();

  @override
  String toString() {
    return r'filteredTasksProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<List<Task>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Task> create(Ref ref) {
    final argument = this.argument as ({TaskStatus? status, String? category});
    return filteredTasks(
      ref,
      status: argument.status,
      category: argument.category,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Task> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Task>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredTasksProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$filteredTasksHash() => r'ae7f85c74eecd2023e21500c1b7cdf0b856cbde6';

final class FilteredTasksFamily extends $Family
    with
        $FunctionalFamilyOverride<
          List<Task>,
          ({TaskStatus? status, String? category})
        > {
  FilteredTasksFamily._()
    : super(
        retry: null,
        name: r'filteredTasksProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FilteredTasksProvider call({TaskStatus? status, String? category}) =>
      FilteredTasksProvider._(
        argument: (status: status, category: category),
        from: this,
      );

  @override
  String toString() => r'filteredTasksProvider';
}
