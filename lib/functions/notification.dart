import 'dart:convert';

import 'package:assignment/functions/authFunctions.dart';
import 'package:get/get.dart';

class NotificationFunction extends GetConnect {
  sendNotification({required fcm}) async {
    print(fcm.toString());
    var body = jsonEncode({
      "notification": {
        "body": "Notification from postman",
        "title": "You have a new message."
      },
      "to": fcm.toString()
    });

    var response =
        await post("https://fcm.googleapis.com/fcm/send", body, headers: {
      "Content-Type": "application/json",
      "Authorization":
          "key=AAAA0XI8PIg:APA91bExiztk51ar65jwfMdk2pfWdYRVSeXSdv007OuFZH5bRYESs9Pwpj0Smmjz1U7EEr0y-Bx1DUulCetrC6QhECqrWR6cE_NjpKfuS20tV5gz133CFKSzciTbirqZZVaZHe1aIrC4"
    });

    if (response.statusCode == 200) {
      Get.snackbar("Success", "Notification send successfully");
    }
  }
}
