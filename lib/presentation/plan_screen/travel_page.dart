import 'package:flutter/material.dart';
import 'package:weather/services/remote/trip_api/trip_model.dart';
import 'package:weather/utils/styles/colors.dart';

class TravelPage extends StatefulWidget {
  const TravelPage({Key? key, required this.location}) : super(key: key);
  final 

  @override
  _TravelPageState createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }


  Widget buildTile({
  required String title,
  required String subtitle,
  required IconData icon,
  required Color color,
  required Function() onTap,
}) =>
    InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: whiteColor,
                  size: 30,
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: whiteColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: whiteColor,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: whiteColor,
            ),
          ],
        ),
      ),
    );

Widget buildTravelList(List<TravelLocation> travelLocations) {
  return ListView.builder(
    itemCount: travelLocations.length,
    itemBuilder: (context, index) {
      var lat_a = travelLocations[index].lat;
      var lon_b = travelLocations[index].lon;
      return buildTile(
        title: travelLocations[index].name,
        subtitle: travelLocations[index].,
        icon: Icons.location_on,
        color: Colors.white,
        onTap: () {},
      );
    },
  );
} 
}

