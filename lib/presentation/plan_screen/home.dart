import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather/presentation/home_screen/home_screen_cubit/home_screen_cubit.dart';
import 'package:weather/presentation/shared_widgets/my_text.dart';
import 'package:weather/utils/functions/navigation_functions.dart';
import 'package:weather/utils/styles/colors.dart';
import 'package:weather/utils/styles/cosntants.dart';

import 'ProjectsPage/ProjectsPage.dart';
import 'TasksPage/TasksPage.dart';

class TaskManager extends StatefulWidget {
  final HomeScreenCubit homeScreenCubit;
  const TaskManager({super.key, required this.homeScreenCubit});

  @override
  State<StatefulWidget> createState() => _TaskManagerState();
}

class _TaskManagerState extends State<TaskManager> {
  // This widget is the root of your application.
  int _selectedIndex = 0;
  void _onIndexChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _Pages = [
    const ProjectsPage(),
    TasksPage(
      Goback: (int index) {},
    )
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: transparentColor, // status bar color
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        leading: IconButton(
          onPressed: () {
            navigateBack(context);
          },
          icon: const Icon(CupertinoIcons.back, color: blueColor),
        ),
        title: MyText(
          text: 'Events Manager',
          size: fontSizeL - 2,
          fontWeight: FontWeight.normal,
          color: blueColor,
        ),
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: whiteColor,
      ),
      body: _Pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 1,
        type: BottomNavigationBarType.shifting,
        iconSize: 25,
        selectedItemColor: const Color.fromARGB(255, 123, 0, 245),
        unselectedItemColor: Colors.grey.shade400,
        currentIndex: _selectedIndex,
        onTap: _onIndexChange,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_rounded), label: "Tasks"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none_outlined),
              label: "Notifcation"),
          BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded), label: "Search"),
        ],
      ),
    );
  }
}