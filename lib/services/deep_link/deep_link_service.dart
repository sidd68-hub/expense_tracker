import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

/// Handles `expensetracker://` deep links (rule #26) — from the iOS
/// Shortcut/MacroDroid "open the app" step, from Quick Launch (Phase 9), and
/// from future notification taps.
///
/// URIs use an empty authority so the path matches an existing go_router
/// route exactly, e.g. `expensetracker:///transactions/add?type=expense` —
/// no separate route-mapping table to keep in sync with router.dart.
/// `expensetracker://transactions` (no third slash) is also accepted by
/// treating the host as the first path segment, since that's the form most
/// people type/paste by habit.
class DeepLinkService {
  DeepLinkService(this._router) : _appLinks = AppLinks();

  final GoRouter _router;
  final AppLinks _appLinks;
  StreamSubscription<Uri>? _subscription;

  Future<void> start() async {
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) _handle(initialUri);
    } catch (e) {
      debugPrint('DeepLinkService: failed to read initial link: $e');
    }

    _subscription = _appLinks.uriLinkStream.listen(
      _handle,
      onError: (Object e) => debugPrint('DeepLinkService: stream error: $e'),
    );
  }

  void dispose() => _subscription?.cancel();

  void _handle(Uri uri) {
    if (uri.scheme != 'expensetracker') return;

    final path = uri.path.isNotEmpty ? uri.path : '/${uri.host}';
    final target = uri.hasQuery ? '$path?${uri.query}' : path;
    _router.go(target.isEmpty || target == '/' ? '/' : target);
  }
}
