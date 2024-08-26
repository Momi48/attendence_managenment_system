import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final notifications = FlutterLocalNotificationsPlugin();

  void initNotifications() {
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    notifications.initialize(initializationSettings);
  }

  void showNotification() {
    notifications.show(
      0,
      'Emergency Leave Request to Admin',
      'I need a leave due to an emergency issue.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_id',
          'channel_name',
          channelDescription: 'channel_description',
        ),
      ),
    );
  }
}