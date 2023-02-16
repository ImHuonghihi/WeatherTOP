import 'package:flutter/material.dart';
import 'package:weather/presentation/home_screen/home_screen_cubit/home_screen_cubit.dart';
import 'package:weather/utils/functions/restart_app.dart';
import 'package:weather/utils/functions/terminate_app.dart';

import '../../../../utils/styles/colors.dart';
import '../../../../utils/styles/cosntants.dart';
import '../../../../utils/styles/spaces.dart';
import '../../../shared_widgets/my_button.dart';
import '../../../shared_widgets/my_text.dart';

class LocationServicesNotAllowedAppAlert extends StatelessWidget {
  final HomeScreenCubit cubit;
  const LocationServicesNotAllowedAppAlert({Key? key, required this.cubit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      title: MyText(
        text: 'Permission denied',
        size: fontSizeL,
        color: Colors.red,
      ),
      content: MyText(
        color: blackColor,
        fontWeight: FontWeight.normal,
        text:
            'Please allow the app to get your location to be able to get the weather data at your location !',
        size: fontSizeM - 2,
      ),
      backgroundColor: whiteColor,
      actions: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0, left: 12.0, right: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: MyButton(
                  onPressed: () {
                    terminateApp();
                  },
                  text: 'Close App',
                  textColor: Colors.red,
                  borderRadius: 15.0,
                  height: 50.0,
                  fontWeight: FontWeight.normal,
                  fillColor: Colors.red.withOpacity(0.2),
                  textSize: fontSizeM - 1,
                ),
              ),
              K_hSpace10,
              Expanded(
                child: MyButton(
                  onPressed: () async {
                    restartApp(context);
                  },
                  text: 'Allow',
                  textColor: Colors.green,
                  borderRadius: 15.0,
                  height: 50.0,
                  fontWeight: FontWeight.normal,
                  fillColor: Colors.green.withOpacity(0.2),
                  textSize: fontSizeM - 1,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
