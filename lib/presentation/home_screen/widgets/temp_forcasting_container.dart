import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/data/constants.dart';
import 'package:weather/models/weather_of_day.dart';
import 'package:weather/presentation/shared_widgets/my_text.dart';
import 'package:weather/utils/functions/time_converting.dart';
import 'package:weather/utils/styles/colors.dart';

import '../../../utils/styles/cosntants.dart';
import '../../../utils/styles/spaces.dart';

class TemperatureForecastingContainer extends StatelessWidget {
  final List<WeatherOfDay> temps;
  const TemperatureForecastingContainer({
    Key? key,
    required this.temps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: 8,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                  text: TimeConverting.getTime(temps[index].timeStamp)
                      .format(context),
                  size: fontSizeM - 2,
                  fontWeight: FontWeight.normal),
              K_vSpace10,
              Icon(
                setTimeIcon(
                    TimeConverting.getTime(temps[index].timeStamp).hour),
                size: 28,
                color: setTimeIconColor(
                    TimeConverting.getTime(temps[index].timeStamp).hour),
              ),
              K_vSpace10,
              MyText(
                text: '${temps[index].currentTemp.ceil()}$degreeSymbol',
                size: fontSizeM - 2,
                fontWeight: FontWeight.normal,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 3,
                    bottom: setPadding(index),
                  ),
                  child: Transform.rotate(
                    angle: setAngle(index),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.circle,
                          color: whiteColor,
                          size: 10.0,
                        ),
                        Container(
                          color: whiteColor,
                          width: index + 1 != 8 ? 58.0 : 0.0,
                          height: 1.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(
                    CupertinoIcons.drop_fill,
                    size: 15,
                    color: whiteColor.withOpacity(0.6),
                  ),
                  MyText(
                    text: "${temps[index].humidity}%",
                    size: fontSizeM - 4,
                    color: whiteColor.withOpacity(0.6),
                    fontWeight: FontWeight.normal,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  double setAngle(int index) {
    return index + 1 < temps.length &&
            temps[index + 1].currentTemp < temps[index].currentTemp
        ? 0.022 //This means that the angle will be a little bit lower to express that the next temp will be lower than the current temp
        : index + 1 < temps.length &&
                temps[index + 1].currentTemp > temps[index].currentTemp
            ? -0.02 //This means that the angle will be a little bit higher to express that the next temp will be higher than the current temp
            : 0.0; //This means that the angle will not change to express that the next temp will be equal to the current temp
  }

  double setPadding(int index) {
    return temps[index].currentTemp < 50.0 && temps[index].currentTemp > 0.0
        ? temps[index].currentTemp
        : temps[index].currentTemp < 0.0
            ? 0.0
            : 48.0;
  }

  setTimeIcon(int hour) {
    if (hour >= 6 && hour <= 18) {
      return CupertinoIcons.sun_max_fill;
    }
    return CupertinoIcons.moon_stars_fill;
  }

  setTimeIconColor(int hour) {
    if (hour >= 6 && hour <= 18) {
      return Colors.amber;
    }
    return whiteColor;
  }
}
