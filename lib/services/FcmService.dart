import 'package:firebase_messaging/firebase_messaging.dart';

class FcmService {
  static void firebaseinit() {
    FirebaseMessaging.onMessage.listen(
            (message) {
      print(message.notification!.title);
      print(message.notification!.body);

    });
  }
}