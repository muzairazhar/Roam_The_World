import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roam_the_world_app/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CountryBasePostsScreen extends StatelessWidget {
  const CountryBasePostsScreen({super.key});

  Future<List<Map<String, dynamic>>> fetchCountryPosts(String country) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('country', isEqualTo: country)
          .get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception("Failed to load posts: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final String countryName = Get.arguments ?? 'Unknown Country';

    return Scaffold(
      backgroundColor: AppColors.kWhiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.kWhiteColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          countryName,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 18.sp,
            color: AppColors.kTextColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: fetchCountryPosts(countryName).asStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("No posts found for $countryName"));
            }

            final posts = snapshot.data!;
            return ListView.separated(
              itemCount: posts.length,
              separatorBuilder: (context, index) => SizedBox(height: 20.h),
              itemBuilder: (context, index) {
                final post = posts[index];
                final name = post['name'] ?? 'Unknown';
                final airline = post['airline'] ?? '';
                final experience = post['experience'] ?? '';
                final List<String> images =
                List<String>.from(post['imageUrls'] ?? []);
                final date = post['startDate'] ?? 'No date';
                final destination = post['destination'] ?? 'No destination';
                final allowContact = post['allowcontact'] ?? false;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Name + date
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 20.0,
                          backgroundImage: CachedNetworkImageProvider(
                            "https://avatar.iran.liara.run/public/boy",
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name,
                                style: GoogleFonts.poppins(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.kTextColor,
                                )),
                            Text(date,
                                style: GoogleFonts.poppins(
                                  fontSize: 11.sp,
                                  color: AppColors.kTextColor,
                                )),
                          ],
                        )
                      ],
                    ),

                    SizedBox(height: 12.h),

                    /// Airline + Destination
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _infoChip('assets/icons/airline.svg', airline),
                        Row(
                          children: [
                            SvgPicture.asset('assets/icons/location.svg',
                                height: 20.h),
                            SizedBox(width: 5.h),
                            Text(destination,
                                style: GoogleFonts.poppins(
                                  fontSize: 12.sp,
                                  color: AppColors.kTextColor,
                                )),
                          ],
                        )
                      ],
                    ),

                    SizedBox(height: 12.h),

                    Text(destination,
                        style: GoogleFonts.poppins(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.kTextColor,
                        )),

                    SizedBox(height: 12.h),

                    Text(experience,
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          color: AppColors.kTextColor.withOpacity(0.7),
                        )),

                    SizedBox(height: 12.h),

                    Wrap(
                      children: [
                        "#Lake",
                        "#Mountains",
                        "#Hilly",
                        "#Green",
                      ].map((e) => _tagsChip(text: e)).toList(),
                    ),

                    SizedBox(height: 12.h),

                    if (images.isNotEmpty)
                      Container(
                        height: 200.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(images.first),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                    SizedBox(height: 12.h),

                    if (images.length > 1)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: images
                            .skip(1)
                            .take(4)
                            .map(
                              (url) => Container(
                            height: 80.h,
                            width: 80.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(url),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                            .toList(),
                      ),

                    SizedBox(height: 12.h),

                    /// Like + Comment + Chat
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.favorite,
                                color: Colors.red, size: 18.sp),
                            SizedBox(width: 5.w),
                            Text("1.2k",
                                style: GoogleFonts.poppins(
                                  fontSize: 12.sp,
                                  color: AppColors.kTextColor,
                                )),
                            SizedBox(width: 10.w),
                            Icon(Icons.comment,
                                color: AppColors.kYellowColor, size: 18.sp),
                            SizedBox(width: 5.w),
                            Text("1.2k",
                                style: GoogleFonts.poppins(
                                  fontSize: 12.sp,
                                  color: AppColors.kTextColor,
                                )),
                          ],
                        ),
                        allowContact
                            ? InkWell(
                          onTap: () {
                            // open chat screen here
                            // you can add Get.toNamed(...) if needed
                          },
                          child: Row(
                            children: [
                              Icon(Icons.chat,
                                  color: AppColors.primaryColor,
                                  size: 18.sp),
                              SizedBox(width: 5.w),
                              Text("Chat",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.sp,
                                    color: AppColors.kTextColor,
                                  )),
                            ],
                          ),
                        )
                            : const SizedBox.shrink(),
                      ],
                    )
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _infoChip(String iconPath, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        children: [
          SvgPicture.asset(iconPath, height: 20.h),
          SizedBox(width: 5.h),
          Text(text,
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                color: AppColors.kTextColor,
              )),
        ],
      ),
    );
  }

  Widget _tagsChip({required String text}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      margin: EdgeInsets.only(right: 10.w, bottom: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: AppColors.kLightCyanColor.withOpacity(0.5),
      ),
      child: Text(text,
          style: GoogleFonts.poppins(
            fontSize: 12.sp,
            color: AppColors.kTextColor,
          )),
    );
  }
}
