import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roam_the_world_app/pages/post/edit_post_screen.dart';
import 'package:roam_the_world_app/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roam_the_world_app/utils/app_assets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/postmodel.dart';


class PostWidget extends StatefulWidget {
  final String? uid;
  final String? postId;
  final void Function()? onChatTap;

  const PostWidget({
    super.key,
    this.uid,
    this.postId,
    this.onChatTap,
  });

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.uid == null || widget.postId == null) {
      return const Text('Invalid post');
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .collection('posts')
          .doc(widget.postId)
          .snapshots(),
      builder: (context, postSnapshot) {
        if (!postSnapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final postData = postSnapshot.data!.data() as Map<String, dynamic>?;

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.uid)
              .snapshots(),
          builder: (context, userSnapshot) {
            if (!userSnapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final userdata = userSnapshot.data!.data() as Map<String, dynamic>?;

            if (postData == null || userdata == null) {
              return const Text("Post not found");
            }

            // Destructure needed data
            final name = userdata['fullname'] ?? 'Unknown';
            final allowContact = postData['allowcontact'] ?? false;
            final airline = postData['airline'] ?? '';
            final experience = postData['experience'] ?? '';
            final List<String> images = List<String>.from(postData['imageUrls'] ?? []);
            final date = postData['startDate'] ?? 'No date';
            final destination = postData['destination'] ?? 'No destination';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header: avatar + name + date + edit
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                    GestureDetector(
                      onTap: () {
                        final postModel = PostModel(
                          uId: widget.uid ?? '',
                          province: postData['province'] ?? '',
                          city: postData['city'] ?? '',
                          destination: postData['destination'] ?? '',
                          airline: postData['airline'] ?? '',
                          startDate: postData['startDate'] ?? '',
                          endDate: postData['endDate'] ?? '',
                          experience: postData['experience'] ?? '',
                          imageUrls: List<String>.from(postData['imageUrls'] ?? []),
                          tags: postData['tags'] ?? '',
                          allowcontact: postData['allowcontact'] ?? false,
                          name: userdata['fullname'] ?? 'Unknown',
                        );

                        Get.to(() => EditPostScreen(
                          post: postModel,
                          postId: widget.postId!,
                        ));
                      },
                      child: Row(
                        children: [
                          Icon(FontAwesomeIcons.penToSquare,
                              color: AppColors.kTextColor, size: 18.sp),
                          SizedBox(width: 5.w),
                          Text("Edit Post",
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                color: AppColors.kTextColor,
                              )),
                        ],
                      ),
                    )
                  ],
                ),

                SizedBox(height: 12.h),

                /// Airline and Destination row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoChip(AppAssets.airlineIcon, airline),
                    Row(
                      children: [
                        SvgPicture.asset(AppAssets.locationIcon, height: 20.h),
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
                  ].map((e) => tagsChip(text: e)).toList(),
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

                /// Like / Comment / Chat
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(FontAwesomeIcons.solidHeart,
                            color: Colors.red, size: 18.sp),
                        SizedBox(width: 5.w),
                        Text("1.2k",
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              color: AppColors.kTextColor,
                            )),
                        SizedBox(width: 10.w),
                        Icon(FontAwesomeIcons.solidComment,
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
                      onTap: widget.onChatTap,
                      child: Row(
                        children: [
                          Icon(FontAwesomeIcons.solidMessage,
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

  Widget tagsChip({required String text}) {
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
