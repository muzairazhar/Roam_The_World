import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:roam_the_world_app/services/Notifiction-Service.dart';
import 'package:roam_the_world_app/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roam_the_world_app/widgets/custom_button.dart';
import 'package:roam_the_world_app/widgets/custom_text_field.dart';

import 'controller/post_controller.dart';


class AddPostScreen extends StatefulWidget {
  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
  const AddPostScreen({super.key});

}

class _AddPostScreenState extends State<AddPostScreen> {
  late String statuss;
  late Color statusColor;

  final postController = Get.put(PostController());
  Map<String, dynamic>? userdata;


  void fetchuserdata() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users').doc(uId)
          .get();

      if (snapshot.exists) {
        setState(() {
          userdata = snapshot.data();
        });
      }
    } catch (e) {
      print('Error fetching post data: $e');
    }
  }

  late final location;
  bool _isChecked = false;
  late final String status;
  late final String locationName;
  final uId=FirebaseAuth.instance.currentUser?.uid.toString();
  final provincecontroller=TextEditingController();
  final namecontroller=TextEditingController();
  final citycontroller=TextEditingController();
  final destinationcontroller=TextEditingController();
  final airlinecontroller=TextEditingController();
  final tagscontroller=TextEditingController();
  final experiencecontroller=TextEditingController();


  List<File> selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fetchuserdata();

    // Get the arguments from the previous screen
    final args = Get.arguments;

    // Extract values from arguments
    location = args['location'];
    statusColor = Color(args['color']); // Wrap the int color value with Color()
    status = args['status']; // This should be 'been'
    locationName = args['locationName'];

  }

  //  method to pick images
  Future<void> pickImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null && images.isNotEmpty) {
      setState(() {
        selectedImages.addAll(images.map((xFile) => File(xFile.path)).toList());
      });
    }
  }

  DateTime? selectedDate;
  TextEditingController _startdateController = TextEditingController();
  TextEditingController _enddateController = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _selectstartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _startdateController.text = DateFormat('dd-MM-yyyy').format(picked); // Update TextField
      });
    }
  }
  Future<void> _selectendDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _enddateController.text = DateFormat('dd-MM-yyyy').format(picked); // Update TextField
      });
    }
  }



  @override
  Widget build(BuildContext context) {


    print(locationName);
    return Scaffold(
      backgroundColor: AppColors.kWhiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.kWhiteColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          locationName,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
                decoration: BoxDecoration(
                  color: Color(0xFFFDF4FF),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: AppColors.kBorderColor,
                  ),
                ),
                child: Text(
                  "Add Post",
                  style: GoogleFonts.poppins(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Added to: ",
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  color: AppColors.kTextColor,
                ),
              ),
              SizedBox(width: 12.h),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 5.h,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFFDF4FF),
                  borderRadius: BorderRadius.circular(100.0),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 10.w,
                      height: 10.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: statusColor, // Set dynamic color here
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      status, // Show the dynamic status here
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: AppColors.kTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

              SizedBox(height: 30.h),
              label("Add Images"),
              SizedBox(height: 12.h),
              GestureDetector(
                onTap: pickImages,
                child: Container(
                  height: 170.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: AppColors.primaryColor,
                    ),
                  ),
                  child:
                  selectedImages.isEmpty
                      ? Center(
                    child: Text(
                      "+ Add Feature Images",
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        color: AppColors.kTextColor,
                      ),
                    ),
                  )
                      :
                  Stack(
                    children: [
                      // Display the first selected image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: Image.file(
                          selectedImages[0],
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Counter showing number of selected images

                    ],
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: pickImages,
                    child: Container(
                      width: 75.w,
                      height: 75.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      child: selectedImages.length <= 1
                          ? Center(
                        child: Text(
                          "+ ",
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            color: AppColors.kTextColor,
                          ),
                        ),
                      )
                          :
                      Stack(
                        children: [
                          // Display the first selected image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: Image.file(
                              selectedImages[1],
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Counter showing number of selected images

                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: pickImages,
                    child: Container(
                      width: 75.w,
                      height: 75.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      child:
                      selectedImages.length <= 2
                          ? Center(
                        child: Text(
                          "+ ",
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            color: AppColors.kTextColor,
                          ),
                        ),
                      )
                          :
                      Stack(
                        children: [
                          // Display the first selected image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: Image.file(
                              selectedImages[2],
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Counter showing number of selected images

                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: pickImages,
                    child: Container(
                      width: 75.w,
                      height: 75.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      child:
                      selectedImages.length <= 3
                          ? Center(
                        child: Text(
                          "+",
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            color: AppColors.kTextColor,
                          ),
                        ),
                      )
                          :
                      Stack(
                        children: [
                          // Display the first selected image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: Image.file(
                              selectedImages[3],
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Counter showing number of selected images

                        ],
                      ),                    ),
                  ),
                  GestureDetector(
                    onTap: pickImages,
                    child: Container(
                      width: 100.w,
                      height: 75.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      child:
                      selectedImages.length <= 4
                          ? Center(
                        child: Text(
                          "+ ",
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            color: AppColors.kTextColor,
                          ),
                        ),
                      )
                          :
                      Stack(
                        children: [
                          // Display the first selected image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: Image.file(
                              selectedImages[4],
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Counter showing number of selected images

                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 24.h),
              label("Your Name"),
              SizedBox(height: 12.h),
              CustomTextField(
                controller: namecontroller,

              ),
              SizedBox(height: 24.h),
              label("Add Province"),
              SizedBox(height: 12.h),
              CustomTextField(
                controller: provincecontroller,

              ),
              SizedBox(height: 24.h),

              label("Add City"),
              SizedBox(height: 12.h),
              CustomTextField(
                controller: citycontroller,

              ),
              SizedBox(height: 24.h),
              label("Add Destination Name"),
              SizedBox(height: 12.h),
              CustomTextField(
                controller: destinationcontroller,
              ),
              SizedBox(height: 24.h),
              label("Add Airline"),
              SizedBox(height: 12.h),
              CustomTextField(
                controller: airlinecontroller,
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Flexible(
                    child: CustomTextField(
                      controller: _startdateController,
                      readOnly: true, // Prevents manual typing
                      hintText: "Start Date:",
                      suffixIcon: Icons.calendar_today,
                      suffixPressed: () => _selectstartDate(context),
                      onTap: () {
                        print(selectedDate.toString());
                      },


                    ),
                  ),
                  SizedBox(width: 24.h),
                  Flexible(
                    child: CustomTextField(
                      controller: _enddateController,
                      hintText: "End Date:",
                      suffixIcon: Icons.calendar_today,
                      suffixPressed: () => _selectendDate(context),
                      onTap: () {
                        print(selectedDate.toString());
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              label("Add Tags"),
              SizedBox(height: 12.h),
              CustomTextField(
                controller: tagscontroller,
                isDesription: true,
              ),
              SizedBox(height: 24.h),
              label("Share your experience"),
              SizedBox(height: 12.h),
              CustomTextField(
                controller: experiencecontroller,
                isDesription: true,
              ),
              SizedBox(height: 24.h),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(
                      height: 20.h,
                      width: 20.w,
                      child:
                      Checkbox(
                        value: _isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked = value ?? false;
                          });
                        },
                        activeColor: Colors.blue,
                        checkColor: Colors.white,
                      )
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "Allow others to contact you through this post",
                      style: GoogleFonts.poppins(
                        color: AppColors.kTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              CustomButton(
                onPressed: () async{
                  String been = status == 'Been' ? '1' : '0';
                  String want = status == 'Want' ? '1' : '0';
                  String live = status == 'Live' ? '1' : '0';
                  String lived = status == 'Lived' ? '1' : '0';

                  NotificationService notificationservice=NotificationService();
                  EasyLoading.show(status:" please wait");
                  List<String> imageUrls = await postController.uploadImages(selectedImages);
                  var province=provincecontroller.text.trim().toString();
                  var city=citycontroller.text.trim().toString();
                  var destination=destinationcontroller.text.trim().toString();
                  var airline=airlinecontroller.text.trim().toString();
                  var startDate=_startdateController.text.trim().toString();
                  var endDate=_enddateController.text.trim().toString();
                  var experience=experiencecontroller.text.trim().toString();
                  var tags=tagscontroller.text.trim().toString();
                  var name=namecontroller.text.trim().toString();
                  String userdevicetoken=await notificationservice.getDeviceToken();
                  postController.addPostToFirebase(
                      uId.toString(),
                      province,
                      city,
                       name,
                    destination,
                      airline,
                      startDate,
                      endDate,
                     experience,
                    imageUrls,
                    tags,
                    _isChecked,
                    userdevicetoken,
                    status,
                      locationName



                  );
                  print("Succesfully added");




                },
                text: "Publish",
                width: 200.w,
                height: 42.h,
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget label(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.kTextColor,
        ),
      ),
    );
  }
}
