import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:roam_the_world_app/models/postmodel.dart';
import 'package:roam_the_world_app/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roam_the_world_app/widgets/custom_button.dart';
import 'package:roam_the_world_app/widgets/custom_text_field.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'controller/post_controller.dart';

class EditPostScreen extends StatefulWidget {
  final PostModel post;
  final String postId;

  const EditPostScreen({
    super.key,
    required this.post,
    required this.postId,
  });

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  // List<File> selectedImages = [];
  final PostController _postController = Get.put(PostController());
  late TextEditingController _provinceController;
  late TextEditingController _cityController;
  late TextEditingController _destinationController;
  late TextEditingController _airlineController;
  late TextEditingController _tagsController;
  late TextEditingController _experienceController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;

  bool _isChecked = false;
  List<File> _selectedImages = [];
  List<String> _existingImageUrls = [];
  final ImagePicker _picker = ImagePicker();
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing post data
    _provinceController = TextEditingController(text: widget.post.province);
    _cityController = TextEditingController(text: widget.post.city);
    _destinationController = TextEditingController(text: widget.post.destination);
    _airlineController = TextEditingController(text: widget.post.airline);
    _tagsController = TextEditingController(text: widget.post.tags);
    _experienceController = TextEditingController(text: widget.post.experience);
    _startDateController = TextEditingController(text: widget.post.startDate);
    _endDateController = TextEditingController(text: widget.post.endDate);
    _isChecked = widget.post.allowcontact;
    _existingImageUrls = widget.post.imageUrls;
  }

  @override
  void dispose() {
    _provinceController.dispose();
    _cityController.dispose();
    _destinationController.dispose();
    _airlineController.dispose();
    _tagsController.dispose();
    _experienceController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> pickImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null && images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images.map((xFile) => File(xFile.path)).toList());
      });
    }
  }


  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedStartDate = picked;
        _startDateController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedEndDate ?? (_selectedStartDate ?? DateTime.now()),
      firstDate: _selectedStartDate ?? DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedEndDate = picked;
        _endDateController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  Future<void> _updatePost() async {
    print('enter int his');
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      EasyLoading.showError("User not logged in");
      return;
    }
   print('ok uzair');
    EasyLoading.show(status: "Updating post...");

    try {
      // Upload new images if any
      List<String> newImageUrls = [];
      print('this is ne image urls ${newImageUrls.toString()}');
      print('trhis is selected image urls $_selectedImages');
      if (_selectedImages.isNotEmpty) {
        print('trhis is selected image urls $_selectedImages');
        newImageUrls = await _postController.uploadImages(_selectedImages);
      }

      // Combine existing and new image URLs
      final allImageUrls = [..._existingImageUrls, ...newImageUrls];

      // Update the post in Firebase
      print('updating....');
      await _postController.updatePostInFirebase(
        widget.postId!,
        user.uid,
        _provinceController.text.trim(),
        _cityController.text.trim(),
        user.displayName ?? "Unknown User",
        _destinationController.text.trim(),
        _airlineController.text.trim(),
        _startDateController.text.trim(),
        _endDateController.text.trim(),
        _experienceController.text.trim(),
          _selectedImages,
        _tagsController.text.trim(),
        _isChecked,
      );
      print('after');
      print(widget.postId);


      EasyLoading.dismiss();
      Get.back(); // Return to previous screen after successful update
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Widget _buildImagePreview() {
    if (_existingImageUrls.isEmpty) return SizedBox(); // Nothing to show

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Current Images"),
        SizedBox(height: 12.h),
        SizedBox(
          height: 170.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _existingImageUrls.length, // Only existing images
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: CachedNetworkImage(
                    imageUrl: _existingImageUrls[index],
                    width: 170.w,
                    height: 170.h,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Container(
                      width: 170.w,
                      height: 170.h,
                      color: Colors.grey,
                      child: Icon(Icons.error, color: Colors.red),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 12.h),
      ],
    );
  }


  Widget _buildImageAddButton() {
    return Column(
      children: [
        // _buildLabel("Add More Images"),
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
            _selectedImages.isEmpty
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
                    _selectedImages[0],
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
                child: _selectedImages.length <= 1
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
                        _selectedImages[1],
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
                _selectedImages.length <= 2
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
                        _selectedImages[2],
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
                _selectedImages.length <= 3
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
                        _selectedImages[3],
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
                _selectedImages.length <= 4
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
                        _selectedImages[4],
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
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.kWhiteColor,
        elevation: 0,
        title: Text(
          "Edit Post",
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
              _buildImagePreview(),
              _buildImageAddButton(),
              SizedBox(height: 12.h),

              SizedBox(height: 24.h),
              _buildLabel("Province"),
              SizedBox(height: 12.h),
              CustomTextField(
                controller: _provinceController,
              ),

              SizedBox(height: 24.h),
              _buildLabel("City"),
              SizedBox(height: 12.h),
              CustomTextField(
                controller: _cityController,
              ),

              SizedBox(height: 24.h),
              _buildLabel("Destination Name"),
              SizedBox(height: 12.h),
              CustomTextField(
                controller: _destinationController,
              ),

              SizedBox(height: 24.h),
              _buildLabel("Airline"),
              SizedBox(height: 12.h),
              CustomTextField(
                controller: _airlineController,
              ),

              SizedBox(height: 24.h),
              Row(
                children: [
                  Flexible(
                    child: CustomTextField(
                      controller: _startDateController,
                      readOnly: true,
                      hintText: "Start Date",
                      suffixIcon: Icons.calendar_today,
                      suffixPressed: () => _selectStartDate(context),
                    ),
                  ),
                  SizedBox(width: 24.h),
                  Flexible(
                    child: CustomTextField(
                      controller: _endDateController,
                      readOnly: true,
                      hintText: "End Date",
                      suffixIcon: Icons.calendar_today,
                      suffixPressed: () => _selectEndDate(context),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24.h),
              _buildLabel("Tags"),
              SizedBox(height: 12.h),
              CustomTextField(
                controller: _tagsController,
                isDesription: true,
              ),

              SizedBox(height: 24.h),
              _buildLabel("Experience"),
              SizedBox(height: 12.h),
              CustomTextField(
                controller: _experienceController,
                isDesription: true,
              ),

              SizedBox(height: 24.h),
              Row(
                children: [
                  Checkbox(
                    value: _isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        _isChecked = value ?? false;
                      });
                    },
                    activeColor: AppColors.primaryColor,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "Allow others to contact you",
                    style: GoogleFonts.poppins(
                      color: AppColors.kTextColor,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24.h),
              CustomButton(
                onPressed: _updatePost,
                text: "Update Post",
                width: 200.w,
                height: 42.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.kTextColor,
        ),
      ),
    );
  }
}