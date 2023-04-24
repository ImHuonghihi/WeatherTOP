import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather/data/plan_database.dart';
import 'package:weather/models/plan.dart';
import 'package:weather/presentation/plan_screen/AddNewTask/AddNewTask.dart';
import 'package:weather/utils/functions/loader_future.dart';
import 'package:weather/utils/functions/navigation_functions.dart';

import 'OverviewScroll.dart';
import 'ProgressCard.dart';

class ProjectsPage extends StatefulWidget {
  PlanDatabase database;

  ProjectsPage({
    Key? key,
    required this.database,
  }) : super(key: key);

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  late PlanDatabase database;

  @override
  Widget build(BuildContext context) {
    database = widget.database;
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
            Padding(
              padding: EdgeInsets.only(top: 0, bottom: 0, left: 20, right: 0),
              child: OverView(
                database: database,
              ),
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
            scrollDirection: Axis.vertical,
            itemCount: plans.length,
            itemBuilder: (BuildContext context, int index) =>
                plans[index].toScrollProgressCard(onOptionTap: (option) {
              switch (option) {
                case 'delete':
                  database.deletePlan(plans[index].id!).then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Deleted ${plans[index].title}"),
                      ),
                    );
                    setState(() {});
                  });
                  break;
                case 'edit':
                  // navigate to add plan screen
                  navigateTo(context,
                      AddNewTask(database: database, planId: plans[index].id!));
                  break;
              }
            }),
          );
        },
      ));
}
