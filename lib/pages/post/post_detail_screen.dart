import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:roam_the_world_app/utils/app_colors.dart';

class PostDetailScreen extends StatefulWidget {
  final String? postId;

  const PostDetailScreen({Key? key, this.postId}) : super(key: key);

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late DocumentSnapshot post;

  @override
  void initState() {
    super.initState();
    _fetchPostDetails();
  }

  // Fetch post details from Firestore
  Future<void> _fetchPostDetails() async {
    var postData = await FirebaseFirestore.instance.collection('posts').doc(widget.postId).get();
    setState(() {
      post = postData;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (post == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Post Details'),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Get image URLs from Firestore data
    List<dynamic> imageUrls = post['imageUrls'] ?? [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kWhiteColor,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "Post Details",
          style: GoogleFonts.poppins(color: AppColors.kTextColor),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Image Slider
              imageUrls.isNotEmpty
                  ? CarouselSlider.builder(
                itemCount: imageUrls.length,
                itemBuilder: (BuildContext context, int index, int realIndex) {
                  return CachedNetworkImage(
                    imageUrl: imageUrls[index],
                    height: 250.0.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  );
                },
                options: CarouselOptions(
                  enlargeCenterPage: true,
                  aspectRatio: 2.0,
                  viewportFraction: 1.0,
                  autoPlay: true,
                ),
              )
                  : SizedBox.shrink(), // Handle case where no images are available
              SizedBox(height: 15.0.h),

              // Destination Title
              Text(
                post['destination'] ?? 'No destination',
                style: GoogleFonts.poppins(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.kTextColor,
                ),
              ),
              SizedBox(height: 10.0.h),

              // Tags (if available)
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Airline: ',  // Airline label
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold, // Make 'Airline:' bold
                    color: AppColors.kTextColor,
                  ),
                ),
                TextSpan(
                  text: post['airline'] ?? 'No airline available',
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.normal, // Regular weight for the airline details
                    color: AppColors.kTextColor.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),


              SizedBox(height: 20.0.h),

              // Experience Details
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Experience: ',  // Experience text
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold, // Make 'Experience:' bold
                        color: AppColors.kTextColor,
                      ),
                    ),
                    TextSpan(
                      text: '${post['experience'] ?? 'No experience details'}',  // Experience details
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.normal, // Regular weight for the experience details
                        color: AppColors.kTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0.h),

              // Date Range
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Start Date: ',  // Start Date label
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold, // Make 'Start Date:' bold
                            color: AppColors.kTextColor,
                          ),
                        ),
                        TextSpan(
                          text: '${post['startDate'] ?? 'No start date'}',  // Start Date value
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.normal, // Regular weight for the start date value
                            color: AppColors.kTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'End Date: ',  // End Date label
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold, // Make 'End Date:' bold
                            color: AppColors.kTextColor,
                          ),
                        ),
                        TextSpan(
                          text: '${post['endDate'] ?? 'No end date'}',  // End Date value
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.normal, // Regular weight for the end date value
                            color: AppColors.kTextColor,
                          ),
                        ),
                      ],
                    ),
                  )
                  ,
                ],
              ),
              SizedBox(height: 20.0.h),

              // Location (Country, Province, City)
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Location: ',  // Location label
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold, // Make 'Location:' bold
                        color: AppColors.kTextColor,
                      ),
                    ),
                    TextSpan(
                      text: '${post['destination']}, ${post['province']}, ${post['city']}',
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.normal, // Regular weight for the location values
                        color: AppColors.kTextColor,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30.0.h),

              // Add more post details as needed
            ],
          ),
        ),
      ),
    );
  }
}
