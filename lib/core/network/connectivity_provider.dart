import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Streams whether the device currently has *some* network path available.
///
/// This is a best-effort signal only (it does not guarantee Firestore is
/// reachable) — it drives the "offline" banner in the UI, while Firestore's
/// own offline persistence guarantees no writes are lost regardless of what
/// this reports.
final connectivityStreamProvider = StreamProvider<bool>((ref) {
  final connectivity = Connectivity();
  return connectivity.onConnectivityChanged.map(_hasConnection);
});

final isOnlineProvider = Provider<bool>((ref) {
  return ref.watch(connectivityStreamProvider).maybeWhen(
        data: (isOnline) => isOnline,
        orElse: () => true,
      );
});

bool _hasConnection(List<ConnectivityResult> results) {
  return results.any((r) => r != ConnectivityResult.none);
}
