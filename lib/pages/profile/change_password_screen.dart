import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roam_the_world_app/pages/profile/controller/change_password_controller.dart';
import 'package:roam_the_world_app/pages/setting/setting_screen.dart';
import 'package:roam_the_world_app/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roam_the_world_app/widgets/custom_button.dart';
import 'package:roam_the_world_app/widgets/custom_text_field.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final oldpasswordcontroller=TextEditingController();
    final newpasswordcontroller=TextEditingController();
    final confirmpasswordcontroller=TextEditingController();


     // function to change password

    Future<String?> changePassword({
      required String currentPassword,
      required String newPassword,
    }) async {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) return "No user logged in";

        // 1. REAUTHENTICATE (required)
        final cred = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(cred);

        // 2. UPDATE PASSWORD
        await user.updatePassword(newPassword);
        return null; // Success
      } on FirebaseAuthException catch (e) {
        return e.message; // Return error message
      }
    }


    return GetBuilder<ChangePasswordController>(builder: (controller) {
      return Scaffold(
        backgroundColor: AppColors.kWhiteColor,
        appBar: AppBar(
          backgroundColor: AppColors.kWhiteColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text(
            "Change Password",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
            ),
          ),
          centerTitle: true,
        ),
        body:  FutureBuilder<DocumentSnapshot>(

          future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
              FutureBuilder<DocumentSnapshot>(

                future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
                            labelWidget(label: "Old Password *"),
                            SizedBox(height: 5.h),
                            CustomTextField(
                              controller: oldpasswordcontroller,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: !controller.isOldPasswordVisible,
                              suffixIcon: !controller.isOldPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              suffixPressed: () {
                                controller.isOldPasswordVisible =
                                !controller.isOldPasswordVisible;
                                controller.update();
                              },
                            ),
                            SizedBox(height: 20.h),
                            labelWidget(label: "New Password*"),
                            SizedBox(height: 5.h),
                            CustomTextField(
                              controller: newpasswordcontroller,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: !controller.isNewPasswordVisible,
                              suffixIcon: !controller.isNewPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              suffixPressed: () {
                                controller.isNewPasswordVisible =
                                !controller.isNewPasswordVisible;
                                controller.update();
                              },
                            ),
                            SizedBox(height: 20.h),
                            labelWidget(label: "Confirm Password*"),
                            SizedBox(height: 5.h),
                            CustomTextField(
                              controller: confirmpasswordcontroller,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: !controller.isConfirmNewPasswordVisible,
                              suffixIcon: !controller.isConfirmNewPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              suffixPressed: () {
                                controller.isConfirmNewPasswordVisible =
                                !controller.isConfirmNewPasswordVisible;
                                controller.update();
                              },
                            ),
                            const SizedBox(height: 30),
                            CustomButton(
                              onPressed: () async{
                                print(userData['password']);
                                print(newpasswordcontroller.text);
                                print(oldpasswordcontroller.text);

                                EasyLoading.show(status: "please Wait");
                                if(oldpasswordcontroller.text != userData['password']){
                                  EasyLoading.dismiss();
                                  Get.snackbar(
                                      "error","Please Enter Correct Old Password",
                                      backgroundColor:
                                      Colors.red,
                                      colorText:Colors.white,
                                      snackPosition: SnackPosition.BOTTOM);

                                }else if(confirmpasswordcontroller.text != newpasswordcontroller.text){
                                  EasyLoading.dismiss();
                                  Get.snackbar(
                                      "error","Password dose not match",
                                      backgroundColor:
                                      Colors.red,
                                      colorText:Colors.white,
                                      snackPosition: SnackPosition.BOTTOM);
                                }else{
                                  final error = await changePassword(
                                    currentPassword: oldpasswordcontroller.text,
                                    newPassword: newpasswordcontroller.text,
                                  );
                                  FirebaseFirestore.instance.collection('users').doc(userId).update({
                                  'password':newpasswordcontroller.text

                                  });

                                  if (error != null) {
                                    EasyLoading.dismiss();
                                    Get.snackbar(
                                        "error",error,
                                        backgroundColor:
                                        Colors.red,
                                        colorText:Colors.white,
                                        snackPosition: SnackPosition.BOTTOM);
                                  } else {
                                    EasyLoading.dismiss();
                                    Get.offAll(SettingScreen());

                                    Get.snackbar(
                                        "Success", " Password Changed Successfully!",
                                        backgroundColor:
                                        Colors.blue,
                                        colorText:Colors.white,
                                        snackPosition: SnackPosition.BOTTOM);

                                  }
                                }
                                // In your button's onPressed:



                                // Get.offAllNamed(AppRoutes.kMainScreenRoute);
                              },
                              text: "Update Password",
                              width: 200.w,
                              height: 42.h,
                            ),
                            SizedBox(height: 50.h),
                          ],
                        ),
                      ),
                    );
                },
              );
          },
        ),

      );
    });
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
