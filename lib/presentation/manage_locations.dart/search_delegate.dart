import 'package:flutter/material.dart';
import 'package:weather/presentation/home_screen/home_screen_cubit/home_screen_cubit.dart';
import 'package:weather/services/remote/weather_api/weather_api.dart';

import 'manage_locations_cubit/manage_locations_cubit.dart';

class LocationSearchDelegate extends SearchDelegate {
  // using here api to search for locations
  final ManageLocationsCubit manageLocationsCubit;
  
  final HomeScreenCubit homeScreenCubit;

  LocationSearchDelegate({required this.manageLocationsCubit, required this.homeScreenCubit});

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
        .then((data) =>data.map((locationData) => ListTile(
              title: Text(locationData.title),
              onTap: () {
                double lat, lon;
                if (locationData.position != null) {
                  lat = locationData.position!.lat;
                  lon = locationData.position!.lng;
                  WeatherAPI.getWeatherData(lat: lat, lon: lon)
                      .then((value) =>
                          manageLocationsCubit.addLocationToFavorites(value))
                      .onError(
                          (error, stackTrace) => debugPrint(error.toString()));
                  close(context, null);
                } else {
                  manageLocationsCubit.hereAPI
                      .geocode(query: locationData.title)
                      .then((data) {
                    if (data.isNotEmpty) {
                      lat = data.first.position!.lat;
                      lon = data.first.position!.lng;
                      WeatherAPI.getWeatherData(lat: lat, lon: lon)
                          .then((value) => manageLocationsCubit
                              .addLocationToFavorites(value))
                          .onError((error, stackTrace) =>
                              debugPrint(error.toString()));
                      close(context, null);
                    }
                  });
                }   
              },
            )));
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
        } 
        else {
          if (snapshot.connectionState != ConnectionState.waiting) {
            return const Center(child: Text("Unable to get data."),);
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
