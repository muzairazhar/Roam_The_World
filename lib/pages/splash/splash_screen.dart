import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roam_the_world_app/pages/main/main_screen.dart';
import 'package:roam_the_world_app/routes/app_routes.dart';
import 'package:roam_the_world_app/utils/app_assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 5),
      () async {
        if(FirebaseAuth.instance.currentUser != null){
          Get.offAll(MainScreen());
        }else{
          Get.offAllNamed(
            AppRoutes.kOnboardScreenRoute,
          );
        }

        // bool isLogIn = await UserSession().isUserLoggedIn();
        // if (isLogIn) {
        //   Get.offAll(() => const HomeScreen());
        // } else {
        //   Get.offAll(() => const OnBoardScreen());
        // }


      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color
      body: Center(
        child: Image.asset(
          AppAssets.appLogo,
        ),
      ),
    );
  }
}
