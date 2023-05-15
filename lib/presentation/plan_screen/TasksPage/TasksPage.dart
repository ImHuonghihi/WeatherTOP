// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:weather/data/plan_database.dart';

import 'package:weather/presentation/home_screen/home_screen_cubit/home_screen_cubit.dart';
import 'package:weather/utils/functions/loader_future.dart';
import 'package:weather/utils/functions/navigation_functions.dart';
import 'package:weather/utils/functions/number_converter.dart';

import '../AddNewTask/AddNewTask.dart';
import '../ProjectsPage/ProgressCard.dart';

class TasksPage extends StatefulWidget {
  var homeScreenCubit;

  PlanDatabase database;

  TasksPage({
    Key? key,
    required this.homeScreenCubit,
    required this.database,
    required this.Goback,
  }) : super(key: key);

  final void Function(int) Goback;
  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  DateTime _selectedDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  void _onDateChange(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        color: const Color.fromRGBO(242, 244, 255, 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IntrinsicHeight(
                child: Container(
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 159, 192, 248),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //show weather data of day

                      _buildTaskWeatherData(context, widget.homeScreenCubit),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddNewTask(
                                        database: widget.database,
                                        selectedDate: _selectedDate,
                                      )));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20,
                              ),
                              Text(
                                "Add task",
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 25),
                  DatePicker(
                    DateTime.now(),
                    initialSelectedDate: _selectedDate,
                    selectionColor: Colors.blueAccent,
                    onDateChange: _onDateChange,
                    height: 90,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Expanded(child: Container()),
                ],
              ),
            )),
            Container(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "List Task",
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 250,
                    ),
                    child: FutureLoader.showLoadingIndicator(
                      context: context,
                      future: _buildTaskByDate(_selectedDate),
                      onSuccess: (result) {
                        var data = result as List<Widget>;
                        if (data.isEmpty) {
                          return const Center(
                            child: Text("No task available"),
                          );
                        }
                        return ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: data,
                        );
                      },
                      onError: () => const Text("Error"),
                    ),
                  ),
                ],
              ),
            ),
            // fill the rest of the screen with empty space
            SizedBox(height: MediaQuery.of(context).size.height * 0.5),
          ],
        ),
      ),
    );
  }

  _buildTaskWeatherData(BuildContext context, homeScreenCubit) {
    try {
      var today = DateTime.now();
      int dayFromToday = _selectedDate.difference(today).inDays;
      var currentWeather =
          homeScreenCubit.currentWeather.weatherOfDaysList[dayFromToday * 8];
      var currentTemp = currentWeather.currentTemp.ceil();
      var weatherStatus =
          homeScreenCubit.currentWeather.weatherOfDaysList[0].weatherStatus;
      return IntrinsicHeight(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('MMM, d').format(_selectedDate),
            style: GoogleFonts.montserrat(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Text(
                "$weatherStatus",
                style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.wb_sunny,
                color: Colors.yellow,
                size: 20,
              ),
              const SizedBox(width: 5),
              Text(
                " $currentTemp°",
                style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          )
        ],
      ));
      // outofbound
    } catch (e) {
      //debugPrint(e.toString());
      return IntrinsicHeight(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('MMM, d').format(_selectedDate),
            style: GoogleFonts.montserrat(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
        ],
      ));
      ;
    }
  }

  _buildTaskByDate(DateTime selectedDate) async {
    var taskList =
        await widget.database.getPlansByDate(selectedDate.toIso8601String());
    var taskListWidget = <Widget>[];
    for (var task in taskList) {
      debugPrint(task.toMap().toString());
      taskListWidget.add(task.toScrollProgressCard(onOptionTap: (option) {
        switch (option) {
          case 'delete':
            widget.database.deletePlan(task.id!).then((value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Deleted ${task.title}"),
                ),
              );
              setState(() {});
            });
            break;
          case 'edit':
            // navigate to add plan screen
            navigateTo(context,
                AddNewTask(database: widget.database, planId: task.id!));
            break;
        }
      }));
    }
    return taskListWidget;
  }
}
