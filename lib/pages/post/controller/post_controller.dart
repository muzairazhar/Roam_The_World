import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../models/postmodel.dart'; // Adjust path to your post model

class PostController extends GetxController {
  final uId = FirebaseAuth.instance.currentUser!.uid;

  // Upload multiple images and get their URLs


  Future<List<String>> uploadImages(List<File> images) async {
    List<String> downloadUrls = [];

    for (var image in images) {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = FirebaseStorage.instance.ref().child('posts/$fileName.jpg');

      // Upload the file
      UploadTask uploadTask = ref.putFile(image);

      // Wait for the upload to complete and catch errors
      try {
        TaskSnapshot snapshot = await uploadTask;

        // Get the download URL after successful upload
        final url = await snapshot.ref.getDownloadURL();

        downloadUrls.add(url);
      } catch (e) {
        print("Upload error: $e");
        Get.snackbar('Error', 'Failed to upload image');
      }
    }

    return downloadUrls;
  }
  // Add this to your PostController class
  Future<void> updatePostInFirebase(
      String postId,
      String uId,
      String province,
      String city,
      String name,
      String destination,
      String airline,
      String startDate,
      String endDate,
      String experience,
      List<File> newImages, // 📸 New images as File
      String tags,
      bool allowContact,
      ) async
  {
    try {
      EasyLoading.show(status: "Updating post...");

      final
      postRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('posts')
          .doc(postId);

      // Step 1: Get old image URLs
      final postSnapshot = await postRef.get();
      final List<dynamic> oldImageUrls = postSnapshot.data()?['imageUrls'] ?? [];

      // Step 2: Delete old images from Storage
      for (String url in oldImageUrls) {
        try {
          final ref = FirebaseStorage.instance.refFromURL(url);
          await ref.delete();
        } catch (e) {
          print("Error deleting image: $e");
        }
      }

      // Step 3: Upload new images to Storage
      List<String> newImageUrls = [];
      for (var imgFile in newImages) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('posts/${DateTime.now().millisecondsSinceEpoch}');
        await ref.putFile(imgFile);
        final url = await ref.getDownloadURL();
        newImageUrls.add(url);
      }


      // Step 4: Create new PostModel
      final post = PostModel(
        uId: uId,
        province: province,
        name: name,
        city: city,
        destination: destination,
        airline: airline,
        startDate: startDate,
        endDate: endDate,
        experience: experience,
        imageUrls: newImageUrls, // ✅ updated with new uploaded URLs
        tags: tags,
        allowcontact: allowContact,

      );



      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('uId', isEqualTo: uId)
          .get();
      print(snapshot.docs);

      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          String postDocId = doc.id;
          print(("document is ijd this $postDocId"));

          // 3. Update each found document (in case there are multiple)
          await FirebaseFirestore.instance
              .collection('posts')
              .doc(postDocId)
              .update(post.toMap());
        }
      }






      // Step 5: Update Firestore
      await postRef.update(post.toMap());
      Get.snackbar(
          "Success",
          "Post updated Successfully",
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM
      );

      print('update hpagata');

      EasyLoading.dismiss();

    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }



  // Add post to Firebase (pass imageUrls directly)
  Future<void> addPostToFirebase(
      String uId,
      String province,
      String city,
      String name,
      String destination,
      String airline,
      String startDate,
      String endDate,
      String experience,
      List<String> imageUrls,
      String tags,
      bool allowContact,
      String DeviceToken,
      String Status,
      String Country



      ) async
  {
    try {
      EasyLoading.show(status: "Please Wait");
      final post = PostModel(
          uId: uId,
          province: province,
          name:name,
          city: city,
          destination: destination,
          airline: airline,
          startDate: startDate,
          endDate: endDate,
          experience: experience,
          imageUrls: imageUrls,
          tags: tags,
          allowcontact:allowContact,
          devicetoken: DeviceToken,
          Status: Status,
        Country: Country





      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('posts')
          .add(post.toMap());
      print('add in user posts');
      await FirebaseFirestore.instance
          .collection('posts')
          .add(post.toMap());
      EasyLoading.dismiss();

      Get.snackbar(
          "Success",
          "Post Publish Successfully",
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM
      );
    } catch (e) {
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
