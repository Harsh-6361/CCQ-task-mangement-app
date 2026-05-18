// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(adminRepository)
final adminRepositoryProvider = AdminRepositoryProvider._();

final class AdminRepositoryProvider
    extends
        $FunctionalProvider<AdminRepository, AdminRepository, AdminRepository>
    with $Provider<AdminRepository> {
  AdminRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminRepositoryHash();

  @$internal
  @override
  $ProviderElement<AdminRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AdminRepository create(Ref ref) {
    return adminRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdminRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdminRepository>(value),
    );
  }
}

String _$adminRepositoryHash() => r'7e609444f4edb1412cd53f642b5ca2a67bf0bbf4';

@ProviderFor(allUsersStream)
final allUsersStreamProvider = AllUsersStreamProvider._();

final class AllUsersStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AppUser>>,
          List<AppUser>,
          Stream<List<AppUser>>
        >
    with $FutureModifier<List<AppUser>>, $StreamProvider<List<AppUser>> {
  AllUsersStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allUsersStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allUsersStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<AppUser>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<AppUser>> create(Ref ref) {
    return allUsersStream(ref);
  }
}

String _$allUsersStreamHash() => r'186d9201809cc4c80b023a428b5e0cc65093aeb9';

@ProviderFor(auditLogsStream)
final auditLogsStreamProvider = AuditLogsStreamProvider._();

final class AuditLogsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AuditLog>>,
          List<AuditLog>,
          Stream<List<AuditLog>>
        >
    with $FutureModifier<List<AuditLog>>, $StreamProvider<List<AuditLog>> {
  AuditLogsStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'auditLogsStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$auditLogsStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<AuditLog>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<AuditLog>> create(Ref ref) {
    return auditLogsStream(ref);
  }
}

String _$auditLogsStreamHash() => r'15a9dc90d71b5a58d9d866b99b209dabf81c93a1';
