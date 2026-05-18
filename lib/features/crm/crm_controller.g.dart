// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crm_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CrmController)
final crmControllerProvider = CrmControllerProvider._();

final class CrmControllerProvider
    extends $AsyncNotifierProvider<CrmController, void> {
  CrmControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'crmControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$crmControllerHash();

  @$internal
  @override
  CrmController create() => CrmController();
}

String _$crmControllerHash() => r'db61c7fb6f2ce14dcd57ea4edfe28369e35ec434';

abstract class _$CrmController extends $AsyncNotifier<void> {
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
