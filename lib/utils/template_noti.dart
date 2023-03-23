import 'package:awesome_notifications/awesome_notifications.dart';

createNotification({
  required String title,
  required String body,
  String? bigPicture,
  NotificationSchedule? schedule,
}) {
  AwesomeNotifications().createNotification(
      content: NotificationContent(
        channelKey: 'alerts',
        id: 10,
        title: title,
        bigPicture: bigPicture,
        notificationLayout: NotificationLayout.BigPicture,
        body: body,
      ),
      schedule: schedule);
}
