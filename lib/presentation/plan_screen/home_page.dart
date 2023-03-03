import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/presentation/home_screen/home_screen_cubit/home_screen_cubit.dart';
import 'package:weather/presentation/home_screen/home_screen_cubit/home_screen_states.dart';
import 'package:weather/presentation/plan_screen/plan_screen_cubit/plan_screen_states.dart';
import 'package:weather/presentation/plan_screen/travel_page.dart';
import 'package:weather/utils/functions/navigation_functions.dart';
import 'package:weather/utils/styles/colors.dart';

import 'anims/fade_animation.dart';
import 'plan_screen_cubit/plan_screen_cubit.dart';
import 'service/service.dart';

class PlanHomePage extends StatefulWidget {
  final HomeScreenCubit homeScreenCubit;
  PlanHomePage({Key? key, required this.homeScreenCubit}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<PlanHomePage> {
  late PlanScreenCubit planScreenCubit;
  List<dynamic> workers = [
    ['The Royal Arcs', 'Kanpur', 'images/download.jpg', 4.8],
    ['Hotel Grand maze', 'Lucknow', 'images/maze.jpg', 4.6],
    ['Deepak Caters', 'Delhi', 'images/deepak.jpg', 4.4]
  ];
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlanScreenCubit()..init(),
      child: BlocConsumer<PlanScreenCubit, PlanScreenStates>(
        listener: (context, state) {},
        builder: (context, state) {
          planScreenCubit = PlanScreenCubit.get(context);
          return mainBuilder(context);
        },
      ),
    );
  
  }


  mainBuilder(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TravelPage(location: widget.homeScreenCubit.positionOfUser!,),
              ),
            );
          },
          label: const Text('Explore'),
          icon: const Icon(Icons.search),
          hoverColor: Colors.lightBlueAccent,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          backgroundColor: whiteColor,
          title: const Text(
            'Events',
            style: TextStyle(
              color: blackColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0,
          
          leading: IconButton(
            onPressed: () {
              navigateBack(context);
            },
            icon: const Icon(CupertinoIcons.back, color: blackColor),
          ),

        ),
        body: SingleChildScrollView(
            child: Column(children: [
          FadeAnimation(
              1,
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                        onPressed: () {},
                        child: const Text(
                          'View all',
                        ))
                  ],
                ),
              )),
          FadeAnimation(
              1.2,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    border: Border.all(
                      color: Colors.grey.shade500,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade50,
                        offset: const Offset(0, 4),
                        blurRadius: 10.0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.asset(
                                'images/download.jpg',
                                width: 70,
                                height: 55,
                              )),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "The Royal Arcs",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Occasion - Birthday Party",
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.7),
                                    fontSize: 18),
                              ),
                            ],
                          )
                        ],
                      ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // // ignore: deprecated_member_use
                      // FlatButton(
                      //   height: 10,
                      //   color: Colors.blue,
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(15.0),
                      //   ),
                      //   onPressed: null,
                      //   child: Center(
                      //       child: Text(
                      //     'View Order',
                      //     style: TextStyle(color: Colors.white, fontSize: 18),
                      //   )),
                      // )
                    ],
                  ),
                ),
              )),
          const SizedBox(
            height: 20,
          ),
          FadeAnimation(
              1.3,
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Categories',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                        onPressed: () {},
                        child: const Text(
                          'View all',
                        ))
                  ],
                ),
              )),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 300,
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: services.length,
                itemBuilder: (BuildContext context, int index) {
                  return FadeAnimation(
                      (1.0 + index) / 4,
                      serviceContainer(services[index].imageURL,
                          services[index].name, index));
                }),
          ),
          const SizedBox(
            height: 20,
          ),
          FadeAnimation(
              1.3,
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Top Rated',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                        onPressed: () {},
                        child: const Text(
                          'View all',
                        ))
                  ],
                ),
              )),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 120,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: workers.length,
                itemBuilder: (BuildContext context, int index) {
                  return FadeAnimation(
                      (1.0 + index) / 4,
                      workerContainer(workers[index][0], workers[index][1],
                          workers[index][2], workers[index][3]));
                }),
          ),
          const SizedBox(
            height: 150,
          ),
        ])));
  }
  serviceContainer(String image, String name, int index) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.only(right: 20),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border: Border.all(
            color: Colors.grey.shade500,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.network(image, height: 45),
              const SizedBox(
                height: 20,
              ),
              Text(
                name,
                style: const TextStyle(fontSize: 10),
              )
            ]),
      ),
    );
  }

  workerContainer(String name, String job, String image, double rating) {
    return GestureDetector(
      child: AspectRatio(
        aspectRatio: 3.5,
        child: Container(
          margin: const EdgeInsets.only(right: 20),
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey.shade500,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.asset(image)),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style:
                          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      job,
                      style: const TextStyle(fontSize: 15),
                    )
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      rating.toString(),
                      style:
                          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Icon(
                      Icons.star,
                      color: Colors.orange,
                      size: 20,
                    )
                  ],
                )
              ]),
        ),
      ),
    );
  }
}

