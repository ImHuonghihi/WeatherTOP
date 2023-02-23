import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ChartSlidingUpPannel extends StatelessWidget {
  const ChartSlidingUpPannel({
    super.key,
    required this.controller,
    required this.title,
    required this.chart,
  });

  final String title;
  final PanelController controller;
  final Widget chart;

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      controller: controller,
      color: Colors.black,
      defaultPanelState: PanelState.CLOSED,
      backdropEnabled: true,
      minHeight: 0,
      maxHeight: MediaQuery.of(context).size.height * 0.5,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      panel: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          chart,
        ],
      )
    );
  }
}

