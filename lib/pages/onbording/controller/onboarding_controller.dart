import 'package:get/get.dart';
import 'package:roam_the_world_app/utils/app_assets.dart';

class OnboardingController extends GetxController {
  int currentPage = 0;

  final List<String> images = [
    AppAssets.onboarding1,
    AppAssets.onboarding2,
    AppAssets.onboarding3,
  ];

  final List<String> mainOnboardTitle = [
    "Map Your Journey",
    "Travel Together, Chat Easily"
  ];

  final List<String> mainOnboardSubTitle = [
    "Tap on the map to mark places you’ve visited, add photos, notes, and memories.",
    "Join travel groups, chat with fellow travelers, and plan your trips—all in one place."
  ];
}
