class UVIndex {

  
  final double uv;
  final DateTime date;
  SunPosition? sunPosition;

  UVIndex({required this.uv, required this.date, this.sunPosition});

  factory UVIndex.fromJson(Map<String, dynamic> json) {
    return UVIndex(
      uv: _convertToDouble(json['uv']),
      date: DateTime.tryParse(json['uv_time'])!,
      sunPosition: SunPosition(
        azimuth: json['sun_position']['azimuth'],
        altitude: json['sun_position']['altitude'],
      )
    );
  }

  static _convertToDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is double) {
      return value;
    } else {
      return null;
    }
  }
}
class SunPosition {
    final double? azimuth;
    final double? altitude;
  
    SunPosition({this.azimuth, this.altitude});
}
