
//sử dụng thư vineje sliding_up_panel, lottie, conditional_builder_null_safety

import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:weather/models/notification_controller.dart';
import 'package:weather/models/weather_style.dart';
import 'package:weather/presentation/home_screen/home_screen_cubit/home_screen_cubit.dart';
import 'package:weather/presentation/home_screen/home_screen_cubit/home_screen_states.dart';
import 'package:weather/presentation/home_screen/widgets/alert_dialogs/show_location_services_disabled_dialog.dart';
import 'package:weather/presentation/home_screen/widgets/charts/chart_sliding_up_panel.dart';
import 'package:weather/presentation/home_screen/widgets/current_weather_data_viewer.dart';
import 'package:weather/presentation/home_screen/widgets/header_container.dart';
import 'package:weather/presentation/home_screen/widgets/sliver_title_widget.dart';
import 'package:weather/presentation/shared_widgets/my_button.dart';
import 'package:weather/presentation/shared_widgets/my_text.dart';
import 'package:weather/presentation/shared_widgets_constant/progress_indicatior.dart';
import 'package:weather/models/quotes.dart';
import 'package:weather/services/remote/firebase_notification/firebase_api.dart';
import 'package:weather/utils/chart/lib/flutter_chart.dart';
import 'package:weather/utils/functions/number_converter.dart';
import 'package:weather/utils/functions/restart_app.dart';
import 'package:weather/utils/functions/time_converting.dart';
import 'package:weather/utils/styles/colors.dart';
import 'package:weather/utils/styles/cosntants.dart';
import 'package:weather/utils/styles/device_dimensions.dart';
import 'package:weather/utils/styles/spaces.dart';

import '../../models/current_weather.dart';
import '../../models/uv_index.dart';
import '../drawer/drawer.dart';
import 'widgets/charts/chart_builder.dart';

class HomeScreen extends StatefulWidget {
  final WeatherStyle weatherStyle;
  const HomeScreen({Key? key, required this.weatherStyle}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final notifController = NotificationController();
  ScrollController sc = ScrollController();
  PanelController uvpc = PanelController();
  PanelController windpc = PanelController();
  PanelController humiditypc = PanelController();
  String panelTitle = 'Humidity';
  Widget panelContent = const SizedBox();
  late Color color1; //Animated Color1 Background
  late Color color2; //Animated Color2 Background
  Color sliverAppBarColor = transparentColor;
  Color animatedContainerColor = whiteColor;
  String sliverAppBarTitle = '';
  double scrollOffset = 0.0;
  double headerAnimatedContainerHeight = 0.0;
  double headerAnimatedContainerIconSize = 0.0;
  //This boolean will make us avoid creating the same dialog again as we will use stream 
  //to listen on the location service
  bool dialogIsShown = false;
  Widget sliverTitle = MyText(
    text: HomeScreenCubit.sliverTitle,
    size: 1.0,
  );

  Quotes? data;

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
    notifController.checkPermission();
    notifController.requestFirebaseToken().then((token) {
      FirebaseNotification.sendNotification(token,
        title: 'WeatherTOP', body: "You're welcome to WeatherTOP").then((status) {
          if (status) {
            print('Notification sent');
          } else {
            print('Notification failed');
          }
        });
    
    });
    
    color1 = widget.weatherStyle.colorOne
        .withOpacity(widget.weatherStyle.colorOpacity);
    color2 = widget.weatherStyle.colorTwo;

    sc.addListener(() {
      scrollOffset = sc.offset;
      if (scrollOffset > 100) {
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
    return BlocProvider(//sử dụng BlocProvider để cung cấp cho các widget con
      create: (context) => HomeScreenCubit()..initServices(), //khởi tạo cubit và gọi init để khởi tạo các dịch vụ
      child: BlocConsumer<HomeScreenCubit, HomeScreenStates>(//sử dụng BlocConsumer để lắng nghe các thay đổi của state
        listener: (listenerContext, state) {//listener sẽ được gọi mỗi khi state thay đổi
          if (state is LocationServicesDisabledState && !dialogIsShown ||
              state is DeniedPermissionState && !dialogIsShown) {//nếu state là LocationServicesDisabledState hoặc 
              //DeniedPermissionState và dialog chưa được hiển thị
            showDialog(//hiển thị dialog
              context: context,//context của widget hiện tại
              barrierDismissible: false,//không cho phép bấm ra ngoài để đóng dialog
              builder: (context) {//builder của dialog
                dialogIsShown = true;//đánh dấu dialog đã được hiển thị
                return WillPopScope(//sử dụng WillPopScope để ngăn chặn việc đóng dialog khi bấm nút back
                  onWillPop: () async => false,//không cho phép đóng dialog khi bấm nút back
                  child: ShowLocationServicesDisabledDialog(//hiển thị dialog
                    cubit: HomeScreenCubit.get(listenerContext),//truyền cubit vào dialog
                  ),
                );
              },
            );
          }
        },
        
        builder: (context, state) {//builder sẽ được gọi mỗi khi state thay đổi
          HomeScreenCubit homeScreenCubit = HomeScreenCubit.get(context);//lấy cubit
          return Scaffold(//trả về widget Scaffold
            drawer: MyDrawer(//truyền MyDrawer vào drawer
              homeScreenCubit: homeScreenCubit,//truyền cubit vào MyDrawer
              currentLocationName: homeScreenCubit
                  .currentWeather.currentCountryDetails!.currentCity,//truyền tên thành phố hiện tại vào MyDrawer
              currentLocationCurrentTemp: homeScreenCubit
                  .currentWeather.weatherOfDaysList[0].currentTemp
                  .ceil(),//truyền nhiệt độ hiện tại vào MyDrawer
            ),


            //widget cha là một Stack, 
            //được sử dụng để xếp các widget con lên nhau. 
            //Hai widget con của Stack là FadeIn và BackdropFilter. (hiệu ứng hiển thị dần và mờ dần)
            body: Stack(//
              children: [
                FadeIn(//hiệu ứng FadeIn
                  duration: const Duration(seconds: 3),//thời gian hiệu ứng
                  child: LottieBuilder.asset(//sử dụng LottieBuilder để hiển thị animation
                    widget.weatherStyle.weatherLottie,//truyền animation vào
                    fit: widget.weatherStyle.weatherLottieFitStyle,//truyền fit style vào
                    width: DeviceDimensions.getWidthOfDevice(context),//truyền chiều rộng của thiết bị vào
                    height: DeviceDimensions.getHeightOfDevice(context),//truyền chiều cao của thiết bị vào
                  ),
                ),
                BackdropFilter(//sử dụng BackdropFilter để tạo hiệu ứng blur
                  filter: ImageFilter.blur(//sử dụng ImageFilter để tạo hiệu ứng blur
                    sigmaX: 0.0,//độ mờ theo chiều ngang
                    sigmaY: 0.0,//độ mờ theo chiều dọc
                  ),
                  child: AnimatedContainer(//sử dụng AnimatedContainer để tạo hiệu ứng chuyển màu
                    height: double.infinity,//chiều cao bằng với chiều cao của thiết bị
                    duration: const Duration(milliseconds: 500),//thời gian chuyển màu
                    decoration: BoxDecoration(//decoration của AnimatedContainer
                      gradient: LinearGradient(//sử dụng LinearGradient để tạo hiệu ứng chuyển màu
                        colors: [color1, color2],
                        stops: const [0.25, 0.9],//điểm dừng của gradient
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                ConditionalBuilder(//sử dụng ConditionalBuilder để xây dựng các widget theo điều kiện
                  condition: state is LoadingSettingLocationState,
                  builder: (context) => const MainProgressIndicator(//hiển thị MainProgressIndicator
                      loadingMessage:
                          "We're trying to get your current location..."),
                  fallback: (context) => ConditionalBuilder(//nếu state không phải là LoadingSettingLocationState
                    condition: state is LoadingDataFromWeatherAPIState,//kiểm tra state có phải là LoadingDataFromWeatherAPIState
                    builder: (context) => const MainProgressIndicator(
                      loadingMessage: "Getting weather data...",
                    ),
                    fallback: (context) => ConditionalBuilder(
                      condition:
                          state is SuccessfullyLoadedDataFromWeatherAPIState,
                      builder: (context) => FadeIn(//hiệu ứng FadeIn
                        duration: const Duration(seconds: 2),
                        child: CurrentWeatherDataViewer(//hiển thị CurrentWeatherDataViewer
                          currentWeatherData: homeScreenCubit.currentWeather,//truyền currentWeather vào CurrentWeatherDataViewer
                          sc: sc,//truyền ScrollController vào CurrentWeatherDataViewer
                          sliverTitle: sliverTitle,//truyền sliverTitle vào CurrentWeatherDataViewer
                          sliverAppBarColor: sliverAppBarColor,
                          weatherStyle: widget.weatherStyle,
                          animatedContainerColor: animatedContainerColor,//truyền animatedContainerColor vào CurrentWeatherDataViewer
                          controllers: [uvpc, windpc, humiditypc],//truyền controllers vào CurrentWeatherDataViewer
                          quotes: data,//truyền quotes vào CurrentWeatherDataViewer
                        ),
                      ),
                      fallback: (context) => ConditionalBuilder(//nếu state không phải là SuccessfullyLoadedDataFromWeatherAPIState
                        condition: state is FailedToLoadDataFromWeatherAPIState,
                        builder: (context) => BackdropFilter(//
                          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),//hiệu ứng blur
                          child: Container(//Container chứa các widget con
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
                HeaderContainerOfTheTemp(//hiển thị HeaderContainerOfTheTemp
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
                ),
                // CHARTS
                ChartSlidingUpPannel(
                  title: "UV Index",
                  controller: uvpc,
                  chart: _buildUVChart(homeScreenCubit.uvIndexes),
                  otherWidgets: [
                    getUvRecommendation(
                      context,
                      homeScreenCubit.uvIndexes,
                    ),
                  ],
                ),
                ChartSlidingUpPannel(
                  title: "Wind Index",
                  controller: windpc,
                  chart: _buildWindChart(
                    homeScreenCubit.windIndexes,
                  ),
                  otherWidgets: [
                    getWindRecommendation(
                      context,
                      homeScreenCubit.windIndexes,
                    )
                  ],
                ),
                ChartSlidingUpPannel(
                  title: "Humidity Index",
                  controller: humiditypc,
                  chart: _buildHumidityChart(
                    homeScreenCubit.humidityIndexes
                ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUVChart(List<UVIndex> uvIndexes) {
    return _buildChartCurve(
      uvIndexes
          .map((e) => ChartBean(x: "${e.date.hour}h", y: e.uv * 10))
          .toList(),
      lineColor: Color.fromARGB(255, 222, 226, 111),
      shaderColors: [
        Color.fromARGB(255, 227, 210, 105).withOpacity(0.3),
        Color.fromARGB(255, 50, 232, 13).withOpacity(0.2)
      ],
    );
  }

  Widget _buildWindChart(List<double> windIndexes) {
    return _buildChartCurve(windIndexes
        .map((e) => ChartBean(x: "${windIndexes.indexOf(e) * 4}h", y: e))
        .toList());
  }

  Widget _buildHumidityChart(List<double> humidityIndexes) {
    return _buildChartCurve(humidityIndexes
        .map((e) => ChartBean(x: "${humidityIndexes.indexOf(e) * 4}h", y: e))
        .toList());
  }

  Widget _buildChartCurve(List<ChartBean> indexes,
      {lineColor, fontColor, xyColor, pressedHintLineColor, shaderColors}) {
    var chartLine = ChartLine(
      chartBeans: indexes,
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 5 * 1.6),
      isCurve: true,
      lineWidth: 4,
      lineColor: lineColor ?? Colors.blueAccent,
      fontColor: fontColor ?? Colors.white,
      xyColor: xyColor ?? Colors.white,
      shaderColors: shaderColors ??
          [
            Colors.blueAccent.withOpacity(0.3),
            Colors.blueAccent.withOpacity(0.1)
          ],
      fontSize: 12,
      yNum: 8,
      isAnimation: true,
      isReverse: false,
      isCanTouch: true,
      isShowPressedHintLine: true,
      pressedPointRadius: 4,
      pressedHintLineWidth: 0.5,
      pressedHintLineColor: pressedHintLineColor ?? Colors.white,
      duration: const Duration(milliseconds: 2000),
    );
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      semanticContainer: true,
      color: Color.fromARGB(60, 0, 0, 0).withOpacity(1),
      clipBehavior: Clip.antiAlias,
      child: chartLine,
    );
  }

  @override
  void dispose() {
    sc.dispose();
    super.dispose();
  }

  getUvRecommendation(BuildContext context, List<UVIndex> uvIndexes) {
    var dangerUV = uvIndexes.where((element) => element.uv * 10 >= 8).toList();
    if (dangerUV.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.only(top: 8),
        child: Column(
          children: [
            MyText(
              text: "Dangerous UV Index",
              size: fontSizeM,
              fontWeight: FontWeight.bold,
            ),
            K_vSpace10,
            MyText(
              text: "You should avoid going out",
              size: fontSizeM,
              fontWeight: FontWeight.normal,
            ),
          ],
        ),
      );
    } else {
      var now = DateTime.now();
      var time = "${now.hour}:${now.minute}";
      return Container(
        margin: const EdgeInsets.only(top: 8),
        child: Column(
          children: [
            MyText(
              text: "Now, $time, safe UV Index",
              size: fontSizeM,
              fontWeight: FontWeight.bold,
            ),
            K_vSpace10,
            MyText(
              text: "You can go out safely",
              size: fontSizeM,
              fontWeight: FontWeight.normal,
            ),
          ],
        ),
      );
    }
  }

  getWindRecommendation(BuildContext context, List<double> windpc) {
    var windpc = HomeScreenCubit.get(context)
        .currentWeather
        .weatherOfDaysList
        .map((e) => convertNumber<double>(e.windSpeed))
        .toList();
    var dangerWind = windpc.where((element) => element >= 8).toList();
    if (dangerWind.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.only(top: 8),
        child: Column(
          children: [
            MyText(
              text: "Dangerous Wind Index",
              size: fontSizeM,
              fontWeight: FontWeight.bold,
            ),
            K_vSpace10,
            MyText(
              text: "You should avoid going out",
              size: 9.0,
              fontWeight: FontWeight.normal,
            ),
          ],
        ),
      );
    } else {
      var now = DateTime.now();
      var time = "${now.hour}:${now.minute}";
      return Container(
        margin: const EdgeInsets.only(top: 8),
        child: Column(
          children: [
            MyText(
              text: "Now, $time, safe Wind Index",
              size: fontSizeM,
              fontWeight: FontWeight.bold,
            ),
            K_vSpace10,
            MyText(
              text: "You can go out safely",
              size: fontSizeM,
              fontWeight: FontWeight.normal,
            ),
          ],
        ),
      );
    }
  }
}

List<String> days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
