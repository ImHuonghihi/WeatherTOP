import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/presentation/shared_widgets/my_text.dart';
import 'package:weather/utils/styles/cosntants.dart';
import 'package:weather/utils/styles/spaces.dart';

import '../../../utils/styles/colors.dart';

class WindHumidityContainer extends StatelessWidget {
  final uvIndex;
  final wind;
  final humidity;

  const WindHumidityContainer({
    Key? key,
    required this.uvIndex,
    required this.wind,
    required this.humidity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  CupertinoIcons.circle_fill,
                  color: Colors.amber,
                  size: 30,
                ),
                K_vSpace10,
                MyText(
                  text: 'UV Index',
                  size: fontSizeM - 2,
                ),
                MyText(
                  text: uvIndex,
                  size: fontSizeM - 2,
                  fontWeight: FontWeight.normal,
                  color: whiteColor.withOpacity(0.6),
                ),
              ],
            ),
          ),
          K_hSpace20,
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.wind,
                  color: whiteColor.withOpacity(0.6),
                  size: 30,
                ),
                K_vSpace10,
                MyText(
                  text: 'Wind',
                  size: fontSizeM - 2,
                ),
                MyText(
                  text: '$wind Km/h',
                  size: fontSizeM - 2,
                  fontWeight: FontWeight.normal,
                  color: whiteColor.withOpacity(0.6),
                ),
              ],
            ),
          ),
          K_hSpace20,
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Icon(
                        CupertinoIcons.drop_fill,
                        color: Color(0XFFCDE9FF),
                        size: 30,
                      ),
                    ),
                    Icon(
                      CupertinoIcons.drop_fill,
                      color: Color(0XFF91CFFE),
                      size: 30,
                    ),
                  ],
                ),
                K_vSpace10,
                MyText(
                  text: 'Humidity',
                  size: fontSizeM - 2,
                ),
                MyText(
                  text: '$humidity%',
                  size: fontSizeM - 2,
                  fontWeight: FontWeight.normal,
                  color: whiteColor.withOpacity(0.6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
