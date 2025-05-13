import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roam_the_world_app/pages/auth/forget_password/controller/reset_password_controller.dart';
import 'package:roam_the_world_app/routes/app_routes.dart';
import 'package:roam_the_world_app/utils/app_assets.dart';
import 'package:roam_the_world_app/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roam_the_world_app/widgets/custom_button.dart';
import 'package:roam_the_world_app/widgets/custom_text_field.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ResetPasswordController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.kBackgroundColor,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 120.h),
                  Image.asset(
                    AppAssets.otpScreen,
                    height: 180.h,
                  ),
                  SizedBox(height: 50.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Change Password",
                      style: GoogleFonts.poppins(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.kTextColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "You are all set to reset your password. Kindly select a strong password.",
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        color: AppColors.kTextColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 26.h),
                  SizedBox(height: 20.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Password*",
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w300,
                        color: AppColors.kTextColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  CustomTextField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: !controller.isPasswordVisible,
                    suffixIcon: !controller.isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                    suffixPressed: () {
                      controller.isPasswordVisible =
                          !controller.isPasswordVisible;
                      controller.update();
                    },
                  ),
                  SizedBox(height: 20.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Confirm Password*",
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w300,
                        color: AppColors.kTextColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  CustomTextField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: !controller.isConfirmPasswordVisible,
                    suffixIcon: !controller.isConfirmPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                    suffixPressed: () {
                      controller.isConfirmPasswordVisible =
                          !controller.isConfirmPasswordVisible;
                      controller.update();
                    },
                  ),
                  SizedBox(height: 22.h),
                  CustomButton(
                    onPressed: () {
                      Get.offAllNamed(
                        AppRoutes.kSplashScreenRoute,
                      );
                    },
                    text: "Change Password",
                    height: 58.h,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
