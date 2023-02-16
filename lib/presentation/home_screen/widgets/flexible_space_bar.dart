import 'package:flutter/material.dart';
import 'package:weather/data/constants.dart';
import 'package:weather/presentation/home_screen/widgets/sliver_title_widget.dart';
import 'package:weather/utils/styles/cosntants.dart';
import 'package:weather/utils/styles/spaces.dart';

import '../../shared_widgets/my_text.dart';

class FlexibleBar extends StatelessWidget {
  final sliverTitle;
  final maxTemp;
  final currentTemp;
  final minTemp;
  final day;
  final currentTime;
  final weatherIcon;
  final weatherIconColor;
  const FlexibleBar({
    Key? key,
    required this.sliverTitle,
    required this.maxTemp,
    required this.currentTemp,
    required this.minTemp,
    required this.day,
    required this.currentTime,
    required this.weatherIcon,
    required this.weatherIconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      titlePadding: const EdgeInsets.only(left: 0.0, top: 0.0),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SliverTitleWidget(locationName: "$sliverTitle"),
          K_vSpace10,
          MyText(
            text:
                "$maxTemp$degreeSymbol / $minTemp$degreeSymbol Feels like $maxTemp$degreeSymbol\n$day, $currentTime",
            size: 9.0,
          )
        ],
      ),
      background: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
            text: "$currentTemp$degreeSymbol",
            size: fontSizeL * 3,
            fontWeight: FontWeight.w200,
          ),
          Icon(
            weatherIcon,
            color: weatherIconColor,
            size: 70.0,
          )
        ],
      ),
    );
  }
}
