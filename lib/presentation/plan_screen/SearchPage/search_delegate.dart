import 'package:flutter/material.dart';
import 'package:weather/data/plan_database.dart';
import 'package:weather/models/plan.dart';
import 'package:weather/presentation/home_screen/home_screen_cubit/home_screen_cubit.dart';
import 'package:weather/presentation/plan_screen/AddNewTask/AddNewTask.dart';
import 'package:weather/services/remote/trip_api/api.dart';
import 'package:weather/services/remote/trip_api/trip_model.dart';
import 'package:weather/services/remote/weather_api/weather_api.dart';
import 'package:weather/utils/debounce.dart';
import 'package:weather/utils/functions/capitalize.dart';
import 'package:weather/utils/functions/navigation_functions.dart';

class TripSearchDelegate extends SearchDelegate {
  // using here api to search for locations
  var tripAPI = TripAPI();
  final HomeScreenCubit homeScreenCubit;
  final PlanDatabase database;
  TripSearchDelegate({required this.homeScreenCubit, required this.database});

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
    return FutureBuilder(
      future: _search(query),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data as List<Feature>;
          data.removeWhere((element) => element.properties.name == "");
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(data[index].properties.name!),
                subtitle: Text(_kindToReadable(data[index].properties.kind)),
                onTap: () {
                  navigateTo(
                      context,
                      AddNewTask(
                        database: database,
                        plan: Plan(
                          title: "Go to ${data[index].properties.name}",
                          description: "Go to ${data[index].properties.name}",
                          date: DateTime.now().toIso8601String(),
                          time: DateTime.now().toIso8601String(),
                          category: "Travel",
                        ),
                      ));
                },
              );
            },
          );
          ;
        } else if (snapshot.hasError) {
          debugPrint(snapshot.error.toString());
          return Center(
            child: Text("Error searching for \"$query\": ${snapshot.error}"),
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
    return Debounce<Widget>(milliseconds: 1500).run(
      action: () => buildResults(context),
    );
  }

  Future<List<Feature>> _search(query) {
    // set kinds for tourist attractions
    if (query.isEmpty) {
      return tripAPI.getPlacesByRadius(
        radius: 2000,
        lat: homeScreenCubit.positionOfUser!.latitude,
        lon: homeScreenCubit.positionOfUser!.longitude,
        //kinds: kinds,
      );
    } else if (query.length > 2) {
      var future = tripAPI.getPlacesAutoSuggest(
          name: query,
          radius: 2000,
          lat: homeScreenCubit.positionOfUser!.latitude,
          lon: homeScreenCubit.positionOfUser!.longitude,
          //kinds: kinds,
          limit: 100);
      return future.then((value) {
        if (value == null) {
          return tripAPI.getPlacesByRadius(
              radius: 2000,
              lat: homeScreenCubit.positionOfUser!.latitude,
              lon: homeScreenCubit.positionOfUser!.longitude,
              kinds: _stringToKind(query));
        }
        return value;
      });
    }
    return Future.value([]);
  }

  // turn kind into readable string
  String _kindToReadable(String kindStr) {
    var kind = kindStr.split(',');
    var readable = '';
    for (var i = 0; i < kind.length; i++) {
      readable += kind[i].split("_").map((s) => s.capitalize()).join(" ");
      readable += ", ";
    }
    return readable.substring(0, readable.length - 2);
  }

  String _stringToKind(String str) {
    var kinds = str.split(',').map((s) => s.trim()).toList();
    var kindStr = '';
    for (var i = 0; i < kinds.length; i++) {
      kindStr += kinds[i].split(" ").map((s) => s.toLowerCase()).join("_");
      kindStr += ",";
    }
    return kindStr.substring(0, kindStr.length - 1);
  }
}
