import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roam_the_world_app/routes/app_routes.dart';
import 'package:roam_the_world_app/utils/app_assets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roam_the_world_app/utils/app_colors.dart';
import 'package:roam_the_world_app/widgets/custom_button.dart';

class SignInOrSignUpScreen extends StatelessWidget {
  const SignInOrSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppAssets.signInOrSignUpBG,
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Let's Get\nTravelling!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 42.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    height: 1,
                  ),
                ),
                SizedBox(height: 32.h),
                CustomButton(
                  onPressed: () {
                    Get.offNamed(AppRoutes.kSignInScreenRoute);
                  },
                  text: "Log In",
                  width: 200.w,
                  height: 42.h,
                ),
                SizedBox(height: 20.h),
                CustomButton(
                  onPressed: () {
                    Get.offNamed(AppRoutes.kSignUpScreenRoute);
                  },
                  text: "Sign Up",
                  width: 200.w,
                  height: 42.h,
                  textColor: AppColors.primaryColor,
                  buttonColor: AppColors.kWhiteColor,
                  border: Border.all(
                    color: AppColors.primaryColor,
                    width: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
