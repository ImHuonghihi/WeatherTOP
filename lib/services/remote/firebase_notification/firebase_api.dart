import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FirebaseNotification {
  static Future<bool> sendNotification(String token,
      {required String title,
      required String body,
      bool sound = false,
      String? image}) async {
    var testToken =
        "cHDwF3AoRHaRQ3YOxCTzzR:APA91bEmOHsakrTRzV6hAJ8hjr1GjBarugUQGqrwvdnU9W9NuWK2F7BlUhmFi_ShWJGBe2gJElFRVhdmahvji1aInkK1qgfum3Z0I7ZlOqJdQnhdSjf0PHcLQ2jA-sFAZRW0Nag12XHZ";
    debugPrint("Firebase: Creating notification");
    var status = false;
    var payload = {
      'notification': {
        'title': title,
        'body': body,
        'sound': sound,
        'image': image,
      },
      'priority': 'high',
      'data': {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done',
      },
      'to': token,
    };

    var response =
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded',
              'Authorization': testToken,
            },
            body: jsonEncode(payload));
    if (response.statusCode == 200) {
      status = true;
      debugPrint("Firebase: Notification created");
      debugPrint("Firebase: ${response.body}");
    }
    return status;
  }
}
