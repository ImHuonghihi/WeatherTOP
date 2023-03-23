import 'package:flutter/material.dart';
import 'package:weather/presentation/home_screen/home_screen_cubit/home_screen_cubit.dart';

import 'ProjectsPage/ProjectsPage.dart';
import 'TasksPage/TasksPage.dart';

class TaskManager extends StatefulWidget {
  final HomeScreenCubit homeScreenCubit;
  const TaskManager({super.key, required this.homeScreenCubit });

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


