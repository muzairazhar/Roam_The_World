import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roam_the_world_app/pages/complete_profile/controller/complete_profile_controller.dart';
import 'package:roam_the_world_app/routes/app_routes.dart';
import 'package:roam_the_world_app/utils/app_assets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:roam_the_world_app/utils/app_colors.dart';

class CompleteProfileScreen extends StatelessWidget {
  const CompleteProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CompleteProfileController>(
      builder: (controller) {
        return Scaffold(
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (controller.page == 1)
                FloatingActionButton(
                  onPressed: () => controller.updatePage(0),
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColors.kWhiteColor,
                  ),
                ),
              if (controller.page == 1) SizedBox(width: 20.w),
              FloatingActionButton(
                onPressed: () {
                  if (controller.page == 0) {
                    controller.updatePage(1);
                  } else {
                    Get.offAllNamed(AppRoutes.kSubscriptionScreenRoute);
                  }
                },
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: AppColors.kWhiteColor,
                ),
              ),
            ],
          ),
          body: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                AppAssets.completeProfileBG,
                width: double.infinity,
                height: double.infinity,
              ),
              controller.page == 0
                  ? whereAreYouFrom(
                      controller: controller,
                    )
                  : whereHaveYouBeen(
                      controller: controller,
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget commonBox({
    required IconData icon,
    required String title,
    required Widget widget,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 40.w),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100.r),
              border: Border.all(
                color: AppColors.primaryColor,
                width: 1,
              ),
            ),
            child: Center(
              child: Icon(
                icon,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 24.sp,
              color: AppColors.kTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24.h),
          widget,
        ],
      ),
    );
  }

  Widget whereAreYouFrom({
    required CompleteProfileController controller,
  }) {
    return commonBox(
      icon: FontAwesomeIcons.locationDot,
      title: "Where are you from?",
      widget: DropdownButtonFormField<String>(
        dropdownColor: AppColors.kWhiteColor,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primaryColor),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primaryColor),
          ),
          filled: true,
          fillColor: AppColors.kWhiteColor,
        ),
        value: controller.selectedLocation,
        hint: Text(
          "- Select Country -",
          style: GoogleFonts.poppins(
            color: AppColors.kTextColor,
          ),
        ),
        items: controller.countries.map((country) {
          return DropdownMenuItem<String>(
            value: country["name"],
            child: Row(
              children: [
                Text(
                  country["flag"]!,
                  style: GoogleFonts.poppins(
                    fontSize: 20.sp,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  country["name"]!,
                  style: GoogleFonts.poppins(
                    color: AppColors.kTextColor,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {
          controller.selectedLocation = value;
          controller.update();
        },
      ),
    );
  }

  Widget whereHaveYouBeen({
    required CompleteProfileController controller,
  }) {
    return commonBox(
      icon: FontAwesomeIcons.map,
      title: "Which countries have you been to?",
      widget: DropdownButtonFormField<String>(
        dropdownColor: AppColors.kWhiteColor,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primaryColor),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primaryColor),
          ),
          filled: true,
          fillColor: AppColors.kWhiteColor,
        ),
        value: controller.selectedLocation,
        hint: Text(
          "- Select Country -",
          style: GoogleFonts.poppins(
            color: AppColors.kTextColor,
          ),
        ),
        items: controller.countries.map((country) {
          return DropdownMenuItem<String>(
            value: country["name"],
            child: Row(
              children: [
                Text(
                  country["flag"]!,
                  style: GoogleFonts.poppins(
                    fontSize: 20.sp,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  country["name"]!,
                  style: GoogleFonts.poppins(
                    color: AppColors.kTextColor,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {
          controller.selectedLocation = value;
          controller.update();
        },
      ),
    );
  }
}
