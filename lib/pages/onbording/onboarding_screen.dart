import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roam_the_world_app/pages/onbording/controller/onboarding_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roam_the_world_app/routes/app_routes.dart';
import 'package:roam_the_world_app/utils/app_colors.dart';
import 'package:roam_the_world_app/widgets/custom_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardingController>(builder: (controller) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: controller.currentPage == 0
                ? onboardOne(controller: controller)
                : onboardMain(controller: controller),
          ),
        ),
      );
    });
  }

  Widget onboardOne({
    required OnboardingController controller,
  }) {
    return Column(
      children: [
        const SizedBox(height: 50),
        Container(
          margin: const EdgeInsets.only(top: 80),
          child: Image.asset(
            width: 320.w,
            controller.images[1],
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          "Welcome to",
          style: GoogleFonts.poppins(
            height: .5,
            fontSize: 14.sp,
            color: AppColors.kTextColor,
          ),
        ),
        Text(
          "Roam The World",
          style: GoogleFonts.poppins(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        SizedBox(height: 24.h),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Text(
            "Discover, Track, and Connect with travelers like you.",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: Colors.blue,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(height: 40.h),
        CustomButton(
          onPressed: () {
            controller.currentPage = 1;
            controller.update();
          },
          text: "Get Started",
          width: 250,
          height: 50,
        ),
      ],
    );
  }

  Widget onboardMain({
    required OnboardingController controller,
  }) {
    int currentPage = controller.currentPage;

    return Column(
      children: [
        const SizedBox(height: 50),
        Container(
          margin: const EdgeInsets.only(top: 80),
          child: Image.asset(
            width: 320.w,
            currentPage == 1 ? controller.images[0] : controller.images[2],
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          currentPage == 1
              ? controller.mainOnboardTitle[0]
              : controller.mainOnboardTitle[1],
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 24.sp,
            color: AppColors.kTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20.h),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            currentPage == 1
                ? controller.mainOnboardSubTitle[0]
                : controller.mainOnboardSubTitle[1],
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: Colors.blue,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(height: 40.h),
        CustomButton(
          onPressed: () {
            if (currentPage == 1) {
              controller.currentPage = 2;
              controller.update();
            } else {
              Get.offNamed(
                AppRoutes.kSignInOrSignUpRoute,
              );
            }
          },
          text: "Next",
          width: 250,
          height: 50,
        ),
      ],
    );
  }
}
