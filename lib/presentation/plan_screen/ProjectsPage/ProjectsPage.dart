import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather/data/plan_database.dart';
import 'package:weather/models/plan.dart';
import 'package:weather/utils/functions/loader_future.dart';

import 'OverviewScroll.dart';
import 'ProgressCard.dart';

class ProjectsPage extends StatelessWidget {
  PlanDatabase database;

  ProjectsPage({
    Key? key, required this.database,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          color: const Color.fromRGBO(242, 244, 255, 1),
          padding: const EdgeInsets.all(0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                
            const SizedBox(
              height: 10,
            ),
            
            const Padding(
              padding:
                  EdgeInsets.only(top: 0, bottom: 0, left: 20, right: 0),
              child: OverView(),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Progress",
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  _buildScrollableList(context)
                  
                  // ProgressCard(ProjectName: "Project", CompletedPercent: 30),
                  // ProgressCard(ProjectName: "Project", CompletedPercent: 30),
                  // ProgressCard(ProjectName: "Project", CompletedPercent: 30),
                  // ProgressCard(ProjectName: "Project", CompletedPercent: 30),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }

  _buildScrollableList(BuildContext context) => Container(
        height: 200,
        child: FutureLoader.showLoadingIndicator(
          context: context,
          future: database.getPlans(),
          onSuccess: (List<Plan> plans) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: plans.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            plans[index].title,
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        plans[index].isDone ? "Completed" : "In Progress",
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          
        )
      );
}
