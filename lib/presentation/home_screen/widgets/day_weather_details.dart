import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/data/constants.dart';
import 'package:weather/presentation/shared_widgets/my_text.dart';
import 'package:weather/utils/styles/spaces.dart';

import '../../../utils/styles/colors.dart';
import '../../../utils/styles/cosntants.dart';

class DayWeatherDetailsContainer extends StatelessWidget {
  final day;
  final humidity;
  final minTemp;
  final maxTemp;

  const DayWeatherDetailsContainer({
    Key? key,
    required this.day,
    required this.humidity,
    required this.minTemp,
    required this.maxTemp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 90.0,
          child: MyText(
            text: "$day",
            size: fontSizeM - 2,
          ),
        ),
        SizedBox(
          width: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                CupertinoIcons.drop_fill,
                size: 15,
                color: whiteColor.withOpacity(0.6),
              ),
              MyText(
                text: "$humidity%",
                size: fontSizeM - 4,
                color: whiteColor.withOpacity(0.6),
                fontWeight: FontWeight.normal,
              ),
            ],
          ),
        ),
        SizedBox(
          width: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Icon(
                CupertinoIcons.circle_fill,
                color: Colors.amber,
                size: 20,
              ),
              K_hSpace10,
              Icon(
                CupertinoIcons.moon_fill,
                color: Colors.amber,
                size: 20,
              ),
            ],
          ),
        ),
        SizedBox(
          width: 60.0,
          child: MyText(
            fontWeight: FontWeight.normal,
            text: "$maxTemp$degreeSymbol $minTemp$degreeSymbol",
            size: fontSizeM,
          ),
        ),
      ],
    );
  }
}
