import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ChartSlidingUpPannel extends StatelessWidget {
  const ChartSlidingUpPannel({
    super.key,
    required this.controller,
    required this.chart,
  });

  final PanelController controller;
  final Widget chart;

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      controller: controller,
      defaultPanelState: PanelState.CLOSED,
      minHeight: 0,
      maxHeight: 300,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      panel: chart,
    );
  }
}