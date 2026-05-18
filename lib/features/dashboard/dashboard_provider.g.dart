// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DashboardController)
final dashboardControllerProvider = DashboardControllerFamily._();

final class DashboardControllerProvider
    extends $AsyncNotifierProvider<DashboardController, DashboardData> {
  DashboardControllerProvider._({
    required DashboardControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'dashboardControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$dashboardControllerHash();

  @override
  String toString() {
    return r'dashboardControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  DashboardController create() => DashboardController();

  @override
  bool operator ==(Object other) {
    return other is DashboardControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dashboardControllerHash() =>
    r'37e009a8c3f1c94d2f2d6b36e04a4b79316f023a';

final class DashboardControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          DashboardController,
          AsyncValue<DashboardData>,
          DashboardData,
          FutureOr<DashboardData>,
          String
        > {
  DashboardControllerFamily._()
    : super(
        retry: null,
        name: r'dashboardControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DashboardControllerProvider call(String userId) =>
      DashboardControllerProvider._(argument: userId, from: this);

  @override
  String toString() => r'dashboardControllerProvider';
}

abstract class _$DashboardController extends $AsyncNotifier<DashboardData> {
  late final _$args = ref.$arg as String;
  String get userId => _$args;

  FutureOr<DashboardData> build(String userId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<DashboardData>, DashboardData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DashboardData>, DashboardData>,
              AsyncValue<DashboardData>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
