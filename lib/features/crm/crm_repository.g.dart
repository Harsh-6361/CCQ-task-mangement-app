// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crm_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(crmRepository)
final crmRepositoryProvider = CrmRepositoryProvider._();

final class CrmRepositoryProvider
    extends $FunctionalProvider<CrmRepository, CrmRepository, CrmRepository>
    with $Provider<CrmRepository> {
  CrmRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'crmRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$crmRepositoryHash();

  @$internal
  @override
  $ProviderElement<CrmRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CrmRepository create(Ref ref) {
    return crmRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CrmRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CrmRepository>(value),
    );
  }
}

String _$crmRepositoryHash() => r'0ddfb1fbc59e7ce9f84843f2f2a4a0a47bed11d2';

@ProviderFor(leadsStream)
final leadsStreamProvider = LeadsStreamFamily._();

final class LeadsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Lead>>,
          List<Lead>,
          Stream<List<Lead>>
        >
    with $FutureModifier<List<Lead>>, $StreamProvider<List<Lead>> {
  LeadsStreamProvider._({
    required LeadsStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'leadsStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$leadsStreamHash();

  @override
  String toString() {
    return r'leadsStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Lead>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Lead>> create(Ref ref) {
    final argument = this.argument as String;
    return leadsStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LeadsStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$leadsStreamHash() => r'526b95ca62b33d177d72f0abf41d59deed7136a8';

final class LeadsStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Lead>>, String> {
  LeadsStreamFamily._()
    : super(
        retry: null,
        name: r'leadsStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LeadsStreamProvider call(String userId) =>
      LeadsStreamProvider._(argument: userId, from: this);

  @override
  String toString() => r'leadsStreamProvider';
}

@ProviderFor(allLeadsStream)
final allLeadsStreamProvider = AllLeadsStreamProvider._();

final class AllLeadsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Lead>>,
          List<Lead>,
          Stream<List<Lead>>
        >
    with $FutureModifier<List<Lead>>, $StreamProvider<List<Lead>> {
  AllLeadsStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allLeadsStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allLeadsStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<Lead>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Lead>> create(Ref ref) {
    return allLeadsStream(ref);
  }
}

String _$allLeadsStreamHash() => r'55ae8683a44f24868bb8a1fecc0474a2d80bcc03';

@ProviderFor(meetingsStream)
final meetingsStreamProvider = MeetingsStreamFamily._();

final class MeetingsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Meeting>>,
          List<Meeting>,
          Stream<List<Meeting>>
        >
    with $FutureModifier<List<Meeting>>, $StreamProvider<List<Meeting>> {
  MeetingsStreamProvider._({
    required MeetingsStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'meetingsStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$meetingsStreamHash();

  @override
  String toString() {
    return r'meetingsStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Meeting>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Meeting>> create(Ref ref) {
    final argument = this.argument as String;
    return meetingsStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MeetingsStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$meetingsStreamHash() => r'868eccde05206abec6b5e88a2d02715c3e00af43';

final class MeetingsStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Meeting>>, String> {
  MeetingsStreamFamily._()
    : super(
        retry: null,
        name: r'meetingsStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MeetingsStreamProvider call(String leadId) =>
      MeetingsStreamProvider._(argument: leadId, from: this);

  @override
  String toString() => r'meetingsStreamProvider';
}

@ProviderFor(allMeetingsStream)
final allMeetingsStreamProvider = AllMeetingsStreamFamily._();

final class AllMeetingsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Meeting>>,
          List<Meeting>,
          Stream<List<Meeting>>
        >
    with $FutureModifier<List<Meeting>>, $StreamProvider<List<Meeting>> {
  AllMeetingsStreamProvider._({
    required AllMeetingsStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'allMeetingsStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$allMeetingsStreamHash();

  @override
  String toString() {
    return r'allMeetingsStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Meeting>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Meeting>> create(Ref ref) {
    final argument = this.argument as String;
    return allMeetingsStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AllMeetingsStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$allMeetingsStreamHash() => r'fdd083aaed0d8b1e89d8d723358d74b271c3c889';

final class AllMeetingsStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Meeting>>, String> {
  AllMeetingsStreamFamily._()
    : super(
        retry: null,
        name: r'allMeetingsStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AllMeetingsStreamProvider call(String userId) =>
      AllMeetingsStreamProvider._(argument: userId, from: this);

  @override
  String toString() => r'allMeetingsStreamProvider';
}
