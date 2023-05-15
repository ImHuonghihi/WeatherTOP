import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:weather/utils/functions/string_ext.dart';

class OverviewCard extends StatelessWidget {
  final String title, content;
  
  DateTime date;
  OverviewCard({Key? key, required this.title, required this.content, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(left: 0, right: 20, top: 5, bottom: 5),
      width: 180,
      height: 250,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: const Color.fromARGB(255, 159, 192, 248)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(right: 10),
                decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: const Icon(Icons.assignment, color: Colors.white),
              ),
              Text(
                title.limitLength(5),
                style: GoogleFonts.montserrat(color: Colors.white),
              ),
            ],
          ),
          Text(
            content.limitLength(30),
            style: GoogleFonts.montserrat(color: Colors.white, fontSize: 15),
          ),
          Text(
            DateFormat.MMMd().format((DateTime.now())),
            style: GoogleFonts.montserrat(color: Colors.white, fontSize: 15),
          )
        ],
      ),
    );
  }
}
