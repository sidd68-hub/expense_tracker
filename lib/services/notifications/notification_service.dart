import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Thin wrapper around flutter_local_notifications. Kept deliberately small
/// for V1 — budget threshold alerts only. Other notification types (rule
/// #27: recurring reminders, import confirmations, sync failures) reuse
/// [show] once those features exist, so this stays the single place that
/// touches the plugin directly.
class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    await _plugin.initialize(
      settings: const InitializationSettings(android: androidSettings, iOS: iosSettings),
    );
    // Android 13+ requires this runtime permission separately from init.
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    _initialized = true;
  }

  Future<void> show({
    required String title,
    required String body,
    String channelId = 'general',
    String channelName = 'General',
  }) async {
    if (!_initialized) await initialize();
    await _plugin.show(
      // Stable-ish id derived from the title so repeated calls for the same
      // alert replace rather than stack notifications.
      id: title.hashCode,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    );
  }
}
