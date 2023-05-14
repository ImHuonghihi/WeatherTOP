import 'dart:ffi';
import 'dart:math';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:weather/presentation/notification_screen/rss.dart';
import 'package:weather/services/local/shared_preferences.dart';
import 'package:weather/services/remote/rss_api.dart';
import 'package:weather/utils/template_noti.dart';

late List<RssData> rssDataList;

setRss() async {
  if (SharedHandler.getSharedPref(SharedHandler.rssValueKey) is Bool) {
    return;
  }
  rssDataList = await RSSApi.getRSS();
  // check if news notification is enabled
  if (SharedHandler.getSharedPref(SharedHandler.newsNotificationKey) == true) {
    var randomNumber = Random().nextInt(rssDataList.length);
    createNotification(
      title: rssDataList[randomNumber].title,
      body: rssDataList[randomNumber].description,
      bigPicture: rssDataList[randomNumber].imageUrl,
    );
  }
}

initRss() async {
  await AndroidAlarmManager.periodic(
    const Duration(hours: 1),
    0,
    setRss,
    exact: true,
    wakeup: true,
  );
}
