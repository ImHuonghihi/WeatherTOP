import 'package:flutter/material.dart';
import 'package:weather/utils/functions/number_converter.dart';
import 'package:weather/utils/styles/cosntants.dart';

class AnimatedContentContainer extends StatelessWidget {
  final contentWidget;
  final animatedContainerColor;
  double? height;
  AnimatedContentContainer({
    Key? key,
    required this.contentWidget,
    required this.animatedContainerColor,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      constraints: BoxConstraints(
        minHeight: convertNumber<double>(height ?? 100),
        maxHeight: 500.0,
      ),
      duration: const Duration(milliseconds: 500),
      height: height != null ? convertNumber<double>(height) : null,
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
