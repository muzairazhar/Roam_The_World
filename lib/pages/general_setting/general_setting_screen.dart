import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roam_the_world_app/pages/general_setting/controller/generatl_setting_controller.dart';
import 'package:roam_the_world_app/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GeneralSettingScreen extends StatelessWidget {
  const GeneralSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneratlSettingController>(builder: (controller) {
      return Scaffold(
        backgroundColor: AppColors.kWhiteColor,
        appBar: AppBar(
          backgroundColor: AppColors.kWhiteColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text(
            "General Settings",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
          child: Column(
            children: [
              tile(
                text: "Allow Other Users to message you",
                value: controller.allowOtherUsersToMessage,
                onChanged: (bool? val) {
                  controller.allowOtherUsersToMessage = val!;
                  controller.update();
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget tile({
    required String text,
    required bool value,
    required void Function(bool?) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          color: AppColors.kTextColor.withOpacity(0.6),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                color: AppColors.kTextColor,
              ),
            ),
          ),
          Switch(
            activeColor: AppColors.primaryColor,
            inactiveThumbColor: AppColors.kTextColor,
            inactiveTrackColor: AppColors.kBorderColor.withOpacity(0.6),
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
