import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/deep_link/deep_link_service.dart';
import 'router.dart';

/// Started once per signed-in session (from [RootShell]) — see
/// [DeepLinkService] for the URI format.
final deepLinkServiceProvider = Provider.autoDispose<DeepLinkService>((ref) {
  final router = ref.watch(goRouterProvider);
  final service = DeepLinkService(router);
  service.start();
  ref.onDispose(service.dispose);
  return service;
});
