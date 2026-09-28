// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TransactionFormController)
final transactionFormControllerProvider = TransactionFormControllerProvider._();

final class TransactionFormControllerProvider
    extends $AsyncNotifierProvider<TransactionFormController, void> {
  TransactionFormControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionFormControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionFormControllerHash();

  @$internal
  @override
  TransactionFormController create() => TransactionFormController();
}

String _$transactionFormControllerHash() =>
    r'aeb12d364fb5d1597e75cd5f3ec546b2d2db274f';

abstract class _$TransactionFormController extends $AsyncNotifier<void> {
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

/// Loads a single transaction for editing. `autoDispose.family` so each
/// transaction id gets its own cached fetch and it's released once the edit
/// screen closes.

@ProviderFor(transactionById)
final transactionByIdProvider = TransactionByIdFamily._();

/// Loads a single transaction for editing. `autoDispose.family` so each
/// transaction id gets its own cached fetch and it's released once the edit
/// screen closes.

final class TransactionByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<TransactionEntity?>,
          TransactionEntity?,
          FutureOr<TransactionEntity?>
        >
    with
        $FutureModifier<TransactionEntity?>,
        $FutureProvider<TransactionEntity?> {
  /// Loads a single transaction for editing. `autoDispose.family` so each
  /// transaction id gets its own cached fetch and it's released once the edit
  /// screen closes.
  TransactionByIdProvider._({
    required TransactionByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'transactionByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$transactionByIdHash();

  @override
  String toString() {
    return r'transactionByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<TransactionEntity?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<TransactionEntity?> create(Ref ref) {
    final argument = this.argument as String;
    return transactionById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TransactionByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$transactionByIdHash() => r'c1ff82914d459739c7dcdb4f36c6b58f1d76252c';

/// Loads a single transaction for editing. `autoDispose.family` so each
/// transaction id gets its own cached fetch and it's released once the edit
/// screen closes.

final class TransactionByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<TransactionEntity?>, String> {
  TransactionByIdFamily._()
    : super(
        retry: null,
        name: r'transactionByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Loads a single transaction for editing. `autoDispose.family` so each
  /// transaction id gets its own cached fetch and it's released once the edit
  /// screen closes.

  TransactionByIdProvider call(String id) =>
      TransactionByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'transactionByIdProvider';
}
