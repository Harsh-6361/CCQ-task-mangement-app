// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(groupRepository)
final groupRepositoryProvider = GroupRepositoryProvider._();

final class GroupRepositoryProvider
    extends
        $FunctionalProvider<GroupRepository, GroupRepository, GroupRepository>
    with $Provider<GroupRepository> {
  GroupRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'groupRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$groupRepositoryHash();

  @$internal
  @override
  $ProviderElement<GroupRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GroupRepository create(Ref ref) {
    return groupRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GroupRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GroupRepository>(value),
    );
  }
}

String _$groupRepositoryHash() => r'7015bfb9d3e0569140c5b994c396c46085467548';

@ProviderFor(userGroupsStream)
final userGroupsStreamProvider = UserGroupsStreamFamily._();

final class UserGroupsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Group>>,
          List<Group>,
          Stream<List<Group>>
        >
    with $FutureModifier<List<Group>>, $StreamProvider<List<Group>> {
  UserGroupsStreamProvider._({
    required UserGroupsStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userGroupsStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userGroupsStreamHash();

  @override
  String toString() {
    return r'userGroupsStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Group>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Group>> create(Ref ref) {
    final argument = this.argument as String;
    return userGroupsStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserGroupsStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userGroupsStreamHash() => r'8124b807c01eb93a00b9a0341d86a1a78eb843f9';

final class UserGroupsStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Group>>, String> {
  UserGroupsStreamFamily._()
    : super(
        retry: null,
        name: r'userGroupsStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UserGroupsStreamProvider call(String userId) =>
      UserGroupsStreamProvider._(argument: userId, from: this);

  @override
  String toString() => r'userGroupsStreamProvider';
}
