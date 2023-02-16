import 'package:flutter/material.dart';
import 'package:weather/utils/styles/spaces.dart';
import '../../../utils/styles/colors.dart';
import '../../../utils/styles/cosntants.dart';
import '../../shared_widgets/my_text.dart';

class FooterRow extends StatelessWidget {
  final title;
  final icon;
  const FooterRow({Key? key, required this.title, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: whiteColor,
        ),
        K_hSpace10,
        MyText(
          text: title,
          size: fontSizeM,
          color: whiteColor.withOpacity(0.7),
          fontWeight: FontWeight.normal,
        ),
      ],
    );
  }
}
