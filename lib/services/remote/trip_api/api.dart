import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weather/services/remote/trip_api/api_key.dart';
import 'package:http/http.dart';
import 'package:weather/services/remote/trip_api/trip_model.dart';

class Features {
  static const geoname = 'geoname';
  static const radius = 'radius';
  static const bbox = 'bbox';
  static const xid = 'xid';
  static const autosuggest = 'autosuggest';
}

class TripAPI {
  var lang = 'en';
  late String url;
  String feature = Features.geoname;
  String options = '';
  TripAPI() {
    url =
        "http://api.opentripmap.com/0.1/$lang/places/$feature?apikey=$tripAPIKey";
  }
  createOptions(String feature, Map<String, dynamic> options) {
    this.options = '';
    this.feature = feature;
    options.forEach((key, value) {
      this.options += '$key=$value&';
    });
    this.options = this.options.substring(0, this.options.length - 1);
    url =
        "http://api.opentripmap.com/0.1/$lang/places/${this.feature}?apikey=$tripAPIKey&${this.options}";
  }

  Future<List<TravelLocation>> getPlacesByRadius(
      {required double lat,
      required double lon,
      required double radius}) async {
    createOptions(Features.radius, {
      'lat': lat,
      'lon': lon,
      'radius': radius,
      'lang': lang,
    });
    Response response = await get(Uri.parse(url));
    return jsonDecode(response.body)
        .map((e) => TravelLocation.fromJson(e))
        .toList();
  }

  Future<List<TravelLocation>> getPlacesByBBox({
    required double minLat,
    required double minLon,
    required double maxLat,
    required double maxLon,
  }) async {
    createOptions(Features.bbox, {
      'min_lat': minLat,
      'min_lon': minLon,
      'max_lat': maxLat,
      'max_lon': maxLon,
      'lang': lang,
    });
    Response response = await get(Uri.parse(url));
    return jsonDecode(response.body)
        .map((e) => TravelLocation.fromJson(e))
        .toList();
  }

  Future<TravelLocation> getPlaceByXID({
    required String xid,
  }) async {
    createOptions(Features.xid, {
      'lang': lang,
      'xid': xid,
    });
    Response response = await get(Uri.parse(url));
    return TravelLocation.fromJson(jsonDecode(response.body));
  }

  Future<List<TravelLocation>> getPlacesByGeoname({
    required String name,
  }) async {
    createOptions(Features.geoname, {
      'lang': lang,
      'name': name,
    });
    Response response = await get(Uri.parse(url));
    return jsonDecode(response.body)
        .map((e) => TravelLocation.fromJson(e))
        .toList();
  }

  Future<List<TravelLocation>> getPlacesAutoSuggest({
    required String name,
    required double radius,
    required double lat,
    required double lon,
    required int limit,
  }) async {
    createOptions(Features.autosuggest, {
      'lang': lang,
      'name': name,
      'radius': radius,
      'lat': lat,
      'lon': lon,
      'limit': limit,
    });
    Response response = await get(Uri.parse(url));
    var json = jsonDecode(response.body);
    if (json['error'] != null) {
      throw Exception(json['error']);
    }
    var features = json['features'].map((e) => Feature.fromJson(e));
    return features.map((e) => TravelLocation.fromJson(e)).toList();
  }
}
