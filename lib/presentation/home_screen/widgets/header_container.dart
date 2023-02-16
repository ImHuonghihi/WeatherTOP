import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/presentation/shared_widgets/my_text.dart';
import 'package:weather/utils/styles/colors.dart';

import '../../../data/constants.dart';
import '../../../utils/styles/cosntants.dart';

class HeaderContainerOfTheTemp extends StatelessWidget {
  final headerAnimatedContainerHeight;
  final headerAnimatedContainerIconSize;
  final maxTemp;
  final currentTemp;
  final minTemp;
  final day;
  final currentTime;
  final weatherIcon;
  final weatherIconColor;
  const HeaderContainerOfTheTemp({
    Key? key,
    required this.maxTemp,
    required this.currentTemp,
    required this.minTemp,
    required this.currentTime,
    required this.day,
    required this.weatherIcon,
    required this.weatherIconColor,
    required this.headerAnimatedContainerHeight,
    required this.headerAnimatedContainerIconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
        height: headerAnimatedContainerHeight,
        width: double.infinity,
        color: blackColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MyText(
                text: "$currentTemp$degreeSymbol",
                size: fontSizeL * 3,
                fontWeight: FontWeight.w200,
              ),
              MyText(
                text:
                    "$maxTemp$degreeSymbol / $minTemp$degreeSymbol \n$day, $currentTime",
                size: 10.0,
              ),
              Icon(
                weatherIcon,
                color: weatherIconColor,
                size: headerAnimatedContainerIconSize,
              )
            ],
          ),
        ),
      ),
    );
  }
}
