import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/data/constants.dart';
import 'package:weather/utils/styles/colors.dart';

class WeatherStyle {
  final weatherIcon;
  final weatherIconColor;
  final weatherLottie;
  final weatherLottieFitStyle;
  final colorOpacity;
  var colorOne;
  var colorTwo;

  WeatherStyle({
    required this.weatherIcon,
    required this.weatherIconColor,
    required this.weatherLottie,
    this.colorOpacity = 1.0,
    this.weatherLottieFitStyle,
    this.colorOne = blackColor,
    this.colorTwo = blackColor,
  });

  static WeatherStyle sunriseWeatherStyle() {
    return WeatherStyle(
      weatherIcon: CupertinoIcons.sunrise_fill,
      weatherIconColor: Colors.amberAccent,
      weatherLottie: sunriseLottiePath,
      weatherLottieFitStyle: BoxFit.fitHeight,
      colorOpacity: 0.5,
    );
  }

  static WeatherStyle afternoonWeatherStyle() {
    return WeatherStyle(
      weatherIcon: CupertinoIcons.sun_min_fill,
      weatherIconColor: Colors.amber,
      weatherLottie: afternoonLottiePath,
      weatherLottieFitStyle: BoxFit.fitHeight,
      colorOpacity: 0.4,
      colorOne: blueColor,
      colorTwo: blueColor,
    );
  }

  static WeatherStyle sunsetWeatherStyle() {
    return WeatherStyle(
      weatherIcon: CupertinoIcons.sunset_fill,
      weatherIconColor: const Color(0XFFEF8D8C),
      weatherLottie: sunsetLottiePath,
      colorOpacity: 0.3,
      weatherLottieFitStyle: BoxFit.fitWidth,
    );
  }

  static WeatherStyle nightSkyWeatherStyle() {
    return WeatherStyle(
      weatherIcon: CupertinoIcons.moon_stars_fill,
      weatherIconColor: whiteColor,
      weatherLottie: nightSkyLottiePath,
      weatherLottieFitStyle: BoxFit.fill,
      colorOpacity: 0.0,
      colorOne: transparentColor,
      colorTwo: blueColor,
    );
  }
}
