import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roam_the_world_app/pages/auth/sign_in/sign_in_screen.dart';
import 'package:roam_the_world_app/routes/app_routes.dart';
import 'package:roam_the_world_app/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    var routeNames = [
      "Get Premium",
      "Profile Settings",
      "General Settings",
      "Change Password",
      "Help Centre",
      "Privacy Policy",
      "Terms & Conditions",
      "Logout"
    ];
    var routes = [
      AppRoutes.kSubscriptionScreenRoute,
      AppRoutes.kProfileSettingScreenRoute,
      AppRoutes.kGeneralSettingScreenRoute,
      AppRoutes.kChangePasswordScreenRoute,
      AppRoutes.kHelpCentreScreenRoute,
      AppRoutes.kPrivacyPolicyScreenRoute,
      AppRoutes.kTermsAndConditionsScreenRoute,
    ];

    return Scaffold(
      backgroundColor: AppColors.kWhiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.kWhiteColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading profile data"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Profile data not found"));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
              child: Column(
                children: [
                  Container(
                    height: 130.0.h,
                    width: 130.0.w,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: CachedNetworkImage(
                      imageUrl: "https://avatar.iran.liara.run/public/boy",
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Text(
                    userData['fullname'] ?? 'No name provided',
                    style: GoogleFonts.poppins(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  ListView.separated(
                    itemCount: routeNames.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 16.h);
                    },
                    itemBuilder: (context, index) {
                      // Special handling for logout button
                      if (routeNames[index] == "Logout") {
                        return _buildTile(
                          isPremium: false,
                          title: routeNames[index],
                            onTap: () async {
                              final shouldLogout = await showDialog<bool>(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return AlertDialog(
                                    title: const Text("Logout"),
                                    content: const Text("Are you sure you want to logout?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(dialogContext).pop(false),
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(dialogContext).pop(true),
                                        child: const Text("Logout"),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (shouldLogout == true) {
                                EasyLoading.show(status: "Please Wait");

                                await FirebaseAuth.instance.signOut();

                                /// Only navigate if the widget is still in the tree
                                if (context.mounted) {
                                  EasyLoading.dismiss();
                                  Get.offAllNamed(AppRoutes.kSignInScreenRoute);
                                }
                              }
                            },

                        );
                      }

                      // Normal route navigation for other items
                      return _buildTile(
                        isPremium: index == 0,
                        title: routeNames[index],
                        onTap: () {
                          Get.toNamed(routes[index]);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTile({
    required bool isPremium,
    required String title,
    required void Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: isPremium ? AppColors.primaryColor : AppColors.kWhiteColor,
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            color: isPremium
                ? AppColors.primaryColor
                : AppColors.kTextColor.withOpacity(0.6),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                color: isPremium ? AppColors.kWhiteColor : AppColors.kTextColor,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isPremium
                  ? AppColors.kWhiteColor
                  : AppColors.kTextColor.withOpacity(0.6),
            ),
          ],
        ),
      ),
    );
  }
}
