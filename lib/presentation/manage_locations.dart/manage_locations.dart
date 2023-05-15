import 'package:animate_do/animate_do.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/models/current_weather.dart';
import 'package:weather/presentation/drawer/widgets/Location_list_item.dart';
import 'package:weather/presentation/manage_locations.dart/manage_locations_cubit/manage_locations_cubit.dart';
import 'package:weather/presentation/manage_locations.dart/manage_locations_cubit/manage_locations_states.dart';
import 'package:weather/presentation/manage_locations.dart/search_delegate.dart';
import 'package:weather/presentation/shared_widgets/my_text.dart';
import 'package:weather/services/remote/weather_api/weather_api.dart';
import 'package:weather/utils/functions/navigation_functions.dart';
import 'package:weather/utils/functions/toaster.dart';
import 'package:weather/utils/loading.dart';
import 'package:weather/utils/styles/colors.dart';
import 'package:weather/utils/styles/spaces.dart';
import '../../utils/styles/cosntants.dart';
import 'package:flutter/services.dart';

import '../home_screen/home_screen_cubit/home_screen_cubit.dart';

class ManageLocations extends StatelessWidget {
  final HomeScreenCubit homeScreenCubit;
  var manageLocationsCubit;
  final textEditingController = TextEditingController();
  ManageLocations({Key? key, required this.homeScreenCubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ManageLocationsCubit()
        ..initLists(homeScreenCubit.getSavedLocations(),
            homeScreenCubit.getSavedTemps()),
      child: BlocConsumer<ManageLocationsCubit, ManageLocationsStates>(
        listener: (context, state) {
          if (state is AddLocationToFavoritesState) {
            showToastMessage(
              "Current location added To favorites",
              color: blackColor,
              textColor: Colors.amber,
            );
          }
        },
        builder: (context, state) {
          manageLocationsCubit = ManageLocationsCubit.get(context);
          return Scaffold(
            backgroundColor: whiteColor,
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: transparentColor, // status bar color
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.light,
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    addLocation(context, HomeScreenCubit.sliverTitle);
                  },
                  icon: const Icon(CupertinoIcons.star, color: blueColor),
                ),
                // search button
                IconButton(
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: LocationSearchDelegate(
                        manageLocationsCubit: manageLocationsCubit,
                        homeScreenCubit: homeScreenCubit,
                      ),
                    );
                  },
                  icon: const Icon(CupertinoIcons.search, color: blueColor),
                ),
              ],
              leading: IconButton(
                onPressed: () {
                  navigateBack(context);
                },
                icon: const Icon(CupertinoIcons.back, color: blueColor),
              ),
              backgroundColor: transparentColor,
              elevation: 0.0,
              title: MyText(
                text: 'Your Locations',
                size: fontSizeL - 2,
                fontWeight: FontWeight.normal,
                color: blueColor,
              ),
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(
                CupertinoIcons.add,
                color: whiteColor,
              ),
              onPressed: () {
                // create input dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: MyText(
                      text: "Add location",
                      size: fontSizeM + 2,
                      fontWeight: FontWeight.bold,
                      color: blackColor,
                    ),
                    content: TextField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                        hintText: "Enter location name",
                        hintStyle: TextStyle(
                          color: blackColor.withOpacity(0.4),
                          fontSize: fontSizeM,
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: MyText(
                          text: "Cancel",
                          size: fontSizeM,
                          fontWeight: FontWeight.normal,
                          color: blackColor,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (addLocation(
                              context, textEditingController.text)) {
                            Navigator.of(context).pop();
                          }
                        },
                        child: MyText(
                          text: "Add",
                          size: fontSizeM,
                          fontWeight: FontWeight.normal,
                          color: blueColor,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            body: ConditionalBuilder(
                condition: state is NoLocationsAvailableState ||
                    manageLocationsCubit.favoriteLocationsList.isEmpty,
                builder: (context) => Center(
                      child: ElasticIn(
                        duration: const Duration(milliseconds: 500),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_off_rounded,
                              size: 70.0,
                              color: blackColor.withOpacity(0.4),
                            ),
                            K_vSpace20,
                            MyText(
                              text: 'No favorite locations added',
                              size: fontSizeM - 1,
                              fontWeight: FontWeight.normal,
                              color: blackColor.withOpacity(0.4),
                            ),
                          ],
                        ),
                      ),
                    ),
                fallback: (context) => SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  CupertinoIcons.info,
                                  color: blackColor.withOpacity(0.4),
                                  size: 20.0,
                                ),
                                K_hSpace10,
                                MyText(
                                    text: 'Swipe left to perform action',
                                    size: fontSizeM - 2,
                                    fontWeight: FontWeight.normal,
                                    color: blackColor.withOpacity(0.4)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(radius),
                                  color: offWhiteColor),
                              padding: const EdgeInsets.all(10.0),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: manageLocationsCubit
                                    .favoriteLocationsList.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        right: 20.0, top: 20.0, bottom: 10.0),
                                    child: Dismissible(
                                      key: UniqueKey(),
                                      direction: DismissDirection.endToStart,
                                      confirmDismiss: (direction) async {
                                        var isDeleted = false;
                                        await showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: MyText(
                                              text: "Are you sure?",
                                              size: fontSizeM + 2,
                                              fontWeight: FontWeight.bold,
                                              color: blackColor,
                                            ),
                                            content: MyText(
                                              text:
                                                  "Do you want to load weather from this location?",
                                              size: fontSizeM,
                                              fontWeight: FontWeight.normal,
                                              color: blackColor,
                                            ),
                                            actions: [
                                              // delete button
                                              TextButton(
                                                  onPressed: () {
                                                    isDeleted = true;
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: MyText(
                                                    text: "Delete",
                                                    size: fontSizeM,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.red,
                                                  )),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: MyText(
                                                  text: "Cancel",
                                                  size: fontSizeM,
                                                  fontWeight: FontWeight.normal,
                                                  color: blackColor,
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  loadWeather(
                                                      context,
                                                      manageLocationsCubit
                                                              .favoriteLocationsList[
                                                          index]);
                                                },
                                                child: MyText(
                                                  text: "Load",
                                                  size: fontSizeM,
                                                  fontWeight: FontWeight.normal,
                                                  color: blueColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                        return isDeleted;
                                      },
                                      onDismissed: (direction) =>
                                          manageLocationsCubit
                                              .removeAtIndexFromFavorites(
                                                  index),
                                      background: Container(
                                        color: offWhiteColor,
                                      ),
                                      child: LocationListItem(
                                        isFavoriteItem: true,
                                        locationName: manageLocationsCubit
                                            .favoriteLocationsList[index],
                                        degree: manageLocationsCubit
                                            .favoriteLocationsTempsList[index],
                                        color: blackColor,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
          );
        },
      ),
    );
  }

  addLocation(BuildContext context, String locationName) {
    showLoaderDialog(context);
    WeatherAPI.getWeatherDataByCityName(
            cityName: locationName.split(', ').first)
        .then((value) {
      try {
        if (value is CurrentWeather) {
          manageLocationsCubit.addLocationToFavorites(value);
          Navigator.pop(context);
          return true;
        } else {
          Navigator.pop(context);
          showToastMessage('Unable to get weather data.');
          return false;
        }
      } catch (err) {
        showToastMessage(err.toString());
      }
    });
  }

  loadWeather(BuildContext context, String locationName) {
    showLoaderDialog(context);
    homeScreenCubit.getWeatherByCityName(locationName).then((_) {
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }
}
