import 'dart:convert';
import 'package:http/http.dart' as http;
import 'get_service_key.dart';

class SendNotificationService {
  static Future<void> sendNotificationUsingApi({
    required String? Token,
    required String? Title,
    required String? Body,
    required Map<String, dynamic>? Data,
  }) async {
    String serverKey = await GetServerKey.getServerKeyToken();
    String url =
        "https://fcm.googleapis.com/v1/projects/roamtheworld-325c4/messages:send";

    var headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $serverKey',
    };

    Map<String, dynamic> message = {
      "message": {
        "token": Token,
        "notification": {
          "body": Body,
          "title": Title,
          "image": null, // optional image if you want to show
        },
        "android": {
          "notification": {
            "icon": "ic_launcher", // ✅ your drawable icon name
            "color": "#f45342" // optional: color for the icon bg
          }
        },
        "data": Data ?? {},
      }
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print("✅ Notification sent successfully");
    } else {
      print("❌ Failed to send notification: ${response.body}");
    }
  }
}
