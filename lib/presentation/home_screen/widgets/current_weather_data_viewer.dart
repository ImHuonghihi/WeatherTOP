import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather/models/current_weather.dart';
import 'package:weather/models/weather_of_day.dart';
import 'package:weather/models/weather_style.dart';
import 'package:weather/presentation/home_screen/widgets/content_container.dart';
import 'package:weather/presentation/home_screen/widgets/flexible_space_bar.dart';
import 'package:weather/presentation/home_screen/widgets/sunrise_sunset.dart';
import 'package:weather/presentation/home_screen/widgets/temp_forcasting_container.dart';
import 'package:weather/presentation/home_screen/widgets/weeklyContainer.dart';
import 'package:weather/presentation/home_screen/widgets/wind_humidity.dart';
import 'package:weather/utils/functions/time_converting.dart';
import 'package:weather/utils/styles/colors.dart';

import '../../../utils/styles/spaces.dart';

class CurrentWeatherDataViewer extends StatelessWidget {
  final CurrentWeather currentWeatherData;
  final ScrollController sc;
  final sliverTitle;
  final sliverAppBarColor;
  final WeatherStyle weatherStyle;
  final animatedContainerColor;
  const CurrentWeatherDataViewer({
    Key? key,
    required this.currentWeatherData,
    required this.sc,
    required this.sliverTitle,
    required this.sliverAppBarColor,
    required this.weatherStyle,
    required this.animatedContainerColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WeatherOfDay weatherOfDay = currentWeatherData.weatherOfDaysList[0];
    return NestedScrollView(
      floatHeaderSlivers: true,
      controller: sc,
      physics: const BouncingScrollPhysics(),
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverAppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: transparentColor, // status bar color
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.menu,
                    size: 25.0,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
              sliverTitle,
            ],
          ),
          leadingWidth: 0.0,
          backgroundColor: sliverAppBarColor,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          pinned: true,
          floating: true,
          expandedHeight: 280.0,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(
              top: 120.0,
              right: 20.0,
              left: 20.0,
            ),
            child: FlexibleBar(
              sliverTitle:
                  currentWeatherData.currentCountryDetails!.currentCity,
              maxTemp: weatherOfDay.maxTemp.ceil(),
              currentTemp: weatherOfDay.currentTemp.ceil(),
              minTemp: weatherOfDay.minTemp.ceil(),
              day: TimeConverting.getDayNameFromTimeStamp(
                weatherOfDay.timeStamp,
              ),
              currentTime: TimeOfDay.now().format(context),
              weatherIcon: weatherStyle.weatherIcon,
              weatherIconColor: weatherStyle.weatherIconColor,
            ),
          ),
        ),
      ],
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 50.0,
          ),
          child: Column(
            children: [
              AnimatedContentContainer(
                height: 180.0,
                contentWidget: TemperatureForecastingContainer(
                  temps: currentWeatherData.weatherOfDaysList,
                ),
                animatedContainerColor: animatedContainerColor,
              ),
              K_vSpace10,
              //Tomorrow
              AnimatedContentContainer(
                height: 250.0,
                animatedContainerColor: animatedContainerColor,
                contentWidget: WeeklyContainer(
                    forecastDays: currentWeatherData.weatherOfDaysList),
              ),
              K_vSpace10,
              //sunrise
              AnimatedContentContainer(
                height: 150.0,
                contentWidget: SunriseSunsetContainer(
                  sunriseTime: TimeConverting.getTime(currentWeatherData
                          .currentCountryDetails!.currentSunRise)
                      .format(context),
                  sunsetTime: TimeConverting.getTime(currentWeatherData
                          .currentCountryDetails!.currentSunSet)
                      .format(context),
                ),
                animatedContainerColor: animatedContainerColor,
              ),
              K_vSpace10,
              AnimatedContentContainer(
                height: 150.0,
                contentWidget: WindHumidityContainer(
                  uvIndex: 'High',
                  wind: weatherOfDay.windSpeed,
                  humidity: weatherOfDay.humidity,
                ),
                animatedContainerColor: animatedContainerColor,
              ),
              K_vSpace20,
            ],
          ),
        ),
      ),
    );
  }
}
