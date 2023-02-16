import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/presentation/shared_widgets/my_text.dart';
import 'package:weather/utils/styles/cosntants.dart';

import '../../../utils/styles/spaces.dart';

class SunriseSunsetContainer extends StatelessWidget {
  final sunriseTime;
  final sunsetTime;
  const SunriseSunsetContainer({
    Key? key,
    required this.sunriseTime,
    required this.sunsetTime,
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
              children: [
                MyText(
                  text: 'Sunrise',
                  size: fontSizeM,
                  fontWeight: FontWeight.normal,
                ),
                MyText(text: sunriseTime, size: fontSizeM),
                const Icon(
                  CupertinoIcons.sunrise_fill,
                  color: Colors.amber,
                  size: 70,
                )
              ],
            ),
          ),
          K_hSpace20,
          Expanded(
            child: Column(
              children: [
                MyText(
                    text: 'Sunset',
                    size: fontSizeM,
                    fontWeight: FontWeight.normal),
                MyText(
                  text: sunsetTime,
                  size: fontSizeM,
                ),
                const Icon(
                  CupertinoIcons.sunset_fill,
                  color: Color(0XFFEF8D8C),
                  size: 70,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
