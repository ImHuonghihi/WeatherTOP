import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:weather/presentation/drawer/widgets/drawer_title.dart';
import 'package:weather/presentation/home_screen/home_screen_cubit/home_screen_cubit.dart';
import 'package:weather/presentation/shared_widgets/my_text.dart';
import 'package:weather/services/local/shared_preferences.dart';
import 'package:weather/utils/functions/navigation_functions.dart';
import 'package:weather/utils/styles/colors.dart';
import 'package:weather/utils/styles/cosntants.dart';
import 'package:weather/utils/styles/spaces.dart';

class NotificationSetting extends StatefulWidget {
  var homeScreenCubit;

  NotificationSetting({Key? key, required this.homeScreenCubit})
      : super(key: key);

  @override
  _NotificationSettingState createState() => _NotificationSettingState();
}

class _NotificationSettingState extends State<NotificationSetting> {
  var scheduledDate =
      SharedHandler.getSharedPref(SharedHandler.timeNotificationKey) == false
          ? null
          : DateTime.parse(
              SharedHandler.getSharedPref(SharedHandler.timeNotificationKey));
  var isNotificationEnabled = true;
  var isExtremeWeatherWarningEnabled =
      SharedHandler.getSharedPref(SharedHandler.extremeWeatherNotificationKey);
  var isNewsFeedEnabled =
      SharedHandler.getSharedPref(SharedHandler.newsNotificationKey);
  var newsFeedRSS = 'https://vnexpress.net/rss/tin-moi-nhat.rss';

  var rssInterval = 1; //hours

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
                            SharedHandler.setSharedPref(
                                SharedHandler.extremeWeatherNotificationKey,
                                value);
                          });
                        },
                        activeTrackColor: blueColor,
                        activeColor: whiteColor,
                      ),
                    ),
                    //switch to enable/disable news feed
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
                    //RSS link
                    ListTile(
                      title: MyText(
                        text: 'RSS link',
                        size: fontSizeM,
                        fontWeight: FontWeight.normal,
                        color: blackColor,
                      ),
                      trailing: MyText(
                        text: "Click to edit",
                        size: fontSizeM,
                        fontWeight: FontWeight.normal,
                        color: blackColor,
                      ),
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
                      trailing: MyText(
                        text: scheduledDate == null
                            ? 'Not set'
                            : '${scheduledDate!.hour}:${scheduledDate!.minute}',
                        size: fontSizeM,
                        fontWeight: FontWeight.normal,
                        color: blackColor,
                      ),
                    ),
                    //button to set scheduled time
                    ElevatedButton(
                      onPressed: () async {
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
                            timeSet!.hour,
                            timeSet!.minute,
                          );
                          SharedHandler.setSharedPref(
                              SharedHandler.timeNotificationKey,
                              scheduledDate.toString());
                          AwesomeNotifications().cancel(10);
                          widget.homeScreenCubit.initWeatherNotification();
                        });
                      },
                      child: MyText(
                        text: 'Set scheduled time',
                        size: fontSizeM,
                        fontWeight: FontWeight.normal,
                        color: whiteColor,
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: blueColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(radius),
                        ),
                      ),
                    ),
                    //button to test notification
                    ElevatedButton(
                      onPressed: () async {
                        if (scheduledDate == null) {
                          setState(() {
                            scheduledDate = DateTime.now();
                          });
                        }
                        AwesomeNotifications().createNotification(
                          content: NotificationContent(
                            channelKey: 'alerts',
                            id: 10,
                            title: Emojis.sky_cloud_with_snow,
                            bigPicture:
                                "https://www.vietnamonline.com/media/cache/7e/e6/7ee69ffc1c68e13fe33645f21434984a.jpg",
                            notificationLayout: NotificationLayout.BigPicture,
                            body: '0°C/0°C . -1',
                          ),
                        );
                      },
                      child: MyText(
                        text: 'Test notification',
                        size: fontSizeM,
                        fontWeight: FontWeight.normal,
                        color: whiteColor,
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: blueColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(radius),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
