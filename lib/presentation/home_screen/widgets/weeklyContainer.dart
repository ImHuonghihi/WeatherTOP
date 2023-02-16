import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/models/weather_of_day.dart';
import 'package:weather/presentation/home_screen/widgets/day_weather_details.dart';

import '../../../data/constants.dart';
import '../../../utils/functions/time_converting.dart';
import '../../../utils/styles/colors.dart';
import '../../../utils/styles/cosntants.dart';
import '../../shared_widgets/my_text.dart';

class WeeklyContainer extends StatelessWidget {
  final List<WeatherOfDay> forecastDays;
  const WeeklyContainer({
    Key? key,
    required this.forecastDays,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            //Temp row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(
                  fontWeight: FontWeight.normal,
                  text: "Today",
                  size: fontSizeM,
                  color: whiteColor.withOpacity(0.7),
                ),
                MyText(
                  color: whiteColor.withOpacity(0.7),
                  fontWeight: FontWeight.normal,
                  text: getTodayForeCast(forecastDays),
                  size: fontSizeM,
                ),
              ],
            ),
            ListView.builder(
              itemCount: forecastDays.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                int currentDay = TimeConverting.convertToDateTime(
                        forecastDays[index].timeStamp)
                    .day;

                if (index + 1 < forecastDays.length) {
                  return setWeatherDayWidget(index, currentDay);
                } else {
                  //To set the last day as we started from index + 1 and this may cause an index outrange error
                  if (index == forecastDays.length - 1) {
                    return DayWeatherDetailsContainer(
                      day: TimeConverting.getDayNameFromTimeStamp(
                          forecastDays[index].timeStamp,
                          setFullDayName: true),
                      humidity: '${forecastDays[index].humidity}',
                      minTemp: '${forecastDays[index].minTemp.ceil()}',
                      maxTemp: '${forecastDays[index].maxTemp.ceil()}',
                    );
                  }
                  return const Center();
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget setWeatherDayWidget(int index, int currentDay) {
    if (currentDay ==
        TimeConverting.convertToDateTime(forecastDays[index + 1].timeStamp)
            .day) {
      return const Center(); //This will set to avoid repeating a day as the api returns the the same day with different times but here we only need it once
    } else {
      //Else return the day weather widget
      return DayWeatherDetailsContainer(
        day: TimeConverting.getDayNameFromTimeStamp(
            forecastDays[index].timeStamp,
            setFullDayName: true),
        humidity: '${forecastDays[index].humidity}',
        minTemp: '${forecastDays[index].minTemp.ceil()}',
        maxTemp: '${forecastDays[index].maxTemp.ceil()}',
      );
    }
  }

  String getTodayForeCast(List<WeatherOfDay> forecastDays) {
    String result = "";
    for (int i = 0; i + 1 < forecastDays.length; i++) {
      if (TimeConverting.convertToDateTime(forecastDays[i].timeStamp).day <
          TimeConverting.convertToDateTime(forecastDays[i + 1].timeStamp).day) {
        result =
            "${forecastDays[i].maxTemp.ceil()} $degreeSymbol ${forecastDays[i].minTemp.ceil()} $degreeSymbol";
        break;
      }
    }
    return result;
  }
}
