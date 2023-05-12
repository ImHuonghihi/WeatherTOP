import 'package:flutter/material.dart';
import 'package:weather/models/current_weather.dart';
import 'package:weather/presentation/home_screen/home_screen_cubit/home_screen_cubit.dart';
import 'package:weather/services/remote/weather_api/weather_api.dart';
import 'package:weather/utils/functions/toaster.dart';
import 'package:weather/utils/functions/vietnamese_fix.dart';
import 'package:weather/utils/loading.dart';

import 'manage_locations_cubit/manage_locations_cubit.dart';

class LocationSearchDelegate extends SearchDelegate {
  // using here api to search for locations
  final ManageLocationsCubit manageLocationsCubit;

  final HomeScreenCubit homeScreenCubit;

  LocationSearchDelegate(
      {required this.manageLocationsCubit, required this.homeScreenCubit});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    var pos = homeScreenCubit.positionOfUser;
    var latLngStr = pos != null ? '${pos.latitude},${pos.longitude}' : '';
    var pendingWidget = manageLocationsCubit.hereAPI
        .autosuggest(query: query, at: latLngStr)
        .then((data) => data.map((locationData) {
              var locationString = isVietnamese(locationData.title)
                  ? toNonAccentedVietnamese(locationData.title)
                  : locationData.title;
              return ListTile(
                  title: Text(locationString),
                  onTap: () {
                    showLoaderDialog(context);
                    WeatherAPI.getWeatherDataByCityName(
                            cityName: locationString.split(', ').first)
                        .then((value) {
                          if (value is CurrentWeather) {
                            manageLocationsCubit.addLocationToFavorites(value);
                            Navigator.pop(context);
                            close(context, null);
                          } else {
                            Navigator.pop(context);
                            showToastMessage('Unable to get weather data.');
                          }
                    });
                  });
            }));
    return FutureBuilder(
      future: pendingWidget,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView(
            children: (snapshot.data as Iterable<Widget>).toList(),
          );
        } else if (snapshot.hasError) {
          debugPrint('snapshot has error: ${snapshot.error}');
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          if (snapshot.connectionState != ConnectionState.waiting) {
            return const Center(
              child: Text("Unable to get data."),
            );
          }
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
