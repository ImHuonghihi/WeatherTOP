import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../models/uv_index.dart';

class UVAPI {
  static Dio? dio;
  static const double _latKey = 0.0;
  static const double _lonKey = 0.0;
  static const String _baseURL =
      "https://api.openuv.io/api/v1/forecast";
  static const String _apiKeyValue = "180e26362853d6ee8ba73f4d0682d55f";

  static initializeAPI() {
    dio = Dio(
      BaseOptions(
        baseUrl: _baseURL,
        receiveDataWhenStatusError: true,
      ),
    );
    debugPrint('API Initialized');
  }

  static Future<List<UVIndex>> getUVData(
      {required double lat, required double lon}) async {
    return await dio!.get(
      _baseURL,
      queryParameters: {
        'lat': lat,
        'lon': lon,
      },
      options: Options(
        headers: {
          'x-access-token': _apiKeyValue,
        },
      ),
    ).asStream()
    .transform(utf8.decoder as StreamTransformer<Response, dynamic>)
    .transform(json.decoder)
    .expand((dynamic event) => event['result'] as List<dynamic>)
    .map((element) => UVIndex.fromJson(element))
    .toList();
  }
}
