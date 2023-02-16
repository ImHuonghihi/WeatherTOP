import 'package:flutter/material.dart';

import '../../../utils/styles/colors.dart';
import '../../../utils/styles/cosntants.dart';
import '../../shared_widgets/my_text.dart';

class SliverTitleWidget extends StatelessWidget {
  String locationName;
  SliverTitleWidget({Key? key, required this.locationName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MyText(
          showEllipsis: true,
          text: locationName,
          size: fontSizeM,
          fontWeight: FontWeight.w400,
        ),
        const Icon(
          Icons.location_on,
          color: whiteColor,
          size: 20.0,
        ),
      ],
    );
  }
}
