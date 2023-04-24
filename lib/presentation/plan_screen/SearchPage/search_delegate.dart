import 'package:flutter/material.dart';
import 'package:weather/presentation/home_screen/home_screen_cubit/home_screen_cubit.dart';
import 'package:weather/services/remote/trip_api/api.dart';
import 'package:weather/services/remote/weather_api/weather_api.dart';

class TripSearchDelegate extends SearchDelegate {
  // using here api to search for locations

  var data = [];

  final HomeScreenCubit homeScreenCubit;

  TripSearchDelegate({required this.homeScreenCubit});

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
    var tripAPI = TripAPI();

    return FutureBuilder(
      future: tripAPI.getPlacesAutoSuggest(
          name: query,
          radius: 1000,
          lat: homeScreenCubit.positionOfUser!.latitude,
          lon: homeScreenCubit.positionOfUser!.longitude,
          limit: 10),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          data = snapshot.data as List;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(data[index]["name"]!),
                onTap: () {
                  close(context, null);
                },
              );
            },
          );
          ;
        } else if (snapshot.hasError) {
          debugPrint(snapshot.error.toString());
          return Center(
            child: Text("Error searching for \"$query\""),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text("Search for a location"),
      );
    }
    return buildResults(context);
  }
}
