import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:weather/models/weather_style_selector.dart';
import 'package:weather/services/local/shared_preferences.dart';
import 'package:weather/services/remote/weather_api/weather_api.dart';

import 'data/bloc_observer.dart';
import 'presentation/home_screen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WeatherStyleSelector.initCurrentTime();
  WeatherAPI.initializeAPI();
  await SharedHandler.initSharedPref();

  Bloc.observer = MyBlocObserver();

  runApp(Phoenix(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(
        weatherStyle: WeatherStyleSelector.selectedWeatherStyle(),
      ),
    );
  }
}
