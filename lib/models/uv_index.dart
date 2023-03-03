import 'package:weather/utils/functions/number_converter.dart';

class UVIndex {

  
  final double uv;
  final DateTime date;
  SunPosition? sunPosition;

  UVIndex({required this.uv, required this.date, this.sunPosition});

  factory UVIndex.fromJson(Map<String, dynamic> json) {
    return UVIndex(
      uv: json['uv'] is! double? convertNumber<double>(json['uv']) : json['uv'],
      date: DateTime.tryParse(json['uv_time'])!,
      sunPosition: SunPosition(
        azimuth: json['sun_position']['azimuth'],
        altitude: json['sun_position']['altitude'],
      )
    );
  }


}
class SunPosition {
    final double? azimuth;
    final double? altitude;
  
    SunPosition({this.azimuth, this.altitude});
}
