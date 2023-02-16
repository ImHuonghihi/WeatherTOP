import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/models/weather_style.dart';
import 'package:weather/presentation/home_screen/home_screen_cubit/home_screen_cubit.dart';
import 'package:weather/presentation/home_screen/home_screen_cubit/home_screen_states.dart';
import 'package:weather/presentation/home_screen/widgets/alert_dialogs/show_location_services_disabled_dialog.dart';
import 'package:weather/presentation/home_screen/widgets/current_weather_data_viewer.dart';
import 'package:weather/presentation/home_screen/widgets/header_container.dart';
import 'package:weather/presentation/home_screen/widgets/sliver_title_widget.dart';
import 'package:weather/presentation/shared_widgets/my_button.dart';
import 'package:weather/presentation/shared_widgets/my_text.dart';
import 'package:weather/presentation/shared_widgets_constant/progress_indicatior.dart';
import 'package:weather/utils/functions/restart_app.dart';
import 'package:weather/utils/functions/time_converting.dart';
import 'package:weather/utils/styles/colors.dart';
import 'package:weather/utils/styles/cosntants.dart';
import 'package:weather/utils/styles/device_dimensions.dart';
import 'package:weather/utils/styles/spaces.dart';

import '../drawer/drawer.dart';

class HomeScreen extends StatefulWidget {
  final WeatherStyle weatherStyle;
  const HomeScreen({Key? key, required this.weatherStyle}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController sc = ScrollController();
  late Color color1; //Animated Color1 Background
  late Color color2; //Animated Color2 Background
  Color sliverAppBarColor = transparentColor;
  Color animatedContainerColor = whiteColor;
  String sliverAppBarTitle = '';
  double scrollOffset = 0.0;
  double headerAnimatedContainerHeight = 0.0;
  double headerAnimatedContainerIconSize = 0.0;
  //This boolean will make us avoid creating the same dialog again as we will use stream to listen on the location service
  bool dialogIsShown = false;
  Widget sliverTitle = MyText(
    text: HomeScreenCubit.sliverTitle,
    size: 1.0,
  );

  //Used in the home screen
  void setAnimatedContentContainerColor() {
    animatedContainerColor = const Color(0XFF646464);
  }

  void resetAnimatedContentContainerColor() {
    animatedContainerColor = whiteColor;
  }

  void setHeightAndIconSize() {
    headerAnimatedContainerHeight = 120.0;
    headerAnimatedContainerIconSize = 70.0;
  }

  void resetHeightAndIconSize() {
    headerAnimatedContainerHeight = 0.0;
    headerAnimatedContainerIconSize = 0.0;
  }

  void handleWhileScrollingDown() {
    color1 = blackColor;
    color2 = blackColor;

    sliverTitle = setSliverTitle();
    sliverAppBarColor = blackColor;
    setAnimatedContentContainerColor();
    setHeightAndIconSize();
  }

  void handleWhileScrollingUp() {
    color1 = widget.weatherStyle.colorOne
        .withOpacity(widget.weatherStyle.colorOpacity);
    color2 = widget.weatherStyle.colorTwo;

    sliverTitle = removeSliverTitle();
    sliverAppBarColor = transparentColor;
    resetAnimatedContentContainerColor();
    resetHeightAndIconSize();
  }

  Widget removeSliverTitle() {
    return MyText(text: "", size: 1.0);
  }

  Widget setSliverTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: FadeInUp(
        duration: const Duration(milliseconds: 500),
        child: SliverTitleWidget(
          locationName: HomeScreenCubit.sliverTitle,
        ),
      ),
    );
  }

  @override
  void initState() {
    color1 = widget.weatherStyle.colorOne
        .withOpacity(widget.weatherStyle.colorOpacity);
    color2 = widget.weatherStyle.colorTwo;

    sc.addListener(() {
      scrollOffset = sc.offset;
      if (scrollOffset > 180) {
        handleWhileScrollingDown();
      } else {
        handleWhileScrollingUp();
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeScreenCubit()..initServices(),
      child: BlocConsumer<HomeScreenCubit, HomeScreenStates>(
        listener: (listenerContext, state) {
          if (state is LocationServicesDisabledState && !dialogIsShown ||
              state is DeniedPermissionState && !dialogIsShown) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                dialogIsShown = true;
                return WillPopScope(
                  onWillPop: () async => false,
                  child: ShowLocationServicesDisabledDialog(
                    cubit: HomeScreenCubit.get(listenerContext),
                  ),
                );
              },
            );
          }
        },
        builder: (context, state) {
          HomeScreenCubit homeScreenCubit = HomeScreenCubit.get(context);
          return Scaffold(
            drawer: MyDrawer(
              homeScreenCubit: homeScreenCubit,
              currentLocationName: homeScreenCubit
                  .currentWeather.currentCountryDetails!.currentCity,
              currentLocationCurrentTemp: homeScreenCubit
                  .currentWeather.weatherOfDaysList[0].currentTemp
                  .ceil(),
            ),
            body: Stack(
              children: [
                FadeIn(
                  duration: const Duration(seconds: 3),
                  child: LottieBuilder.asset(
                    widget.weatherStyle.weatherLottie,
                    fit: widget.weatherStyle.weatherLottieFitStyle,
                    width: DeviceDimensions.getWidthOfDevice(context),
                    height: DeviceDimensions.getHeightOfDevice(context),
                  ),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 0.0,
                    sigmaY: 0.0,
                  ),
                  child: AnimatedContainer(
                    height: double.infinity,
                    duration: const Duration(milliseconds: 500),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color1, color2],
                        stops: const [0.25, 0.9],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                ConditionalBuilder(
                  condition: state is LoadingSettingLocationState,
                  builder: (context) => const MainProgressIndicator(
                      loadingMessage:
                          "We're trying to get your current location..."),
                  fallback: (context) => ConditionalBuilder(
                    condition: state is LoadingDataFromWeatherAPIState,
                    builder: (context) => const MainProgressIndicator(
                      loadingMessage: "Getting weather data...",
                    ),
                    fallback: (context) => ConditionalBuilder(
                      condition:
                          state is SuccessfullyLoadedDataFromWeatherAPIState,
                      builder: (context) => FadeIn(
                        duration: const Duration(seconds: 2),
                        child: CurrentWeatherDataViewer(
                          currentWeatherData: homeScreenCubit.currentWeather,
                          sc: sc,
                          sliverTitle: sliverTitle,
                          sliverAppBarColor: sliverAppBarColor,
                          weatherStyle: widget.weatherStyle,
                          animatedContainerColor: animatedContainerColor,
                        ),
                      ),
                      fallback: (context) => ConditionalBuilder(
                        condition: state is FailedToLoadDataFromWeatherAPIState,
                        builder: (context) => BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                          child: Container(
                            color: blackColor.withOpacity(0.5),
                            height: double.infinity,
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MyText(
                                  textAlign: TextAlign.center,
                                  text:
                                      "Unfortunately\nWe couldn't get weather data !",
                                  size: fontSizeM,
                                  fontWeight: FontWeight.normal,
                                ),
                                K_vSpace20,
                                K_vSpace20,
                                MyButton(
                                  buttonWidth: 130.0,
                                  fillColor: whiteColor.withOpacity(0.2),
                                  text: 'Try again',
                                  height: 50.0,
                                  borderRadius: radius - 5,
                                  textSize: fontSizeM,
                                  onPressed: () {
                                    restartApp(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        fallback: (context) => const MainProgressIndicator(
                          loadingMessage:
                              "We're trying to get your current location...",
                        ),
                      ),
                    ),
                  ),
                ),
                //The header container of the temp
                HeaderContainerOfTheTemp(
                  headerAnimatedContainerHeight: headerAnimatedContainerHeight,
                  headerAnimatedContainerIconSize:
                      headerAnimatedContainerIconSize,
                  currentTemp: homeScreenCubit
                      .currentWeather.weatherOfDaysList[0].currentTemp
                      .ceil(),
                  currentTime: TimeOfDay.now().format(context),
                  day: TimeConverting.getDayNameFromTimeStamp(homeScreenCubit
                      .currentWeather.weatherOfDaysList[0].timeStamp),
                  maxTemp: homeScreenCubit
                      .currentWeather.weatherOfDaysList[0].maxTemp
                      .ceil(),
                  minTemp: homeScreenCubit
                      .currentWeather.weatherOfDaysList[0].minTemp
                      .ceil(),
                  weatherIcon: widget.weatherStyle.weatherIcon,
                  weatherIconColor: widget.weatherStyle.weatherIconColor,
                )
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    sc.dispose();
    super.dispose();
  }
}

List<String> days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
