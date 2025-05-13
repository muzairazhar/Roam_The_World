import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:roam_the_world_app/models/user-model.dart';

import '../../../../additional controllers/get_token_controller.dart';

class SignUpController extends GetxController {
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  final _auth=FirebaseAuth.instance;
  final _firestore=FirebaseFirestore.instance;

  //   for password visibility

  Future<UserCredential?> SignupMethod(
      String fullname,
      String UserEmail,
      String UserPassword,
      String UserDeviceToken,
      String phonenumber,
      String location,
      String about
      ) async
  {
    try {
      EasyLoading.show(status: "please wait");
      final  GeTDevicetokenController geTDevicetokenController=Get.put(GeTDevicetokenController());

      // context.loaderOverlay.show();
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
          email: UserEmail,
          password: UserPassword
      );

      // Send Email Verification
      await userCredential.user!.sendEmailVerification();


      UserModel userModel = UserModel(

        uId: userCredential.user!.uid,
        fullname: fullname,
        about: about,
        location: location,
        phonenumber: phonenumber,
        email: UserEmail,
        password:UserPassword,
        userDeviceToken: geTDevicetokenController.devicetoken.toString(),
        linkdin: " ",
        tiktok: " ",
        instagram: " ",
        facebook: " ",
        youtube: " ",
        role: "user",
        isActive: true,
        isPremium: false,
        Status: false,
        createdAt: DateTime.now(),
      );

      // add  data into database
      _firestore.collection('users').doc(userCredential.user!.uid).set(
          userModel.toMap()
      );
      print("Database Created Successfully");
      EasyLoading.dismiss();
      // context.loaderOverlay.hide();
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

      }else if(e.code == 'user-disabled'){
        Get.snackbar(
            "Error",
            "The user has been disabled",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM
        );
      }else if(e.code == 'user-not-found'){
        Get.snackbar(
            "Error",
            " No user corresponds to that email",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM
        );

      }else if(e.code == 'wrong-password'){
        Get.snackbar(
            "Error",
            " Password is incorrect",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM
        );

      }else if(e.code == 'weak-password'){
        EasyLoading.dismiss();
        Get.snackbar(
            "Error",
            " Password is not strong enough",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM
        );

      }else if(e.code == 'email-already-in-use'){
        EasyLoading.dismiss();
        Get.snackbar(
            "Error",
            "Email already exists",
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
