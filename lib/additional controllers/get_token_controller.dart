import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';


class GeTDevicetokenController extends GetxController{
  String? devicetoken;

  void onInit(){
    super.onInit();
    getdevicetoken();
  }


  Future<void>  getdevicetoken() async{
    try{
      String? token=await FirebaseMessaging.instance.getToken();
      if(token !=null){
        devicetoken=token;
        print("token:$devicetoken");
        update();
      }

    }catch(e){
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