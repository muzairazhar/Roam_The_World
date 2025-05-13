import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roam_the_world_app/routes/app_routes.dart';
import 'package:roam_the_world_app/utils/app_assets.dart';
import 'package:roam_the_world_app/utils/app_colors.dart';
import 'package:roam_the_world_app/widgets/custom_button.dart';
import 'package:roam_the_world_app/widgets/custom_text_field.dart';

import 'controller/reset_password_controller.dart';


class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final useremailcontroller=TextEditingController();
    final controller = Get.put((ResetPasswordController()));
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
                  "Forgot Password?",
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
                  "No worries! Enter your email and We’ll send you a Verification code.",
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    color: AppColors.kTextColor,
                  ),
                ),
              ),
              SizedBox(height: 26.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Email Address*",
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w300,
                    color: AppColors.kTextColor,
                  ),
                ),
              ),
              SizedBox(height: 5.h),
              CustomTextField(
                controller: useremailcontroller,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 22.h),
              CustomButton(
                onPressed: () {
                  String useremail = useremailcontroller.text.trim();

                  if (useremail.isEmpty) {
                    Get.snackbar("Error", "Please enter your email",
                        backgroundColor: Colors.red,
                        colorText:Colors.white,
                        snackPosition: SnackPosition.BOTTOM);
                  } else{
                    String email=useremailcontroller.text.trim();
                    controller.ForgotPasswordMethod(email);


                  }
                  // Get.toNamed(
                  //   // AppRoutes.kForgetPasswordVerifyOtpScreenRoute,
                  // );
                },
                text: "Send ",
                height: 58.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
