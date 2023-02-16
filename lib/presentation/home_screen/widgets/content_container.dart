import 'package:flutter/material.dart';
import 'package:weather/utils/styles/cosntants.dart';

class AnimatedContentContainer extends StatelessWidget {
  final contentWidget;
  final animatedContainerColor;
  final height;
  const AnimatedContentContainer({
    Key? key,
    required this.contentWidget,
    required this.animatedContainerColor,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: animatedContainerColor, width: 0.5),
        color: animatedContainerColor.withOpacity(0.3),
      ),
      child: contentWidget,
    );
  }
}
