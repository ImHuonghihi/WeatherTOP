import 'package:weather/models/current_city.dart';
import 'package:weather/models/weather_of_day.dart';
import 'package:weather/utils/functions/number_converter.dart';

class CurrentWeather {
  List<WeatherOfDay> weatherOfDaysList = [];
  CurrentCountryDetails? currentCountryDetails;

  CurrentWeather({
    required this.weatherOfDaysList,
    required this.currentCountryDetails,
  });

  CurrentWeather.getCurrentWeatherDataConstructor(Map<dynamic, dynamic> json) {
    dynamic weatherOfDaysListJson = json['list'];
    weatherOfDaysList = WeatherOfDay.getWeatherDaysList(
      weatherOfDaysListJson,
      weatherOfDaysList,
    );
    currentCountryDetails = CurrentCountryDetails.fromApi(json['city']);
  }
}


class CurrentLocationWeather {
  late final Coordinate coord;
  late final List<Weather> weather;
  late final String base;
  late final Main main;
  late final int visibility;
  late final Wind wind;
  late final Clouds clouds;
  late final int dt;
  late final Sys sys;
  late final int timezone;
  late final int id;
  late final String name;
  late final int cod;

  CurrentLocationWeather(
      {required this.coord,
      required this.weather,
      required this.base,
      required this.main,
      required this.visibility,
      required this.wind,
      required this.clouds,
      required this.dt,
      required this.sys,
      required this.timezone,
      required this.id,
      required this.name,
      required this.cod});

  CurrentLocationWeather.fromJson(Map<String, dynamic> json) {
    coord = (json['coord'] != null ? Coordinate.fromJson(json['coord']) : null)!;
    if (json['weather'] != null) {
      weather = <Weather>[];
      json['weather'].forEach((v) {
        weather.add(Weather.fromJson(v));
      });
    }
    base = json['base'];
    main = (json['main'] != null ? Main.fromJson(json['main']) : null)!;
    visibility = json['visibility'];
    wind = (json['wind'] != null ? Wind.fromJson(json['wind']) : null)!;
    clouds = (json['clouds'] != null ? Clouds.fromJson(json['clouds']) : null)!;
    dt = json['dt'];
    sys = (json['sys'] != null ? Sys.fromJson(json['sys']) : null)!;
    timezone = json['timezone'];
    id = json['id'];
    name = json['name'];
    cod = json['cod'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['coord'] = coord.toJson();
    data['weather'] = weather.map((v) => v.toJson()).toList();
    data['base'] = base;
    data['main'] = main.toJson();
    data['visibility'] = visibility;
    data['wind'] = wind.toJson();
    data['clouds'] = clouds.toJson();
    data['dt'] = dt;
    data['sys'] = sys.toJson();
    data['timezone'] = timezone;
    data['id'] = id;
    data['name'] = name;
    data['cod'] = cod;
    return data;
  }
}

class Coordinate {
  late double lon;
  late double lat;

  Coordinate({required this.lon, required this.lat});

  Coordinate.fromJson(Map<String, dynamic> json) {
    lon = json['lon'];
    lat = json['lat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lon'] = lon;
    data['lat'] = lat;
    return data;
  }
}

class Weather {
  late int id;
  late String main;
  late String description;
  late String icon;

  Weather({required this.id, required this.main, required this.description, required this.icon});

  Weather.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    main = json['main'];
    description = json['description'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['main'] = main;
    data['description'] = description;
    data['icon'] = icon;
    return data;
  }
}

class Main {
  late double temp;
  late double feelsLike;
  late double tempMin;
  late double tempMax;
  late int pressure;
  late int humidity;

  Main(
      {required this.temp,
      required this.feelsLike,
      required this.tempMin,
      required this.tempMax,
      required this.pressure,
      required this.humidity});

  Main.fromJson(Map<String, dynamic> json) {
    temp = convertNumber<double>(json['temp']);
    feelsLike = convertNumber<double>(json['feels_like']);
    tempMin = convertNumber<double>(json['temp_min']);
    tempMax = convertNumber<double>(json['temp_max']);
    pressure = json['pressure'];
    humidity = json['humidity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['temp'] = temp;
    data['feels_like'] = feelsLike;
    data['temp_min'] = tempMin;
    data['temp_max'] = tempMax;
    data['pressure'] = pressure;
    data['humidity'] = humidity;
    return data;
  }
}

class Wind {
  late double speed;
  late int deg;

  Wind({required this.speed, required this.deg});

  Wind.fromJson(Map<String, dynamic> json) {
    speed = json['speed'];
    deg = json['deg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['speed'] = speed;
    data['deg'] = deg;
    return data;
  }
}

class Clouds {
  late int all;

  Clouds({required this.all});

  Clouds.fromJson(Map<String, dynamic> json) {
    all = json['all'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['all'] = all;
    return data;
  }
}

class Sys {
  late int type;
  late int id;
  late String country;
  late int sunrise;
  late int sunset;

  Sys({required this.type, required this.id, required this.country, required this.sunrise, required this.sunset});

  Sys.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    country = json['country'];
    sunrise = json['sunrise'];
    sunset = json['sunset'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['id'] = id;
    data['country'] = country;
    data['sunrise'] = sunrise;
    data['sunset'] = sunset;
    return data;
  }
}




