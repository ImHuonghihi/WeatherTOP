import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather/services/remote/trip_api/trip_model.dart';
import 'package:weather/utils/functions/calc_distance.dart';
import 'package:weather/utils/styles/colors.dart';
import 'package:geolocator/geolocator.dart';

class TravelPage extends StatefulWidget {
  const TravelPage({Key? key, required this.location}) : super(key: key);
  final Position location;

  @override
  _TravelPageState createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: transparentColor, // status bar color
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
          backgroundColor: whiteColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: blackColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Travel',
            style: TextStyle(
              color: blackColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: buildTravelList([
          TravelLocation(
            name: 'Place A',
            lat: 21.0277644,
            lon: 105.8341598,
            osm: 'node/123456',
            xid: 'Q123',
            wikidata: 'Q123',
            kind: 'tourism',
          ),
          TravelLocation(
            name: 'Place B',
            lat: 21.0277645,
            lon: 105.8341598,
            osm: 'node/123456',
            xid: 'Q123',
            wikidata: 'Q123',
            kind: 'tourism',
          ),
        ]));
  }

  Widget buildTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Function() onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: blackColor, width: 1.5),
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
                          color: blackColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: blackColor,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: blackColor,
              ),
            ],
          ),
        ),
      );

  Widget buildTravelList(List<TravelLocation> travelLocations) {
    return ListView.builder(
      itemCount: travelLocations.length,
      itemBuilder: (context, index) {
        var lat = travelLocations[index].lat;
        var lon = travelLocations[index].lon;
        var distance = calculateDistanceInMeters(
                widget.location.latitude, widget.location.longitude, lat, lon) *
            1000; // km
        return buildTile(
          title: travelLocations[index].name,
          subtitle: '${distance.toStringAsFixed(2)} km',
          icon: Icons.location_on,
          color: whiteColor,
          onTap: () {},
        );
      },
    );
  }
}
