// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'automation_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AutomationTokenController)
final automationTokenControllerProvider = AutomationTokenControllerProvider._();

final class AutomationTokenControllerProvider
    extends $AsyncNotifierProvider<AutomationTokenController, void> {
  AutomationTokenControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'automationTokenControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$automationTokenControllerHash();

  @$internal
  @override
  AutomationTokenController create() => AutomationTokenController();
}

String _$automationTokenControllerHash() =>
    r'f1cff13dd1a78701bd6a6f74cee99c72c48b01b6';

abstract class _$AutomationTokenController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(InboxCommitController)
final inboxCommitControllerProvider = InboxCommitControllerProvider._();

final class InboxCommitControllerProvider
    extends $AsyncNotifierProvider<InboxCommitController, void> {
  InboxCommitControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inboxCommitControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inboxCommitControllerHash();

  @$internal
  @override
  InboxCommitController create() => InboxCommitController();
}

String _$inboxCommitControllerHash() =>
    r'e4eeb510ac0f8fa49229b9593f3b752989f45d92';

abstract class _$InboxCommitController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
