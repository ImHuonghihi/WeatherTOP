import 'package:flutter/material.dart';
import 'package:weather/utils/functions/number_converter.dart';
import 'package:weather/utils/styles/cosntants.dart';

class AnimatedContentContainer extends StatelessWidget {
  final contentWidget;//widget chứa nội dung
  final animatedContainerColor;//màu của container
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
      constraints: BoxConstraints(//giới hạn kích thước của container
        minHeight: convertNumber<double>(height ?? 100),
        maxHeight: 500.0,
      ),
      duration: const Duration(milliseconds: 500),//thời gian để hoàn thành hiệu ứng chuyển đổi kích thước
      height: height != null ? convertNumber<double>(height) : null,
      width: double.infinity, //chiều rộng của container bằng với chiều rộng của màn hình
      decoration: BoxDecoration(//trang trí container
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: animatedContainerColor, width: 0.5),
        color: animatedContainerColor.withOpacity(0.3),
      ),
      child: contentWidget,
    );
  }
}
