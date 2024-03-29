import 'dart:ffi';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather/presentation/shared_widgets/my_text.dart';
import 'package:weather/services/local/shared_preferences.dart';
import 'package:weather/utils/functions/navigation_functions.dart';
import 'package:weather/utils/functions/setRSS.dart';
import 'package:weather/utils/styles/colors.dart';
import 'package:weather/utils/styles/cosntants.dart';

import '../home_screen/home_screen_cubit/home_screen_cubit.dart';
import 'rss.dart';

class NotificationSetting extends StatefulWidget {
  HomeScreenCubit homeScreenCubit;

  NotificationSetting({Key? key, required this.homeScreenCubit})
      : super(key: key);

  @override
  _NotificationSettingState createState() => _NotificationSettingState();
}

class _NotificationSettingState extends State<NotificationSetting> {
  var scheduledDate =
      SharedHandler.getSharedPref(SharedHandler.timeNotificationKey) == false
          ? DateTime.now()
          : DateTime.parse(
              SharedHandler.getSharedPref(SharedHandler.timeNotificationKey));
  var isNotificationEnabled = true;
  var isExtremeWeatherWarningEnabled =
      SharedHandler.getSharedPref(SharedHandler.extremeWeatherNotificationKey);
  var isNewsFeedEnabled =
      SharedHandler.getSharedPref(SharedHandler.newsNotificationKey);
  var rssKey = SharedHandler.getSharedPref(SharedHandler.rssValueKey) == false
      ? 'vnexpress'
      : SharedHandler.getSharedPref(SharedHandler.rssValueKey);

  var rssInterval = SharedHandler.getSharedPref(SharedHandler.rssIntervalKey); //hours

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: transparentColor, // status bar color
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        leading: IconButton(
          onPressed: () {
            navigateBack(context);
          },
          icon: const Icon(CupertinoIcons.back, color: blueColor),
        ),
        title: MyText(
          text: 'Notification Setting',
          size: fontSizeL - 2,
          fontWeight: FontWeight.normal,
          color: blueColor,
        ),
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: whiteColor,
      ),
      backgroundColor: whiteColor,
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    //switch to enable/disable extreme weather warning
                    ListTile(
                      title: MyText(
                        text: 'Extreme weather warning',
                        size: fontSizeM,
                        fontWeight: FontWeight.normal,
                        color: blackColor,
                      ),
                      trailing: Switch(
                        value: isExtremeWeatherWarningEnabled,
                        onChanged: (value) {
                          setState(() {
                            isExtremeWeatherWarningEnabled = value;
                          });
                        },
                        activeTrackColor: blueColor,
                        activeColor: whiteColor,
                      ),
                    ),
                    ListTile(
                      title: MyText(
                        text: 'News feed',
                        size: fontSizeM,
                        fontWeight: FontWeight.normal,
                        color: blackColor,
                      ),
                      trailing: Switch(
                        value: isNewsFeedEnabled,
                        onChanged: (value) {
                          setState(() {
                            isNewsFeedEnabled = value;
                            SharedHandler.setSharedPref(
                                SharedHandler.newsNotificationKey, value);
                          });
                        },
                        activeTrackColor: blueColor,
                        activeColor: whiteColor,
                      ),
                    ),
                    //switch to enable/disable news feed
                    //RSS link
                    ListTile(
                      title: MyText(
                        text: 'RSS link',
                        size: fontSizeM,
                        fontWeight: FontWeight.normal,
                        color: blackColor,
                      ),
                      trailing: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                height: 200,
                                child: CupertinoPicker(
                                  itemExtent: 50,
                                  onSelectedItemChanged: (value) {
                                    setState(() {
                                      for (var key in newsFeedRSS.keys) {
                                        if (key == newsFeedRSS.keys.elementAt(value)) {
                                          rssKey = key;
                                          break;
                                        }
                                      }
                                    });
                                  },
                                  children: [
                                    for (var i = 0; i < newsFeedRSS.length; i++)
                                      MyText(
                                        text: newsFeedRSS.keys.elementAt(i),
                                        size: fontSizeM,
                                        fontWeight: FontWeight.normal,
                                        color: blackColor,
                                      ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: MyText(
                            text: rssKey == false ? 'Not set' : rssKey,
                            size: fontSizeM,
                            fontWeight: FontWeight.normal,
                            color: blackColor,
                          ),
                        )
                      ),
                    // RSS refreh time
                    ListTile(
                      title: MyText(
                        text: 'RSS refresh time',
                        size: fontSizeM,
                        fontWeight: FontWeight.normal,
                        color: blackColor,
                      ),
                      trailing: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                height: 200,
                                child: CupertinoPicker(
                                  itemExtent: 50,
                                  onSelectedItemChanged: (value) {
                                    setState(() {
                                      rssInterval = value + 1;
                                    });
                                  },
                                  children: [
                                    for (var i = 1; i <= 24; i++)
                                      MyText(
                                        text: '$i hours',
                                        size: fontSizeM,
                                        fontWeight: FontWeight.normal,
                                        color: blackColor,
                                      ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: MyText(
                          text: '$rssInterval hours',
                          size: fontSizeM,
                          fontWeight: FontWeight.normal,
                          color: blackColor,
                        ),
                      ),
                    ),
                    //scheduled time
                    ListTile(
                      title: MyText(
                        text: 'Scheduled time',
                        size: fontSizeM,
                        fontWeight: FontWeight.normal,
                        color: blackColor,
                      ),
                      trailing: GestureDetector(
                          onTap: () async {
                            var timeSet = (await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            ));
                            if (timeSet == null) return;
                            setState(() {
                              scheduledDate = DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                                timeSet.hour,
                                timeSet.minute,
                              );
                            });
                          },
                          child: MyText(
                            text: scheduledDate == null
                                ? 'Not set'
                                : scheduledDate.toString().substring(11, 16),
                            size: fontSizeM,
                            fontWeight: FontWeight.normal,
                            color: blackColor,
                          )),
                    ),
                    //button to set scheduled time
                    ElevatedButton(
                      onPressed: onSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: blueColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(radius),
                        ),
                      ),
                      child: MyText(
                        text: 'Save',
                        size: fontSizeM,
                        fontWeight: FontWeight.normal,
                        color: whiteColor,
                      ),
                    ),
                    //button to test notification
                  ],
                ),
              ),
            ],
          )),
    );
  }

  onSave() async {
    await AndroidAlarmManager.periodic(
      const Duration(hours: 1),
      0,
      setRss,
      exact: true,
      wakeup: true,
    );

    // reset notification
    SharedHandler.setSharedPref(
        SharedHandler.timeNotificationKey, scheduledDate.toString());
    AwesomeNotifications().cancel(10);
    widget.homeScreenCubit.initWeatherNotification();

    // reset rss
    SharedHandler.setSharedPref(SharedHandler.rssValueKey, rssKey);
    SharedHandler.setSharedPref(
        SharedHandler.rssIntervalKey, rssInterval.toString());
    await setRss();
    await initRss();

    // reset extreme weather warning
    SharedHandler.setSharedPref(SharedHandler.extremeWeatherNotificationKey,
        isExtremeWeatherWarningEnabled);
    widget.homeScreenCubit.initWarningNotification();
  }
}
