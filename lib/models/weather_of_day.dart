class WeatherOfDay {
  dynamic timeStamp;
  dynamic currentTemp;
  dynamic minTemp;
  dynamic maxTemp;
  dynamic feelsLikeTemp;
  dynamic humidity;
  dynamic weatherStatus;
  dynamic windSpeed;

  WeatherOfDay({
    required this.maxTemp,
    required this.currentTemp,
    required this.minTemp,
    required this.feelsLikeTemp,
    required this.humidity,
    required this.windSpeed,
    required this.timeStamp,
    required this.weatherStatus,
  });

  WeatherOfDay.setDaysListConstructor(List<dynamic> weatherOfDaysListJson,
      List<WeatherOfDay> weatherOfDaysList) {
    for (var element in weatherOfDaysListJson) {
      dynamic elementInTheMain = element['main'];
      dynamic elementInTheWeather = element['weather'];
      weatherOfDaysList.add(
        WeatherOfDay(
          maxTemp: elementInTheMain['temp_max'],
          currentTemp: elementInTheMain['temp'],
          minTemp: elementInTheMain['temp_min'],
          feelsLikeTemp: elementInTheMain['feels_like'],
          humidity: elementInTheMain['humidity'],
          windSpeed: element['wind']['speed'],
          timeStamp: element['dt'],
          weatherStatus: elementInTheWeather[0]['main'],
        ),
      );
    }
  }

  static List<WeatherOfDay> getWeatherDaysList(
      List<dynamic> weatherOfDaysListJson,
      List<WeatherOfDay> weatherOfDaysList) {
    WeatherOfDay.setDaysListConstructor(
      weatherOfDaysListJson,
      weatherOfDaysList,
    );
    return weatherOfDaysList;
  }
}
