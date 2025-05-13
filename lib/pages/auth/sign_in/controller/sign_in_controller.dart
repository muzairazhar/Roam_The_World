import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


class SignInController extends GetxController {
  bool isPasswordVisible = false;
  bool rememberMe = false;
  final _auth=FirebaseAuth.instance;


  Future<UserCredential?> SigninMethod(
      String UserEmail,
      String UserPassword,
      )
  async {
    try {
      EasyLoading.show(status: "Please Wait");
      UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(
          email: UserEmail,
          password: UserPassword
      );

      EasyLoading.dismiss();
      return userCredential;


    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      if(e.code == 'inavlid-email'){
        Get.snackbar(
            "Error",
            "Please enter correct email",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM
        );

      }
      else if(e.code == 'user-disabled'){
        EasyLoading.dismiss();
        Get.snackbar(
            "Error",
            "The user has been disabled",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM
        );
      }else if(e.code == 'user-not-found'){
        EasyLoading.dismiss();
        Get.snackbar(
            "Error",
          " No user corresponds to that email",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM
        );

      }else if(e.code == 'wrong-password'){
        EasyLoading.dismiss();
        Get.snackbar(
            "Error",
            " Password is incorrect",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM
        );

      }else if(e.code == 'invalid-credential'){
        EasyLoading.dismiss();
        Get.snackbar(
            "Error",
            "Invalid Credientials",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM
        );
      }
      else{
        print(e.toString());
      }


    }
  }
}
