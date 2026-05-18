// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(chatRepository)
final chatRepositoryProvider = ChatRepositoryProvider._();

final class ChatRepositoryProvider
    extends $FunctionalProvider<ChatRepository, ChatRepository, ChatRepository>
    with $Provider<ChatRepository> {
  ChatRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatRepositoryHash();

  @$internal
  @override
  $ProviderElement<ChatRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChatRepository create(Ref ref) {
    return chatRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatRepository>(value),
    );
  }
}

String _$chatRepositoryHash() => r'83100ab83bfd07c8fee6adb16071887b14cebb49';

@ProviderFor(groupMessagesStream)
final groupMessagesStreamProvider = GroupMessagesStreamFamily._();

final class GroupMessagesStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Message>>,
          List<Message>,
          Stream<List<Message>>
        >
    with $FutureModifier<List<Message>>, $StreamProvider<List<Message>> {
  GroupMessagesStreamProvider._({
    required GroupMessagesStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'groupMessagesStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$groupMessagesStreamHash();

  @override
  String toString() {
    return r'groupMessagesStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Message>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Message>> create(Ref ref) {
    final argument = this.argument as String;
    return groupMessagesStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GroupMessagesStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$groupMessagesStreamHash() =>
    r'050f67b30e84a51f0350efb77ce9e01820202c2c';

final class GroupMessagesStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Message>>, String> {
  GroupMessagesStreamFamily._()
    : super(
        retry: null,
        name: r'groupMessagesStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GroupMessagesStreamProvider call(String groupId) =>
      GroupMessagesStreamProvider._(argument: groupId, from: this);

  @override
  String toString() => r'groupMessagesStreamProvider';
}
