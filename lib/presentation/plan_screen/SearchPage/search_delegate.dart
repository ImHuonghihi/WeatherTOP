import 'package:flutter/material.dart';
import 'package:weather/presentation/home_screen/home_screen_cubit/home_screen_cubit.dart';
import 'package:weather/services/remote/weather_api/weather_api.dart';

class TripSearchDelegate extends SearchDelegate {
  // using here api to search for locations

  var fakeData = [{"name": "Cairo"}, {"name": "Alexandria"}, {"name": "Giza"}];

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
    return ListView.builder(
      itemCount: fakeData.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(fakeData[index]["name"]!),
          onTap: () {
            close(context, null);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
