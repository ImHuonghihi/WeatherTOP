import 'package:weather/models/current_city.dart';
import 'package:weather/models/weather_of_day.dart';

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
