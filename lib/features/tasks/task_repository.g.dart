// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(taskRepository)
final taskRepositoryProvider = TaskRepositoryProvider._();

final class TaskRepositoryProvider
    extends $FunctionalProvider<TaskRepository, TaskRepository, TaskRepository>
    with $Provider<TaskRepository> {
  TaskRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskRepositoryHash();

  @$internal
  @override
  $ProviderElement<TaskRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TaskRepository create(Ref ref) {
    return taskRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskRepository>(value),
    );
  }
}

String _$taskRepositoryHash() => r'ddc44da6ddb87a48be338426c403c50cb95af55f';

@ProviderFor(tasksStream)
final tasksStreamProvider = TasksStreamFamily._();

final class TasksStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Task>>,
          List<Task>,
          Stream<List<Task>>
        >
    with $FutureModifier<List<Task>>, $StreamProvider<List<Task>> {
  TasksStreamProvider._({
    required TasksStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'tasksStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$tasksStreamHash();

  @override
  String toString() {
    return r'tasksStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Task>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Task>> create(Ref ref) {
    final argument = this.argument as String;
    return tasksStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TasksStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tasksStreamHash() => r'b0081fbde439d233efc435b5f2f5934adf861242';

final class TasksStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Task>>, String> {
  TasksStreamFamily._()
    : super(
        retry: null,
        name: r'tasksStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TasksStreamProvider call(String userId) =>
      TasksStreamProvider._(argument: userId, from: this);

  @override
  String toString() => r'tasksStreamProvider';
}

@ProviderFor(groupTasksStream)
final groupTasksStreamProvider = GroupTasksStreamFamily._();

final class GroupTasksStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Task>>,
          List<Task>,
          Stream<List<Task>>
        >
    with $FutureModifier<List<Task>>, $StreamProvider<List<Task>> {
  GroupTasksStreamProvider._({
    required GroupTasksStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'groupTasksStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$groupTasksStreamHash();

  @override
  String toString() {
    return r'groupTasksStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Task>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Task>> create(Ref ref) {
    final argument = this.argument as String;
    return groupTasksStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GroupTasksStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$groupTasksStreamHash() => r'2150fe25cd76741e0cfb251d614270ebba8112b5';

final class GroupTasksStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Task>>, String> {
  GroupTasksStreamFamily._()
    : super(
        retry: null,
        name: r'groupTasksStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GroupTasksStreamProvider call(String groupId) =>
      GroupTasksStreamProvider._(argument: groupId, from: this);

  @override
  String toString() => r'groupTasksStreamProvider';
}

@ProviderFor(assignedTasksStream)
final assignedTasksStreamProvider = AssignedTasksStreamFamily._();

final class AssignedTasksStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Task>>,
          List<Task>,
          Stream<List<Task>>
        >
    with $FutureModifier<List<Task>>, $StreamProvider<List<Task>> {
  AssignedTasksStreamProvider._({
    required AssignedTasksStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'assignedTasksStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$assignedTasksStreamHash();

  @override
  String toString() {
    return r'assignedTasksStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Task>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Task>> create(Ref ref) {
    final argument = this.argument as String;
    return assignedTasksStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AssignedTasksStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$assignedTasksStreamHash() =>
    r'96cfd94e75c6c4b40180dc66749963e84d248bea';

final class AssignedTasksStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Task>>, String> {
  AssignedTasksStreamFamily._()
    : super(
        retry: null,
        name: r'assignedTasksStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AssignedTasksStreamProvider call(String userId) =>
      AssignedTasksStreamProvider._(argument: userId, from: this);

  @override
  String toString() => r'assignedTasksStreamProvider';
}
