import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;


class AlarmNotifiction {
  static final _notification = FlutterLocalNotificationsPlugin();

  static init() {
    _notification.initialize(const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings()
    ));

    tz.initializeTimeZones();
  }

  static schedulenotification(String title, String body, tz.TZDateTime scheduledDateTime) async {
    var androidDetails = AndroidNotificationDetails(
      'important_notifications',
      'My Channel',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );

    var iosDetails = DarwinNotificationDetails();

    var notificationDetails =
    NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _notification.zonedSchedule(
      0,
      title,
      body,
      scheduledDateTime,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }



}