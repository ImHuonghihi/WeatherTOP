import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';

createNotification({
  required String title,
  required String body,
  int? id,
  String? bigPicture,
  NotificationSchedule? schedule,
}) {
  AwesomeNotifications().createNotification(
      content: NotificationContent(
        channelKey: 'alerts',
        id: id ?? Random().nextInt(1000) + 11,
        title: title,
        bigPicture: bigPicture,
        notificationLayout: NotificationLayout.BigPicture,
        body: body,
      ),
      schedule: schedule);
}
