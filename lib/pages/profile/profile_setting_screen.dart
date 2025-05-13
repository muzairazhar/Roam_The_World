import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roam_the_world_app/additional%20controllers/get_token_controller.dart';
import 'package:roam_the_world_app/pages/profile/controller/profile_setting_controller.dart';
import 'package:roam_the_world_app/pages/profile/profile_screen.dart';
import 'package:roam_the_world_app/services/Notifiction-Service.dart';
import 'package:roam_the_world_app/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roam_the_world_app/widgets/custom_button.dart';
import 'package:roam_the_world_app/widgets/custom_text_field.dart';

import '../../models/user-model.dart';
import '../auth/sign_up/controller/getuserdata_controller.dart';

class ProfileSettingScreen extends StatefulWidget {
  const ProfileSettingScreen({super.key});

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final namecontroller=TextEditingController();
    final emailcontroller=TextEditingController();
    final phonecontroller=TextEditingController();
    final locationcontroller=TextEditingController();
    final biocontroller=TextEditingController();
    final tiktokcontroller=TextEditingController();
    final linkdincontroller=TextEditingController();
    final facebookcontroller=TextEditingController();
    final youtubecontroller=TextEditingController();
    final instagramcontroller=TextEditingController();


    Future<void> updateAuthCredentials({
      required String newEmail,
      required String newPassword,
      required String currentPassword,
    }) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');

      // Reauthenticate user first (required for sensitive operations)
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Update email
      if (newEmail != user.email) {
        await user.verifyBeforeUpdateEmail(newEmail);
      }

      // Update password (if changed)
      if (newPassword.isNotEmpty) {
        await user.updatePassword(newPassword);
      }
    }









    return GetBuilder<ProfileSettingController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.kWhiteColor,
          appBar: AppBar(
            backgroundColor: AppColors.kWhiteColor,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: Text(
              "Profile Settings",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
              ),
            ),
            centerTitle: true,
          ),
          body:
          StreamBuilder<DocumentSnapshot>(


            stream: FirebaseFirestore.instance.collection('users').doc(userId).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              namecontroller.text=snapshot.data!['fullname'];
              phonecontroller.text=snapshot.data!['phonenumber'];
              locationcontroller.text=snapshot.data!['location'];
              biocontroller.text=snapshot.data!['about'];

              if (snapshot.hasError) {
                return Center(child: Text("Error loading profile data"));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CupertinoActivityIndicator());
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Center(child: Text("Profile data not found"));
              }

              final userData = snapshot.data!.data() as Map<String, dynamic>?;

              if (userData == null) {
                return Center(child: Text("Invalid profile data"));
              }

              return
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 130.0.h,
                              width: 130.0.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: CachedNetworkImage(
                                imageUrl: "https://avatar.iran.liara.run/public/boy",
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 10,
                              child: InkWell(
                                onTap: () {
                                  // Open the camera
                                },
                                child: Container(
                                  height: 30.0.h,
                                  width: 30.0.w,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(100.0),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.edit,
                                      color: AppColors.kWhiteColor,
                                      size: 20.0.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        Text(
                          userData?['fullname'] ?? 'No name provided',
                          style: GoogleFonts.poppins(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        SizedBox(height: 32.h),
                        labelWidget(label: "Full Name *"),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          controller: namecontroller,
                          keyboardType: TextInputType.emailAddress,

                        ),

                        SizedBox(height: 20.h),
                        labelWidget(label: "Phone Number"),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          controller: phonecontroller,
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: 20.h),
                        labelWidget(label: "Location"),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          controller: locationcontroller,
                          keyboardType: TextInputType.text,
                        ),
                        SizedBox(height: 20.h),
                        labelWidget(label: "Bio"),
                        SizedBox(height: 5.h),
                        CustomTextField(

                          controller: biocontroller,
                          keyboardType: TextInputType.text,
                          isDesription: true,
                        ),
                        SizedBox(height: 20.h),
                        labelWidget(label: "Tiktok"),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          controller: tiktokcontroller,
                          keyboardType: TextInputType.url,
                        ),
                        SizedBox(height: 20.h),
                        labelWidget(label: "Linkedin"),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          controller: linkdincontroller,
                          keyboardType: TextInputType.url,
                        ),
                        SizedBox(height: 20.h),
                        labelWidget(label: "Instagram"),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          controller: instagramcontroller,
                          keyboardType: TextInputType.url,
                        ),
                        SizedBox(height: 20.h),
                        labelWidget(label: "Facebook"),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          controller: facebookcontroller,
                          keyboardType: TextInputType.url,
                        ),
                        SizedBox(height: 20.h),
                        labelWidget(label: "YouTube"),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          controller: youtubecontroller,
                          keyboardType: TextInputType.url,
                        ),
                        const SizedBox(height: 30),
                        CustomButton(
                          onPressed: () async{
                            var email=FirebaseAuth.instance.currentUser!.email;
                            EasyLoading.show(status: "please Wait");
                            NotificationService service=NotificationService();
                            UserModel userModel = UserModel(
                              youtube: youtubecontroller.text,
                              facebook: facebookcontroller.text,
                              instagram: instagramcontroller.text,
                              tiktok: tiktokcontroller.text,
                              linkdin: linkdincontroller.text,
                              uId: userId.toString(),
                              password:userData?['password'] ,
                              fullname: namecontroller.text,
                              about: biocontroller.text,
                              location: locationcontroller.text,
                              phonenumber: phonecontroller.text,
                              email:email.toString(),
                              userDeviceToken: service.getDeviceToken().toString(),
                              role: 'user',
                              isPremium: false,
                              Status: false,
                              isActive: true,
                              createdAt: DateTime.now(),
                            );

                           await FirebaseFirestore.instance.collection('users').doc(userId).update(
                              userModel.toMap()
                            );
                           EasyLoading.dismiss();
                            Get.snackbar(
                                "Success", " Profile Updated Successfully",
                                backgroundColor:
                                Colors.blue,
                                colorText:Colors.white,
                                snackPosition: SnackPosition.BOTTOM);
                           print('done');

                            // Get.offAllNamed(AppRoutes.kMainScreenRoute);
                          },
                          text: "Save Changes",
                          width: 200.w,
                          height: 42.h,
                        ),
                        SizedBox(height: 50.h),
                      ],
                    ),
                  ),
                );
            },
          ),

        );
      },
    );
  }

  Widget labelWidget({
    required String label,
  }) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 12.sp,
          fontWeight: FontWeight.w300,
          color: AppColors.kTextColor,
        ),
      ),
    );
  }
}
