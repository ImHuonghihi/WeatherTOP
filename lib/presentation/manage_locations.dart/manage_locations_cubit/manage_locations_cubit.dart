import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/presentation/manage_locations.dart/manage_locations_cubit/manage_locations_states.dart';
import 'package:weather/services/local/shared_preferences.dart';
import 'package:weather/services/remote/here_api/api.dart';
import 'package:weather/services/remote/here_api/api_key.dart';

import '../../../models/current_weather.dart';

class ManageLocationsCubit extends Cubit<ManageLocationsStates> {
  ManageLocationsCubit() : super(ManageLocationsInitState());

  static ManageLocationsCubit get(context) => BlocProvider.of(context);

  bool isFavorite = false;
  List<String> favoriteLocationsList = [];
  List<String> favoriteLocationsTempsList = [];
  late HereAPI hereAPI;

  setLocationListValuesToString(List list) {
    for (var element in list) {
      favoriteLocationsList.add(element.toString());
    }
  }

  setTempsListValuesToString(List list) {
    for (var element in list) {
      favoriteLocationsTempsList.add(element.toString());
    }
  }

  initLists(favoriteLocationsListValue, favoriteLocationsTempsListValue) {
    setLocationListValuesToString(favoriteLocationsListValue);
    setTempsListValuesToString(favoriteLocationsTempsListValue);
    _initHereAPI();
  }

  addLocationToFavorites(CurrentWeather currentWeather) {
    isFavorite = true;
    _addLocationNameIfNotExisted(currentWeather);
    _addLocationTempIfNotExisted(currentWeather);
    emit(AddLocationToFavoritesState());
  }

  addWeatherLocationToFavorite(CurrentLocationWeather currentLocationWeather) {
    isFavorite = true;
    if (!favoriteLocationsList.contains(currentLocationWeather.name)) {
      favoriteLocationsList.add(currentLocationWeather.name);
    }
    if (!favoriteLocationsTempsList
        .contains(currentLocationWeather.main.temp.ceil().toString())) {
      favoriteLocationsTempsList
          .add(currentLocationWeather.main.temp.ceil().toString());
    }
    emit(AddLocationToFavoritesState());
  }

  _addLocationNameIfNotExisted(CurrentWeather currentWeather) {
    if (!favoriteLocationsList
        .contains(currentWeather.currentCountryDetails!.currentCity)) {
      favoriteLocationsList
          .add(currentWeather.currentCountryDetails!.currentCity);
    }
    SharedHandler.saveListInSharedPref(
        SharedHandler.favoriteLocationsListKey, favoriteLocationsList);
  }

  _addLocationTempIfNotExisted(CurrentWeather currentWeather) {
    if (!favoriteLocationsTempsList.contains(
        currentWeather.weatherOfDaysList[0].currentTemp.ceil().toString())) {
      favoriteLocationsTempsList.add(
          currentWeather.weatherOfDaysList[0].currentTemp.ceil().toString());
      SharedHandler.saveListInSharedPref(
          SharedHandler.favoriteLocationsTempListKey,
          favoriteLocationsTempsList);
    } else {
      throw Exception('Temperature info is not available. Try again later.');
    }
  }

  removeAtIndexFromFavorites(index) {
    favoriteLocationsList.removeAt(index);
    favoriteLocationsTempsList.removeAt(index);
    //Save in Shared Pref
    SharedHandler.saveListInSharedPref(
        SharedHandler.favoriteLocationsListKey, favoriteLocationsList);
    SharedHandler.saveListInSharedPref(
        SharedHandler.favoriteLocationsTempListKey, favoriteLocationsTempsList);
    if (favoriteLocationsList.isEmpty) {
      emit(NoLocationsAvailableState());
    }
  }

  _initHereAPI() {
    try {
      hereAPI = HereAPI.authenicate(hereAPIKey);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
