import 'package:flutter/material.dart';

@immutable
abstract class AppColors {
  static const Color primaryColor = Color(0xFF1494EB);
  static const MaterialColor primarySwatch = MaterialColor(
    0xFFD05BFF,
    <int, Color>{
      50: Color(0xFF1494EB),
      100: Color(0xFF1494EB),
      200: Color(0xFF1494EB),
      300: Color(0xFF1494EB),
      400: Color(0xFF1494EB),
      500: Color(0xFF1494EB),
      600: Color(0xFF1494EB),
      700: Color(0xFF1494EB),
      800: Color(0xFF1494EB),
      900: Color(0xFF1494EB),
    },
  );

  static const Color kSecondaryColor = Color(0xFF49C8F5);
  static const Color kBackgroundColor = Color(0xffffffff);

  // Gradient Color
  static const Color kLightBlueColor = Color(0xFF1494EB);
  static const Color kLightCyanColor = Color(0xFFA3F3DF);

  // Border Color
  static const Color kBorderColor = Color(0xFFD6D6D6);

  //Text Field Colors
  static const Color kFieldBorderColor = Color(0xFF787878);

  // Chat Colors
  static const Color kUserChatBubbleColor = Color(0xFFD9D9D9);

  static const Color kTextColor = Color(0xFF5D5D5D);

  static const Color kWhiteColor = Color(0xFFFFFFFF);
  static const Color kBlackColor = Color(0xFF000000);
  static const Color kYellowColor = Colors.orangeAccent;
  static const Color kSuccessColor = Color(0xff36F279);
}
