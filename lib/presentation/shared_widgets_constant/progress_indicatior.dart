import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:weather/presentation/shared_widgets/my_text.dart';
import 'package:weather/utils/styles/colors.dart';
import 'package:weather/utils/styles/cosntants.dart';
import 'package:weather/utils/styles/spaces.dart';

class MainProgressIndicator extends StatelessWidget {
  final loadingMessage;
  const MainProgressIndicator({Key? key, required this.loadingMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
      child: Container(
        color: blackColor.withOpacity(0.5),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingAnimationWidget.staggeredDotsWave(
              color: whiteColor.withOpacity(0.6),
              size: 50,
            ),
            K_vSpace10,
            FadeInDown(
              duration: const Duration(seconds: 1),
              from: 0.0,
              child: MyText(
                text: loadingMessage,
                size: fontSizeM - 3,
                fontWeight: FontWeight.normal,
              ),
            )
          ],
        ),
      ),
    );
  }
}
