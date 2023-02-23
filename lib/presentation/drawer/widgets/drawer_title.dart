import 'package:flutter/material.dart';
import 'package:weather/utils/styles/spaces.dart';
import '../../../utils/styles/colors.dart';
import '../../../utils/styles/cosntants.dart';
import '../../shared_widgets/my_text.dart';

class DrawerTitle extends StatelessWidget {
  final title;
  final icon;
  bool setInfo;
  void Function()? onTap;
  DrawerTitle(
      {Key? key,
      required this.title,
      required this.icon,
      this.setInfo = false,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 25.0,
              color: whiteColor,
            ),
            K_hSpace20,
            MyText(
              text: title,
              size: fontSizeM,
              fontWeight: FontWeight.normal,
              color: whiteColor.withOpacity(0.7),
            ),
          ],
        ),
        Icon(
          Icons.info_outline_rounded,
          color: whiteColor,
          size: setInfo ? 23.0 : 0.0,
        ),
      ],
    ),);
  }
}
