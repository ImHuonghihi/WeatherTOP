class UVIndex {

  
  final double? uv;
  final DateTime? date;
  final SunPosition sunPosition;

  UVIndex({required this.uv, required this.date, required this.sunPosition});

  factory UVIndex.fromJson(Map<String, dynamic> json) {
    return UVIndex(
      uv: json['uv'],
      date: json['uv_time'],
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
