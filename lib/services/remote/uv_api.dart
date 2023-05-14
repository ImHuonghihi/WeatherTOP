import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather/utils/functions/date_compare.dart';

import '../../models/uv_index.dart';

class UVAPI {
  static late IOClient client;

  static const String _baseURL = "https://api.openuv.io/api/v1/forecast";
  static const String _apiKeyValue = "openuv-mf1pgrle2l8hme-io";
  static const String _altapiKeyValue = "openuv-g141rrlegtecc3-io";

  static initializeUVAPI() {
    var ioc = HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    client = IOClient(ioc);
    debugPrint('UV API Initialized');
  }
  

  // static Future<List<UVIndex>> getUVData(
  //     {required double lat, required double lon}) async {
  //   var uri = Uri.parse(
  //     '$_baseURL?lat=$lat&lng=$lon&dt=${DateTime.now().toIso8601String()}',
  //   );
  //   return await client.get(
  //     uri,
  //     headers: {
  //       'x-access-token': _altapiKeyValue,
  //     },
  //   ).then((res) {
  //     final value = jsonDecode(res.body);
  //     final List<dynamic> result = value['result'];
  //     return result.map((e) => UVIndex.fromJson(e)).toList();
  //   });
  // }

  static Future<List<UVIndex>> getUVData() async {
    var uri = Uri.parse(
      'https://raw.githubusercontent.com/huongpham2001/WeatherTOP/master/lib/services/remote/uv.json',
    );
    return await client.get(
      uri,
    ).then((res) {
      
      final value = jsonDecode(res.body);
      final List<dynamic> result = value['result'];
      DateTime now = DateTime.now();
      return result.map((e) => UVIndex.fromJson(e))
      .where((e) => compareDate(e.date, now, compareType: ">=", compareTarget: ['hour']) ).toList();
    });
  }
}


// read uv.json file

