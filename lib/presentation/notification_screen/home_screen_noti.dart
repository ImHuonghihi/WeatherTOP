import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:weather/presentation/drawer/widgets/drawer_title.dart';
import 'package:weather/presentation/shared_widgets/my_text.dart';
import 'package:weather/utils/functions/navigation_functions.dart';
import 'package:weather/utils/styles/colors.dart';
import 'package:weather/utils/styles/cosntants.dart';
import 'package:weather/utils/styles/spaces.dart';

class NotificationSetting extends StatefulWidget {
  const NotificationSetting({Key? key}) : super(key: key);

  @override
  _NotificationSettingState createState() => _NotificationSettingState();
}

class _NotificationSettingState extends State<NotificationSetting> {
  var scheduledDate;
  var isNotificationEnabled = true;
  var isExtremeWeatherWarningEnabled = true;
  var isNewsFeedEnabled = true;
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
        actions: [
          //switch to enable/disable notification
          Switch(
            value: isNotificationEnabled,
            onChanged: (value) {
              setState(() {
                isNotificationEnabled = value;
              });
            },
            activeTrackColor: blueColor,
            activeColor: whiteColor,
          ),
        ],
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
                            : '${scheduledDate.hour}:${scheduledDate.minute}',
                        size: fontSizeM,
                        fontWeight: FontWeight.normal,
                        color: blackColor,
                      ),
                    ),
                    //button to set scheduled time
                    ElevatedButton(
                      onPressed: () async {
                        scheduledDate = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        setState(() {});
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
                            id: 10,
                            channelKey: 'alerts',
                            title: 'Test notification',
                            body: 'This is a test notification',
                            bigPicture:
                                'https://picsum.photos/seed/picsum/200/300',
                          ),
                          schedule: NotificationCalendar(
                            hour: scheduledDate.hour,
                            minute: scheduledDate.minute,
                            second: scheduledDate.second + 5,
                            millisecond: scheduledDate.millisecond,
                            repeats: true,
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
