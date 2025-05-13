import 'package:get/get.dart';

class CompleteProfileController extends GetxController {
  int page = 0;
  String? selectedLocation;

  final List<Map<String, String>> countries = [
    {"name": "United States", "flag": "🇺🇸"},
    {"name": "Canada", "flag": "🇨🇦"},
    {"name": "United Kingdom", "flag": "🇬🇧"},
    {"name": "Australia", "flag": "🇦🇺"},
    {"name": "India", "flag": "🇮🇳"},
    {"name": "Germany", "flag": "🇩🇪"},
    {"name": "France", "flag": "🇫🇷"},
    {"name": "Japan", "flag": "🇯🇵"},
    {"name": "China", "flag": "🇨🇳"},
    {"name": "Brazil", "flag": "🇧🇷"},
    {"name": "South Africa", "flag": "🇿🇦"},
  ];

  void updatePage(int newPage) {
    page = newPage;
    update();
  }
}
