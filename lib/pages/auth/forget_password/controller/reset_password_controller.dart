import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:roam_the_world_app/pages/auth/sign_in/sign_in_screen.dart';


class ResetPasswordController extends GetxController {
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  final _auth=FirebaseAuth.instance;

  //   for password visibility

  Future<void> ForgotPasswordMethod(
      String UserEmail,
      )
  async {
    try {
      EasyLoading.show(status: "Please Wait");
      await _auth.sendPasswordResetEmail(email: UserEmail);
      Get.snackbar(
          "Request Sent Successfully",
          "Password rest link sent to ${UserEmail}",
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM
      );

      Get.offAll(()=>SignInScreen());



      EasyLoading.dismiss();


    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();

      Get.snackbar(
          "Error",
          e.toString(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM
      );
    }
  }
}
