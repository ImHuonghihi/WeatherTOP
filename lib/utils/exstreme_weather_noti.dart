//function check if the weather is extreme
import 'package:weather/models/current_weather.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

bool isExtremeWeather(CurrentWeather weather) {
  final List<String> extremeWeatherStatus = [
    'Thunderstorm',
    'Mist',
    'Smoke',
    'Haze',
    'Dust',
    'Fog',
    'Sand',
    'Ash',
    'Squall',
    'Tornado',
    'Tropical Storm',
    'Hurricane',
    'Cold',
    'Hot',
    'Windy',
    'Hail',
  ];
  final int temp = weather.weatherOfDaysList[0].currentTemp.toInt();
  final int feelsLike = weather.weatherOfDaysList[0].feelsLikeTemp.toInt();
  final int humidity = weather.weatherOfDaysList[0].humidity.toInt();
  final int windSpeed = weather.weatherOfDaysList[0].windSpeed.toInt();
  final String weatherStatus = weather.weatherOfDaysList[0].weatherStatus;
  if (temp > 12 ||
      feelsLike > 12 ||
      humidity > 80 ||
      windSpeed > 20 ||
      extremeWeatherStatus.contains(weatherStatus)) {
    return true;
  } else {
    return false;
  }
}

//function to create the exstreme weather notification
Future<void> createExstremeWeatherNoti(CurrentWeather weather) async {
  //check if the weather is extreme
  if (isExtremeWeather(weather)) {
    //create the notification
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 11,
        channelKey: 'extreme',
        title: Emojis.symbols_warning + 'WARNING!',
        body:
            "The weather currently is ${weather.weatherOfDaysList[0].weatherStatus}, ${weather.weatherOfDaysList[0].currentTemp}. Be careful when going outside!",
        notificationLayout: NotificationLayout.BigPicture,
        payload: {'data': 'my payload'},
      ),
    );
  }
}
