import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:roam_the_world_app/routes/app_routes.dart';
import 'package:roam_the_world_app/utils/app_assets.dart';
import 'package:roam_the_world_app/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roam_the_world_app/widgets/custom_button.dart';

class ForgetPasswordVerifyOtpScreen extends StatelessWidget {
  const ForgetPasswordVerifyOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  "Email Verification Code",
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
                  "Kindly enter the 4 digit code sent to your email address to reset your password.",
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    color: AppColors.kTextColor,
                  ),
                ),
              ),
              SizedBox(height: 26.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.w),
                child: PinCodeTextField(
                  length: 4,
                  appContext: context,
                  cursorColor: Colors.blue,
                  keyboardType: TextInputType.number,
                  textStyle: const TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10),
                    fieldHeight: 50,
                    fieldWidth: 50,
                    inactiveColor: Colors.grey,
                    activeColor: Colors.blue,
                    selectedColor: Colors.blue,
                  ),
                ),
              ),
              SizedBox(height: 25.h),
              Text(
                "00:10 Sec",
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  color: AppColors.kTextColor,
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive code? ",
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      color: AppColors.kTextColor,
                    ),
                  ),
                  Text(
                    "Re-send",
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      color: AppColors.kTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 22.h),
              CustomButton(
                onPressed: () {
                  Get.toNamed(
                    AppRoutes.kResetPasswordScreenRoute,
                  );
                },
                text: "Enter",
                height: 58.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
