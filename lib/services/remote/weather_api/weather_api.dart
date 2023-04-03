import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../models/current_weather.dart';
import 'end_points.dart';

class WeatherAPI {
  static Dio? dio;
  static final String _baseURL = "http://api.openweathermap.org/data/2.5/";
  static const String _apiKeyValue = "180e26362853d6ee8ba73f4d0682d55f";
  static const String _apiKey = "appid";
  static const String _latKey = "lat";
  static const String _lonKey = "lon";
  static const String _unitesKey = "units";
  static const String _unitesValue = "metric";

  static initializeAPI() {
    dio = Dio(
      BaseOptions(
        baseUrl: _baseURL,
        receiveDataWhenStatusError: true,
      ),
    );
    debugPrint('API Initialized');
  }

  static Future<dynamic> getWeatherData(
      {required double lat, required double lon}) async {
    dynamic result;
    await dio!.get(
      _baseURL + EndPoints.forecast,
      queryParameters: {
        _apiKey: _apiKeyValue,
        _latKey: lat,
        _lonKey: lon,
        _unitesKey: _unitesValue,
      },
    ).then((value) {
      result = CurrentWeather.getCurrentWeatherDataConstructor(value.data);
    }).catchError((error) {
      result = false;
    });
    return result;
  }

  static Future<dynamic> getWeatherDataByCityName(
      {required String cityName}) async {
    dynamic result;
    await dio!.get(
      _baseURL + EndPoints.current,
      queryParameters: {
        _apiKey: _apiKeyValue,
        "q": cityName,
        _unitesKey: _unitesValue,
      },
    ).then((value) {
      var currentLocationData = CurrentLocationWeather.fromJson(value.data);
      var lat = currentLocationData.coord.lat;
      var lon = currentLocationData.coord.lon;
      return getWeatherData(lat: lat, lon: lon);
    }).then((value) {
      result = value;
    }).catchError((err) {
      result = false;
    });
    return result;
  }

  static Future<dynamic> getCurrentWeatherDataByCityName(
      {required String cityName}) async {
    dynamic result;
    await dio!.get(
      _baseURL + EndPoints.current,
      queryParameters: {
        _apiKey: _apiKeyValue,
        "q": cityName,
        _unitesKey: _unitesValue,
      },
    ).then((value) {
      final Map<String, dynamic> json = value.data;
      result = CurrentLocationWeather.fromJson(json);
    }).catchError((error) {
      result = false;
    });
    return result;
  }
}
