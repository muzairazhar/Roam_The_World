import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roam_the_world_app/pages/main/main_screen.dart';
import 'package:roam_the_world_app/routes/app_routes.dart';
import 'package:roam_the_world_app/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roam_the_world_app/widgets/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roam_the_world_app/widgets/custom_text_field.dart';

import '../sign_up/controller/getuserdata_controller.dart';
import '../../home/home_screen.dart';
import 'controller/sign_in_controller.dart';


class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignInController());
    final userdatacontroller=Get.put(UserController());
    final emailcontroller = TextEditingController();
    final passwordcontroller = TextEditingController();

    return GetBuilder<SignInController>(
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
                    "Log In",
                    style: GoogleFonts.poppins(
                      fontSize: 38.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    "Welcome Back to your Roam The World Account",
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
                    controller: emailcontroller,
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
                    controller: passwordcontroller,
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
                  SizedBox(height: 15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: Checkbox(
                              value: controller.rememberMe,
                              onChanged: (value) {
                                controller.rememberMe = value!;
                                controller.update();
                              },
                              activeColor: Colors.blue,
                              checkColor: Colors.white,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            "Remember me",
                            style: GoogleFonts.poppins(
                              color: AppColors.kTextColor,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          Get.toNamed(AppRoutes.kForgetPasswordScreenRoute);
                        },
                        child: Text(
                          "Forgot Password?",
                          style: GoogleFonts.poppins(
                            color: AppColors.kTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    onPressed: () async{
                      FirebaseFirestore.instance.collection('users').doc('2').set({
                        'name':'name',
                        'fname':'azhar'
                      });
                      print('success');

                      String useremail = emailcontroller.text.trim();
                      String password = passwordcontroller.text.trim().toString();

                      if (useremail.isEmpty || password.isEmpty) {
                        Get.snackbar("Error", "Please enter all details",
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM);
                      }
                      else {
                        var credientials = await controller.SigninMethod(useremail,password);
                        // var userdata = await userdatacontroller.getUserdata(credientials!.user!.uid);

                        if (credientials != null) {
                          // print("userdata ${userdata}");

                          if (credientials.user!.emailVerified) {
                            Get.snackbar(
                                "Success", " User Login Successfully!",
                                backgroundColor:
                                Colors.blue,
                                colorText:Colors.white,
                                snackPosition: SnackPosition.BOTTOM);
                            Get.off(() => MainScreen());

                            // if (userdata[0]['isAdmin'] == true) {
                            //   Get.offAll(() => AdminMainScreen());
                            //   Get.snackbar(
                            //       "Success ", " Admin Login Successfully!",
                            //       backgroundColor:
                            //           AppConstant.AppSecondaryColour,
                            //       colorText: AppConstant.AppTextColour,
                            //       snackPosition: SnackPosition.BOTTOM);
                            // }
                            // else {
                            //
                            // }
                          } else {
                            Get.snackbar("Verification email sent",
                                "Please verify your email before login",
                                backgroundColor: Colors.red,
                                colorText:  Colors.white,
                                snackPosition: SnackPosition.BOTTOM);
                          }
                        }
                        else {
                          Get.snackbar("Error", "Please try again",
                              backgroundColor:  Colors.red,
                              colorText:  Colors.white,
                              snackPosition: SnackPosition.BOTTOM);
                        }
                      }
                      // Get.offAllNamed(AppRoutes.kMainScreenRoute);
                    },
                    text: "Log In",
                    width: 200.w,
                    height: 42.h,
                  ),
                  SizedBox(height: 50.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: GoogleFonts.poppins(
                          color: AppColors.kTextColor,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.offAllNamed(AppRoutes.kSignUpScreenRoute);
                        },
                        child: Text(
                          "Sign Up",
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


