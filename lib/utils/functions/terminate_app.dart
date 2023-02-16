import 'dart:io';

import 'package:flutter/services.dart';

void terminateApp() {
  if (Platform.isIOS) {
    exit(0);
  } else {
    SystemNavigator.pop();
  }
}
