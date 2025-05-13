import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:roam_the_world_app/pages/airline/airline_screen.dart';
import 'package:roam_the_world_app/pages/chat/chat_screen.dart';
import 'package:roam_the_world_app/pages/home/home_screen.dart';
import 'package:roam_the_world_app/pages/main/controller/main_controller.dart';
import 'package:roam_the_world_app/pages/map/map_screen.dart';
import 'package:roam_the_world_app/pages/profile/profile_screen.dart';
import 'package:roam_the_world_app/services/Notifiction-Service.dart';
import 'package:roam_the_world_app/utils/app_colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final NotificationService notficationService = NotificationService();

  @override
  void initState() {
    super.initState();

    // Initialize controller safely
    if (!Get.isRegistered<MainController>()) {
      Get.put(MainController());
    }

    notficationService.getDeviceToken();
    notficationService.requestNotificationService();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
      builder: (controller) {
if(FirebaseAuth.instance.currentUser == null){
  return Text('null user uzair');
}

        return Scaffold(
          backgroundColor: AppColors.kBackgroundColor,
          bottomNavigationBar:
          BottomNavigationBar(
            backgroundColor: AppColors.kBackgroundColor,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            onTap: (index) {
              // Call the controller's method to handle the tab change logic
              controller.changeTabIndex(index, context);
            },
            currentIndex: controller.selectedIndex,
            selectedItemColor: AppColors.primaryColor,
            type: BottomNavigationBarType.fixed,
            items: controller.icons.map((e) {
              var index = controller.icons.indexOf(e);
              return BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  e,
                  color: index == controller.selectedIndex
                      ? AppColors.primaryColor // Selected icon color
                      : null, // Default color for unselected icons
                ),
                label: controller.names[index], // Display the label as per your `names` list
              );
            }).toList(),
          ),
          body: IndexedStack(
            index: controller.selectedIndex,
            children: [
              const HomeScreen(),
              const MapScreen(),
              const AirlineScreen(),
              ChatScreen(currentUsername: "Waseem"),
              const ProfileScreen(),
            ]


          ),
        );
      },
    );
  }
}
