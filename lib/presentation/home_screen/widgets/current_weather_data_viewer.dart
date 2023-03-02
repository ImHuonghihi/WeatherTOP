import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:weather/models/current_weather.dart';
import 'package:weather/models/uv_index.dart';
import 'package:weather/models/weather_of_day.dart';
import 'package:weather/models/weather_style.dart';
import 'package:weather/presentation/home_screen/widgets/content_container.dart';
import 'package:weather/presentation/home_screen/widgets/flexible_space_bar.dart';
import 'package:weather/presentation/home_screen/widgets/sunrise_sunset.dart';
import 'package:weather/presentation/home_screen/widgets/temp_forcasting_container.dart';
import 'package:weather/presentation/home_screen/widgets/weeklyContainer.dart';
import 'package:weather/presentation/home_screen/widgets/wind_humidity.dart';
import 'package:weather/presentation/shared_widgets_constant/progress_indicatior.dart';
import 'package:weather/services/remote/quotes.dart';
import 'package:weather/services/remote/quotes_api.dart';
import 'package:weather/utils/chart/lib/flutter_chart.dart';
import 'package:weather/utils/functions/time_converting.dart';
import 'package:weather/utils/styles/colors.dart';

import '../../../utils/styles/spaces.dart';
import 'charts/chart_sliding_up_panel.dart';

class CurrentWeatherDataViewer extends StatefulWidget {
  final CurrentWeather currentWeatherData;
  final sliverTitle;
  final sliverAppBarColor;
  final WeatherStyle weatherStyle;
  final animatedContainerColor;
  final controllers;
  final ScrollController sc;
  final Quotes? quotes;

  const CurrentWeatherDataViewer({
    Key? key,
    required this.currentWeatherData,
    required this.sliverTitle,
    required this.sliverAppBarColor,
    required this.weatherStyle,
    required this.animatedContainerColor,
    required this.sc,
    required this.controllers,
    required this.quotes,
  }) : super(key: key);
  @override
  State<CurrentWeatherDataViewer> createState() =>
      _CurrentWeatherDataViewerState();
}

class _CurrentWeatherDataViewerState extends State<CurrentWeatherDataViewer> {
  @override
  Widget build(BuildContext context) {
    WeatherOfDay weatherOfDay = widget.currentWeatherData.weatherOfDaysList[0];

    return NestedScrollView(
      floatHeaderSlivers: true,
      controller: widget.sc,
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
              widget.sliverTitle,
            ],
          ),
          leadingWidth: 0.0,
          backgroundColor: widget.sliverAppBarColor,
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
            child: FutureBuilder(
                future: getQuotes(),
                builder: (context, snapshot) {
                  final quotes = snapshot.data as Quotes?;
                  return FlexibleBar(
                    sliverTitle: widget
                        .currentWeatherData.currentCountryDetails!.currentCity,
                    maxTemp: weatherOfDay.maxTemp.ceil(),
                    currentTemp: weatherOfDay.currentTemp.ceil(),
                    minTemp: weatherOfDay.minTemp.ceil(),
                    day: TimeConverting.getDayNameFromTimeStamp(
                      weatherOfDay.timeStamp,
                    ),
                    currentTime: TimeOfDay.now().format(context),
                    weatherIcon: widget.weatherStyle.weatherIcon,
                    weatherIconColor: widget.weatherStyle.weatherIconColor,
                    quotes: quotes?.content,
                  );
                }),
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
              FutureBuilder(
                  future: getQuotes(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var quote = snapshot.data;
                      return AnimatedContentContainer(
                        height: 90,
                        contentWidget: Text("$quote"),
                        animatedContainerColor: widget.animatedContainerColor,
                      );
                    } else if (snapshot.hasError) {
                      debugPrint("Quote widget: ${snapshot.error}");
                      return Container();
                    } else {
                      return const MainProgressIndicator(
                          loadingMessage: "Getting quotes of the day...");
                    }
                  }),
              AnimatedContentContainer(
                height: 180.0,
                contentWidget: TemperatureForecastingContainer(
                  temps: widget.currentWeatherData.weatherOfDaysList,
                ),
                animatedContainerColor: widget.animatedContainerColor,
              ),
              K_vSpace10,
              //Tomorrow
              AnimatedContentContainer(
                height: 250.0,
                animatedContainerColor: widget.animatedContainerColor,
                contentWidget: WeeklyContainer(
                    forecastDays: widget.currentWeatherData.weatherOfDaysList),
              ),
              K_vSpace10,
              //sunrise
              AnimatedContentContainer(
                height: 150.0,
                contentWidget: SunriseSunsetContainer(
                  sunriseTime: TimeConverting.getTime(widget.currentWeatherData
                          .currentCountryDetails!.currentSunRise)
                      .format(context),
                  sunsetTime: TimeConverting.getTime(widget.currentWeatherData
                          .currentCountryDetails!.currentSunSet)
                      .format(context),
                ),
                animatedContainerColor: widget.animatedContainerColor,
              ),
              K_vSpace10,
              AnimatedContentContainer(
                height: 150.0,
                contentWidget: WindHumidityContainer(
                  uvIndex: 'High',
                  wind: weatherOfDay.windSpeed,
                  humidity: weatherOfDay.humidity,
                  controllers: widget.controllers,
                ),
                animatedContainerColor: widget.animatedContainerColor,
              ),
              K_vSpace20,
            ],
          ),
        ),
      ),
    );
  }

  Future<Quotes?> getQuotes() async {
    Quotes? data = await Api.getQuotes();
    return data;
  }
}
