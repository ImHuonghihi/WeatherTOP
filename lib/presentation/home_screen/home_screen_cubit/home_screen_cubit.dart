import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/models/current_city.dart';
import 'package:weather/models/current_weather.dart';
import 'package:weather/models/weather_of_day.dart';
import 'package:weather/presentation/home_screen/home_screen_cubit/home_screen_states.dart';
import 'package:weather/services/remote/location_api.dart';
import 'package:weather/services/local/shared_preferences.dart';
import 'package:weather/services/remote/rss_api.dart';
import 'package:weather/utils/exstreme_weather_noti.dart';
import 'package:weather/utils/functions/number_converter.dart';
import 'package:weather/utils/functions/setRSS.dart';
import 'package:weather/utils/functions/time_converting.dart';
import 'package:weather/utils/template_noti.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import '../../../models/uv_index.dart';
import '../../../services/remote/uv_api.dart';
import '../../../services/remote/weather_api/weather_api.dart';

class HomeScreenCubit extends Cubit<HomeScreenStates> {
  HomeScreenCubit() : super(HomeScreenInitState());

  static HomeScreenCubit get(context) => BlocProvider.of(context);

  Position? positionOfUser;
  //"sliverTitle" Is the name of the current city which will be added into the sliver app bar
  static String sliverTitle = '';
  late CurrentWeather currentWeather;
  late List<UVIndex> uvIndexes;
  late List<double> windIndexes;
  late List<double> humidityIndexes;

  //We use this list to avoid the problem of late currentWeather the problem is an error occurred because the
  //currentWeather is still null when starting the app and we can  not await on initializing
  //the home screen so we set default data then it will change automatically while the right data come
  final List<WeatherOfDay> _listOfDefaults = [
    WeatherOfDay(
      maxTemp: 10,
      currentTemp: 10,
      minTemp: 10,
      feelsLikeTemp: 10,
      humidity: 10,
      windSpeed: 10,
      timeStamp: 10,
      weatherStatus: 'S',
    ),
  ];

  _setCurrentWeatherDefault() {
    return currentWeather = CurrentWeather(
      weatherOfDaysList: _listOfDefaults,
      currentCountryDetails: CurrentCountryDetails(
        currentCountry: 'E',
        currentCity: 'E',
        currentLat: 2,
        currentLon: 10,
        currentSunRise: 10,
        currentSunSet: 10,
      ),
    );
  }

  _setChartDefault() {
    uvIndexes = [];
    windIndexes = [];
    humidityIndexes = [];
    // loop through the list of defaults and add the default data to the chart
    for (int i = 0; i < 6; i++) {
      uvIndexes.add(UVIndex(
        uv: 0,
        date: DateTime.now().add(Duration(days: i)),
      ));
      windIndexes.add(0);
      humidityIndexes.add(0);
    }
  }

  _defaultPref() {
    if (SharedHandler.getSharedPref(SharedHandler.rssValueKey) is Bool) {
      SharedHandler.setSharedPref(
        SharedHandler.rssValueKey,
        'vnexpress',
      );
    }
    if (SharedHandler.getSharedPref(SharedHandler.rssIntervalKey) is Bool) {
      SharedHandler.setSharedPref(
        SharedHandler.rssIntervalKey,
        1,
      );
    }
    if (SharedHandler.getSharedPref(SharedHandler.timeNotificationKey)
        is Bool || !(SharedHandler.getSharedPref(SharedHandler.timeNotificationKey) as String).isValidDate()) {
      SharedHandler.setSharedPref(
        SharedHandler.timeNotificationKey,
        DateTime.now().toString(),
      );
    }
  }

  initServices() async {
    //fill the currentWeather with dummy data until the true data come
    _setCurrentWeatherDefault();
    _setChartDefault();
    _defaultPref();
    await _initLocationService();

    await UVAPI.initializeUVAPI();
    if (positionOfUser != null) {
      await _getWeatherApiData();
    }
    _initNotification();
    initWarningNotification();
    
  }

  _setPosition() async {
    positionOfUser = await LocationAPI.getPosition();//get the position of the user
  }

  _initLocationService() async {
    int locationCheckingResult = await LocationAPI.getLocation();//check if the location service is enabled or not
    if (locationCheckingResult == LocationAPI.locationServiceIsDisabled) {//if the location service is disabled
      emit(LocationServicesDisabledState());
      debugPrint('Dis');
    } else if (locationCheckingResult == LocationAPI.deniedPermission) {
      emit(DeniedPermissionState());
      debugPrint('Den');
    } else {
      emit(LoadingGettingPositionState());
      await _setPosition();
      emit(LocationSuccessfullySetState());
      debugPrint('Done');
    }
  }

  initWeatherNotification() async {
    // Trong hàm này, đầu tiên, biến timeSet được khởi tạo bằng cách lấy giá trị từ Shared Preferences 
    //thông qua phương thức getSharedPref() của lớp SharedHandler. Nếu giá trị trả về là false, 
    //timeSet sẽ được gán bằng chuỗi rỗng, ngược lại thì giá trị được lấy từ Shared Preferences 
    //sẽ được gán cho timeSet
    String timeSet =
        SharedHandler.getSharedPref(SharedHandler.timeNotificationKey) == false
            ? ""
            : SharedHandler.getSharedPref(SharedHandler.timeNotificationKey);
    // Biến scheduledDate được khởi tạo bằng cách kiểm tra xem timeSet có rỗng hay không.
    //  Nếu rỗng thì scheduledDate sẽ được gán bằng null, ngược lại thì scheduledDate sẽ được gán bằng 
    //  giá trị của timeSet
    DateTime? scheduledDate = timeSet == "" ? null : DateTime.parse(timeSet);

    createNotification(
        id: 10,
        title: currentWeather.currentCountryDetails!.currentCity +
            Emojis.wheater_thermometer +
            Emojis.sky_cloud_with_snow,
        body:
            '${currentWeather.weatherOfDaysList[0].currentTemp}°C/${currentWeather.weatherOfDaysList[0].feelsLikeTemp}°C . ${currentWeather.weatherOfDaysList[0].weatherStatus}',
        bigPicture:
            "https://www.vietnamonline.com/media/cache/7e/e6/7ee69ffc1c68e13fe33645f21434984a.jpg",
        schedule: scheduledDate == null
            ? null
            : NotificationCalendar(
                hour: scheduledDate.hour,
                minute: scheduledDate.minute,
                second: scheduledDate.second,
                repeats: true,
              ));
  }

  _initNotification() async {
    debugPrint('initNotification');
    initWeatherNotification();
  }

  initWarningNotification() async {
    if (SharedHandler.getSharedPref(
            SharedHandler.extremeWeatherNotificationKey) ==
        true) {
      createExstremeWeatherNoti(currentWeather);
    } else {
      AwesomeNotifications().cancel(11);
    }
  }


  _locationListener() async {
    late StreamSubscription streamSubscription;
    Stream stream = Geolocator.getServiceStatusStream();
    streamSubscription = stream.listen((event) async {
      //emit loading state while getting the permission or the position
      emit(LoadingSettingLocationState());
      if (event == ServiceStatus.enabled) {
        await initServices();
      } else {
        emit(LocationServicesDisabledState());
      }
      //To close the stream
      streamSubscription.cancel();
    });
  }

  openLocationSettingsAndRetry() async {
    bool isLocationOpened = await LocationAPI.isLocationServiceEnabled();
    await _locationListener();
    if (!isLocationOpened) {
      await LocationAPI.openLocationSettings();
    }
  }

//Hàm này được sử dụng để lấy dữ liệu thời tiết từ API thông qua các phương thức được gọi 
//từ các lớp WeatherAPI và UVAPI.

// Cụ thể, hàm này bao gồm các bước sau:

// Khi hàm được gọi, nó sẽ phát ra một sự kiện (event) LoadingDataFromWeatherAPIState()
//thông qua phương thức emit(). Sự kiện này sẽ được Bloc lắng nghe để cập nhật trạng thái (state) của ứng dụng.

// Hàm tiếp tục bằng việc lấy vị trí hiện tại của người dùng thông qua biến positionOfUser.

// Sau đó, hàm gọi phương thức getWeatherData() từ lớp WeatherAPI để lấy dữ liệu thời tiết hiện tại.

// Tiếp theo, hàm lấy danh sách các chỉ số gió và độ ẩm từ dữ liệu thời tiết và lưu chúng vào
//các biến windIndexes và humidityIndexes.

// Hàm cũng lưu tên của thành phố hiện tại vào biến sliverTitle.

// Sau đó, hàm gọi phương thức getUVData() từ lớp UVAPI để lấy chỉ số UV.

// Cuối cùng, hàm phát ra một sự kiện SuccessfullyLoadedDataFromWeatherAPIState()
//thông qua phương thức emit(). Nếu có lỗi xảy ra trong quá trình lấy dữ liệu, hàm sẽ phát
//ra sự kiện FailedToLoadDataFromWeatherAPIState() và ném ra ngoại lệ để xử lý lỗi.

// Với việc sử dụng Future và async/await, hàm này sẽ chạy bất đồng bộ và không làm
//đóng băng giao diện người dùng trong quá trình lấy dữ liệu từ API

  Future<void> _getWeatherApiData() async {
    emit(LoadingDataFromWeatherAPIState());
    try {
      var lat = positionOfUser!.latitude;//lấy vị trí hiện tại của người dùng
      var lon = positionOfUser!.longitude;
      currentWeather = await WeatherAPI.getWeatherData(lat: lat, lon: lon);//lấy dữ liệu thời tiết hiện tại
      windIndexes = currentWeather.weatherOfDaysList
          .map((e) => convertNumber<double>(e.windSpeed))
          .toList();//lấy danh sách các chỉ số gió và độ ẩm từ dữ liệu thời tiết
      humidityIndexes = currentWeather.weatherOfDaysList
          .map((e) => convertNumber<double>(e.humidity))
          .toList();//
      sliverTitle = currentWeather.currentCountryDetails!.currentCity;//lưu tên của thành phố hiện tại vào biến sliverTitle
      // uvIndexes = await UVAPI.getUVData(lat: lat, lon: lon);
      uvIndexes = await UVAPI.getUVData();//lấy chỉ số UV
      emit(SuccessfullyLoadedDataFromWeatherAPIState());
    } catch (e) {
      debugPrint("GetWeatherAPI:$e");//nếu có lỗi xảy ra trong quá trình lấy dữ liệu, hàm sẽ phát ra sự kiện FailedToLoadDataFromWeatherAPIState() và ném ra ngoại lệ để xử lý lỗi.
      emit(FailedToLoadDataFromWeatherAPIState());
      rethrow;
    }
  }

  getSavedLocations() {//lấy danh sách các địa điểm đã lưu
    return SharedHandler.getListFromSharedPref(//lấy danh sách các địa điểm đã lưu
      SharedHandler.favoriteLocationsListKey,
    );
  }

  getSavedTemps() {
    return SharedHandler.getListFromSharedPref(
        SharedHandler.favoriteLocationsTempListKey);
  }

//sử dụng để lấy dữ liệu thời tiết từ API và cập nhật trạng thái của ứng dụng. Cụ thể, 
//phương thức này có các bước như sau:

// Phương thức bắt đầu bằng việc phát ra một trạng thái "LoadingDataFromWeatherAPIState"
//để hiển thị cho người dùng biết rằng ứng dụng đang tải dữ liệu.

// Sau đó, phương thức sử dụng hàm "await" để đợi dữ liệu thời tiết được trả về từ API
//thông qua hàm "getWeatherData" trong lớp "WeatherAPI". Dữ liệu này được gán vào biến "currentWeather".

// Tiếp theo, phương thức sử dụng phương thức "map" để lấy danh sách chỉ số gió và
//độ ẩm từ danh sách dữ liệu thời tiết. Chúng được chuyển đổi thành danh sách số thực bằng
//cách sử dụng hàm "convertNumber".

// Sau đó, phương thức gán giá trị cho biến "sliverTitle" bằng tên thành phố hiện tại.

// Tiếp theo, phương thức sử dụng hàm "await" để đợi dữ liệu chỉ số tia UV được trả về
//từ API thông qua hàm "getUVData" trong lớp "UVAPI". Dữ liệu này được gán vào biến "uvIndexes".

// Cuối cùng, phương thức phát ra một trạng thái "SuccessfullyLoadedDataFromWeatherAPIState"
//để hiển thị cho người dùng biết rằng dữ liệu đã được tải thành công. Nếu có lỗi xảy ra trong
//quá trình tải dữ liệu, phương thức sẽ phát ra trạng thái "FailedToLoadDataFromWeatherAPIState"
//và ném ra ngoại lệ để thông báo cho người dùng biết rằng đã xảy ra lỗi và không thể tải dữ liệu.
  Future<void> getWeather(double lat, double lon) async {
    emit(LoadingDataFromWeatherAPIState());
    try {
      currentWeather = await WeatherAPI.getWeatherData(lat: lat, lon: lon);
      windIndexes = currentWeather.weatherOfDaysList
          .map((e) => convertNumber<double>(e.windSpeed))
          .toList();
      humidityIndexes = currentWeather.weatherOfDaysList
          .map((e) => convertNumber<double>(e.humidity))
          .toList();
      sliverTitle = currentWeather.currentCountryDetails!.currentCity;
      // uvIndexes = await UVAPI.getUVData(lat: lat, lon: lon);
      uvIndexes = await UVAPI.getUVData();
      emit(SuccessfullyLoadedDataFromWeatherAPIState());
    } catch (e) {
      debugPrint("GetWeatherAPI:$e");
      emit(FailedToLoadDataFromWeatherAPIState());
      rethrow;
    }
  }

  Future<void> getWeatherByCityName(String cityName) async {
    emit(LoadingDataFromWeatherAPIState());
    try {
      currentWeather =
          await WeatherAPI.getWeatherDataByCityName(cityName: cityName);
      windIndexes = currentWeather.weatherOfDaysList
          .map((e) => convertNumber<double>(e.windSpeed))
          .toList();
      humidityIndexes = currentWeather.weatherOfDaysList
          .map((e) => convertNumber<double>(e.humidity))
          .toList();
      sliverTitle = currentWeather.currentCountryDetails!.currentCity;
      // uvIndexes = await UVAPI.getUVData(lat: lat, lon: lon);
      uvIndexes = await UVAPI.getUVData();
      emit(SuccessfullyLoadedDataFromWeatherAPIState());
    } catch (e) {
      debugPrint("GetWeatherAPI:$e");
      emit(FailedToLoadDataFromWeatherAPIState());
      rethrow;
    }
  }
}
