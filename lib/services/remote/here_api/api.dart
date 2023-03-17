import 'dart:convert';

import 'package:weather/services/remote/here_api/here_model.dart';
import 'package:http/http.dart' as http;

class HereAPI {
  String _apiKey;

  factory HereAPI.authenicate(String apiKey) {
    return HereAPI._(apiKey);
  }

  HereAPI._(this._apiKey);

  createParams(Uri uri,Map<String, dynamic> params) {
    params['apiKey'] = _apiKey;
    return uri.replace(queryParameters: params);
  }

  /// Geocoding location using name
  Future<List<HereLocationData>> geocode({
    required String query,
    int? limit
  }) {
    final uri = createParams(Uri.https('geocode.search.hereapi.com', '/v1/geocode'), {
      'q': query,
      'limit': limit ?? 10
    });
    return _sendRequest(uri).then((json) {
      final List<dynamic> items = json['items'];
      return items.map((item) => HereLocationData.fromJson(item)).toList();
    });
  }

  /// Reverse geocoding location using coordinates
  Future<List<HereLocationData>> reverseGeocode({
    required double lat,
    required double lng,
    int? limit
  }) {
    final uri = createParams(Uri.https('revgeocode.search.hereapi.com', '/v1/revgeocode'), {
      'at': '$lat,$lng',
      'limit': limit ?? 10
    });
    return _sendRequest(uri).then((json) {
      final List<dynamic> items = json['items'];
      return items.map((item) => HereLocationData.fromJson(item)).toList();
    });
  }

  /// autosuggest location using name
  Future<List<HereLocationData>> autosuggest({
    required String query,
    int? limit
  }) {
    final uri = createParams(Uri.https('autosuggest.search.hereapi.com', '/v1/autosuggest'), {
      'q': query,
      'limit': limit ?? 10
    });
    return _sendRequest(uri).then((json) {
      final List<dynamic> items = json['items'];
      return items.map((item) => HereLocationData.fromJson(item)).toList();
    });
  }

  /// Autocomplete location using name
  Future<List<HereLocationData>> autocomplete({
    required String query,
    int? limit
  }) {
    final uri = createParams(Uri.https('autocomplete.search.hereapi.com', '/v1/autocomplete'), {
      'q': query,
      'limit': limit ?? 10
    });
    return _sendRequest(uri).then((json) {
      final List<dynamic> items = json['items'];
      return items.map((item) => HereLocationData.fromJson(item)).toList();
    });
  }

  _sendRequest(Uri uri) async {
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}