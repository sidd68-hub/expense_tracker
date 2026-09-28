// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_list_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Paginated transaction list for a given [filter]. Riverpod's generated
/// family treats each distinct filter as its own cached page sequence, so
/// switching filters and back doesn't necessarily refetch — see
/// [TransactionFilter]'s value equality.

@ProviderFor(TransactionListController)
final transactionListControllerProvider = TransactionListControllerFamily._();

/// Paginated transaction list for a given [filter]. Riverpod's generated
/// family treats each distinct filter as its own cached page sequence, so
/// switching filters and back doesn't necessarily refetch — see
/// [TransactionFilter]'s value equality.
final class TransactionListControllerProvider
    extends
        $AsyncNotifierProvider<
          TransactionListController,
          TransactionListState
        > {
  /// Paginated transaction list for a given [filter]. Riverpod's generated
  /// family treats each distinct filter as its own cached page sequence, so
  /// switching filters and back doesn't necessarily refetch — see
  /// [TransactionFilter]'s value equality.
  TransactionListControllerProvider._({
    required TransactionListControllerFamily super.from,
    required TransactionFilter super.argument,
  }) : super(
         retry: null,
         name: r'transactionListControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$transactionListControllerHash();

  @override
  String toString() {
    return r'transactionListControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TransactionListController create() => TransactionListController();

  @override
  bool operator ==(Object other) {
    return other is TransactionListControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$transactionListControllerHash() =>
    r'c2c06af1d366eddc4f450ab9cfff91a3d063f068';

/// Paginated transaction list for a given [filter]. Riverpod's generated
/// family treats each distinct filter as its own cached page sequence, so
/// switching filters and back doesn't necessarily refetch — see
/// [TransactionFilter]'s value equality.

final class TransactionListControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          TransactionListController,
          AsyncValue<TransactionListState>,
          TransactionListState,
          FutureOr<TransactionListState>,
          TransactionFilter
        > {
  TransactionListControllerFamily._()
    : super(
        retry: null,
        name: r'transactionListControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Paginated transaction list for a given [filter]. Riverpod's generated
  /// family treats each distinct filter as its own cached page sequence, so
  /// switching filters and back doesn't necessarily refetch — see
  /// [TransactionFilter]'s value equality.

  TransactionListControllerProvider call(TransactionFilter filter) =>
      TransactionListControllerProvider._(argument: filter, from: this);

  @override
  String toString() => r'transactionListControllerProvider';
}

/// Paginated transaction list for a given [filter]. Riverpod's generated
/// family treats each distinct filter as its own cached page sequence, so
/// switching filters and back doesn't necessarily refetch — see
/// [TransactionFilter]'s value equality.

abstract class _$TransactionListController
    extends $AsyncNotifier<TransactionListState> {
  late final _$args = ref.$arg as TransactionFilter;
  TransactionFilter get filter => _$args;

  FutureOr<TransactionListState> build(TransactionFilter filter);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<TransactionListState>, TransactionListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<TransactionListState>,
                TransactionListState
              >,
              AsyncValue<TransactionListState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
