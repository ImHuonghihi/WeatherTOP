import 'package:flutter/material.dart';
import 'package:weather/data/plan_database.dart';
import 'package:weather/models/plan.dart';
import 'package:weather/utils/functions/loader_future.dart';

import 'OverViewCard.dart';



class OverView extends StatefulWidget {
  final PlanDatabase database;
  const OverView({Key? key, required this.database}) : super(key: key);

  @override
  State<OverView> createState() => _OverViewState();
}

class _OverViewState extends State<OverView> with TickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    tabController = new TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            controller: tabController,
            labelColor: Colors.black,
            isScrollable: true,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(0),
            unselectedLabelColor: Colors.grey.shade400,
            tabs: const [
              Tab(
                text: "Today",
              ),
              Tab(
                text: "All",
              ),
            ],
          ),
          Container(
            height: 250,
            width: double.maxFinite,
            child: TabBarView(
              controller: tabController,
              children: [
                FutureLoader.showLoadingIndicator<List<Plan>>(
                  context: context,
                  future: widget.database.getPlansOfToday(),
                  onSuccess: (plans) => ListView.builder(
                    itemCount: plans.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return OverviewCard(
                        title: plans[index].title,
                        content: plans[index].description,
                        date: DateTime.parse(plans[index].date),
                      );
                    }),
                ),
                // center texts for now
                FutureLoader.showLoadingIndicator<List<Plan>>(
                  context: context,
                  future: widget.database.getPlans(),
                  onSuccess: (plans) => ListView.builder(
                      itemCount: plans.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return OverviewCard(
                          title: plans[index].title,
                          content: plans[index].description,
                          date: DateTime.parse(plans[index].date),
                        );
                      }),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CircleTab extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    // TODO: implement createBoxPainter
    return CirclePainter();
  }
}

class CirclePainter extends BoxPainter {
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    Paint _paint = Paint();
    _paint.color = Colors.black54;
    final Offset CirclePostion =
        Offset(configuration.size!.width - 3.0, configuration.size!.height / 2);
    canvas.drawCircle(offset + CirclePostion, 4, _paint);
  }
}
