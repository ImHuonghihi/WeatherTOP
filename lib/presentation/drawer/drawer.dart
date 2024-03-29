import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weather/presentation/drawer/widgets/Location_list_item.dart';
import 'package:weather/presentation/drawer/widgets/drawer_title.dart';
import 'package:weather/presentation/drawer/widgets/footer_row.dart';
import 'package:weather/presentation/home_screen/home_screen_cubit/home_screen_cubit.dart';
import 'package:weather/presentation/manage_locations.dart/manage_locations.dart';
import 'package:weather/presentation/notification_screen/home_screen_noti.dart';
import 'package:weather/presentation/plan_screen/home.dart';
import 'package:weather/presentation/shared_widgets/my_button.dart';
import 'package:weather/presentation/shared_widgets/my_text.dart';
import 'package:weather/services/remote/here_api/api.dart';
import 'package:weather/services/remote/here_api/api_key.dart';
import 'package:weather/utils/functions/navigation_functions.dart';
import 'package:weather/utils/loading.dart';
import 'package:weather/utils/styles/colors.dart';
import 'package:weather/utils/styles/device_dimensions.dart';
import 'package:weather/utils/styles/spaces.dart';
import '../../utils/styles/cosntants.dart';

class MyDrawer extends StatelessWidget {
  final currentLocationName;
  final currentLocationCurrentTemp;
  final HomeScreenCubit homeScreenCubit;

  const MyDrawer({
    Key? key,
    required this.homeScreenCubit,
    required this.currentLocationName,
    required this.currentLocationCurrentTemp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const divider = Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Divider(color: whiteColor, thickness: 1.0),
    );
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: const Color.fromARGB(255, 27, 32, 36),
        ),
        height: double.infinity,
        width: DeviceDimensions.getWidthOfDevice(context) * 0.8,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Icon(
                        Icons.settings_outlined,
                        color: whiteColor,
                        size: 25.00,
                      ),
                    ],
                  ),
                  K_vSpace20,
                  DrawerTitle(
                    title: 'Current location',
                    icon: Icons.star_rounded,
                    setInfo: true,
                  ),
                  K_vSpace20,
                  LocationListItem(
                    locationName: '$currentLocationName',
                    degree: '$currentLocationCurrentTemp',
                    isFavoriteItem: true,
                    color: whiteColor,
                  ),
                  K_vSpace20,
                  DrawerTitle(
                      title: 'Other locations',
                      icon: Icons.add_location_outlined),
                  K_vSpace20,
                  //List of favorites
                  setSavedLocationsOrSetNoLocationsAvailable(
                      homeScreenCubit.getSavedLocations(),
                      homeScreenCubit.getSavedTemps()),
                  K_vSpace20,
                  MyButton(
                    fillColor: whiteColor.withOpacity(0.2),
                    text: 'Manage locations',
                    height: 45.0,
                    textSize: fontSizeM - 1,
                    textColor: whiteColor.withOpacity(0.7),
                    onPressed: () {
                      navigateTo(
                          context,
                          ManageLocations(
                            homeScreenCubit: homeScreenCubit,
                          ));
                    },
                  ),
                  divider,
                  DrawerTitle(
                    title: 'Plan your trip',
                    icon: Icons.backpack_outlined,
                    onTap: () {
                      navigateTo(
                          context,
                          TaskManager(
                            homeScreenCubit: homeScreenCubit,
                          ));
                    },
                  ),
                  K_vSpace20,
                  DrawerTitle(
                    title: 'Notifications',
                    icon: Icons.notifications_active_outlined,
                    onTap: () {
                      navigateTo(
                          context,
                          NotificationSetting(
                            homeScreenCubit: homeScreenCubit,
                          ));
                    },
                  ),
                  K_vSpace20,
                  divider,
                  const FooterRow(
                      title: 'Report wrong location', icon: Icons.info_outline),
                  K_vSpace20,
                  const FooterRow(
                      title: 'Contact us', icon: Icons.headset_mic_outlined),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget setSavedLocationsOrSetNoLocationsAvailable(
      listOfLocations, listOfTemps) {
    var hereAPI = HereAPI.authenicate(hereAPIKey);
    if (listOfLocations.isEmpty) {
      return Center(
        child: MyText(
          text: '  No locations available',
          size: fontSizeM - 1,
          fontWeight: FontWeight.normal,
          color: blueColor,
        ),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: listOfLocations.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {

              showLoaderDialog(context);

              var locationName = listOfLocations[index];
              homeScreenCubit.getWeatherByCityName(locationName).then((_) {
                Navigator.pop(context);
                Navigator.pop(context);
              });
            },
            child: LocationListItem(
              locationName: listOfLocations[index],
              degree: listOfTemps[index],
              isFavoriteItem: false,
              color: whiteColor,
            ),
          );
        },
      );
    }
  }
}
