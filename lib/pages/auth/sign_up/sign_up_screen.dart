import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:roam_the_world_app/pages/auth/sign_up/controller/sign_up_controller.dart';
import 'package:roam_the_world_app/routes/app_routes.dart';
import 'package:roam_the_world_app/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roam_the_world_app/widgets/custom_button.dart';
import 'package:roam_the_world_app/widgets/custom_text_field.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../services/Notifiction-Service.dart';

import '../sign_in/sign_in_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Controller = Get.put(SignUpController());
    final phonenumbercontroller=TextEditingController();
    final locationcontroller=TextEditingController();
    final fullname_controller = TextEditingController();
    final email_controller = TextEditingController();
    final password_controller = TextEditingController();
    final confirmpassword_controller = TextEditingController();

    return GetBuilder<SignUpController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.kBackgroundColor,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 50.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 120.h),
                  Text(
                    "Sign Up",
                    style: GoogleFonts.poppins(
                      fontSize: 38.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    "Let's Get Your Roam The World Account Started!",
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: AppColors.kTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Full Name*",
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w300,
                        color: AppColors.kTextColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  CustomTextField(
                    controller: fullname_controller,
                    keyboardType: TextInputType.name,
                  ),
                  SizedBox(height: 20.h),
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
                    controller: email_controller,
                    keyboardType: TextInputType.emailAddress,
                  ),
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
                    controller: password_controller,
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
                    controller: confirmpassword_controller,
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
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Phone Number",
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w300,
                        color: AppColors.kTextColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  CustomTextField(
                    controller: phonenumbercontroller,
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Location",
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w300,
                        color: AppColors.kTextColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  CustomTextField(
                    controller: locationcontroller,
                    keyboardType: TextInputType.name,
                  ),
                  SizedBox(height: 20.h),


                  CustomButton(
                    onPressed: () async {
                      // context.loaderOverlay.hide();
                      NotificationService notificationservice=NotificationService();
                      String fullname = fullname_controller.text.trim();
                      String useremail = email_controller.text.trim();
                      String password = password_controller.text.trim().toString();
                      String confirmpassword = confirmpassword_controller.text.trim().toString();
                      String userdevicetoken=await notificationservice.getDeviceToken();
                      String phonenumber=await phonenumbercontroller.text.trim().toString();
                      String location=await locationcontroller.text.trim().toString();

                      if (fullname.isEmpty || useremail.isEmpty || password.isEmpty || confirmpassword.isEmpty) {
                        Get.snackbar("Error", "Please enter all details",
                            backgroundColor:Colors.red,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM);
                      }  if (password != confirmpassword) {
                        Get.snackbar("Error", "Password dose not match",
                            backgroundColor:Colors.red,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM);
                        return;
                      }
                      else {
                        var credientials=  await Controller.SignupMethod(
                          fullname,
                          useremail,
                          password,
                          userdevicetoken,
                          phonenumber,
                          location,
                          "no about yet"

                        );
                        if(credientials != null){
                          Get.snackbar(
                              "Verification email sent",
                              "Please check your email",
                              backgroundColor: Colors.blue,
                              colorText: Colors.white,
                              snackPosition: SnackPosition.BOTTOM
                          );
                          FirebaseAuth.instance.signOut();
                          Get.offAll(()=>SignInScreen());
                        }


                      }
                    },
                    text: "Sign Up",
                    width: 200.w,
                    height: 42.h,
                  ),
                  SizedBox(height: 50.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: GoogleFonts.poppins(
                          color: AppColors.kTextColor,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.offNamed(AppRoutes.kSignInScreenRoute);
                        },
                        child: Text(
                          "Sign In",
                          style: GoogleFonts.poppins(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
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
