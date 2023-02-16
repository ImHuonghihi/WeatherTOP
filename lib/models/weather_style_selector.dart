import 'package:flutter/material.dart';
import 'package:weather/models/weather_style.dart';

class WeatherStyleSelector {
  static late final TimeOfDay _currentTime;
  static void initCurrentTime() {
    _currentTime = TimeOfDay.now();
  }

  static WeatherStyle selectedWeatherStyle() {
    int hour = _currentTime.hour;
    if (hour >= 4 && hour < 9) {
      return WeatherStyle.sunriseWeatherStyle();
    } else if (hour >= 9 && hour < 16) {
      return WeatherStyle.afternoonWeatherStyle();
    } else if (hour >= 16 && hour < 18) {
      return WeatherStyle.sunsetWeatherStyle();
    } else {
      return WeatherStyle.nightSkyWeatherStyle();
    }
  }
}
