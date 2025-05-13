import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roam_the_world_app/utils/app_assets.dart';
import 'package:roam_the_world_app/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roam_the_world_app/widgets/custom_button.dart';
import 'package:roam_the_world_app/widgets/custom_text_field.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.kWhiteColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          "Help Center",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  AppAssets.helpCenter,
                  height: 300.h,
                ),
              ),
              Text(
                "Got Something on your mind?",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  height: 1.1,
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.kTextColor,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                "Ask our customer service team any query by dropping your message below",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  color: AppColors.kTextColor,
                ),
              ),
              SizedBox(height: 24.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Ask your query",
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w300,
                    color: AppColors.kTextColor,
                  ),
                ),
              ),
              SizedBox(height: 5.h),
              CustomTextField(
                keyboardType: TextInputType.multiline,
                isDesription: true,
              ),
              SizedBox(height: 24.h),
              Center(
                child: CustomButton(
                  onPressed: () {},
                  text: "Submit",
                  width: 200.w,
                  height: 42.h,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
