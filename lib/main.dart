import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:weather/models/notification_controller.dart';
import 'package:weather/models/weather_style_selector.dart';
import 'package:weather/presentation/home_screen/home_screen.dart';
import 'package:weather/presentation/notification_screen/home_screen_noti.dart';
import 'package:weather/services/local/shared_preferences.dart';
import 'package:weather/services/remote/weather_api/weather_api.dart';

import 'data/bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  WeatherStyleSelector.initCurrentTime();

  WeatherAPI.initializeAPI();

  // Initialize cho Local Notification
  await NotificationController.initializeLocalNotifications(debug: true);

  // Initialize cho Push Notification
  await NotificationController.initializeRemoteNotifications(debug: true);

  await SharedHandler.initSharedPref();
 
  Bloc.observer = MyBlocObserver();

  runApp(Phoenix(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WeatherTop',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(
        weatherStyle: WeatherStyleSelector.selectedWeatherStyle(),
      ),
    );
  }
}
