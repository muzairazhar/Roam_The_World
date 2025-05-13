import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roam_the_world_app/routes/app_routes.dart';
import 'package:roam_the_world_app/utils/app_assets.dart';
import 'package:roam_the_world_app/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roam_the_world_app/widgets/post_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/restart_widget.dart';
import '../chat/chat_room_screen.dart';
import '../subscription/subscription_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();

}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Future<void> _launchURL(String? url) async {
    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No link available.")),
      );
      return;
    }

    final fixedUrl = url.startsWith('http') ? url : 'https://$url';
    final uri = Uri.tryParse(fixedUrl);

    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not open the link.")),
      );
    }
  }


  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return Scaffold(
        body: Center(child: Text("User not authenticated")),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.kWhiteColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            color: AppColors.kWhiteColor,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(AppRoutes.kSettingScreenRoute);
            },
            icon: Icon(
              Icons.settings_outlined,
              color: AppColors.kWhiteColor,
            ),
          ),
        ],
      ),
      body:

      StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error loading profile data"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CupertinoActivityIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text("Profile data not found"));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>?;

          if (userData == null) {
            return Center(child: Text("Invalid profile data"));
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    left: 30.w,
                    right: 30.w,
                    top: 150.h,
                    bottom: 30.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 130.0.h,
                        width: 130.0.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.kWhiteColor,
                            width: 12.0,
                          ),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: "https://avatar.iran.liara.run/public/boy",
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Text(
                        userData['fullname'] ?? 'No name',
                        style: GoogleFonts.poppins(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.kWhiteColor,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(userId)
                            .collection('posts')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return Text("No posts yet");
                          }

                          final posts = snapshot.data!.docs;

                          // Count posts based on status
                          int beenCount = 0;
                          int wantCount = 0;
                          int liveCount = 0;
                          int livedCount = 0;

                          for (var doc in posts) {
                            final data = doc.data() as Map<String, dynamic>;
                            final status = data['status'];
                            if (status == "Been") beenCount++;
                            if (status == "Want") wantCount++;
                            if (status == "Live") liveCount++;
                            if (status == "Lived") livedCount++;
                          }

                          // ✅ Now your Row is dynamic:
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              statsChip(
                                color: AppColors.primaryColor,
                                text: "Been",
                                stats: "$beenCount",
                              ),
                              statsChip(
                                color: AppColors.kYellowColor,
                                text: "Want",
                                stats: "$wantCount",
                              ),
                              statsChip(
                                color: Colors.red,
                                text: "Live",
                                stats: "$liveCount",
                              ),
                              statsChip(
                                color: Colors.green,
                                text: "Lived",
                                stats: "$livedCount",
                              ),
                            ],
                          );
                        },
                      ),

                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textWidget(heading: "About"),
                      SizedBox(height: 12.h),
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.kWhiteColor,
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                            color: AppColors.kBorderColor,
                          ),
                        ),
                        child: Text(
                          userData['about'] ?? 'No about information',
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            color: AppColors.kTextColor.withOpacity(0.7),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      textWidget(heading: "Social Media"),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () => _launchURL(userData['tiktok']),
                            child: SvgPicture.asset(AppAssets.tiktokIcon),
                          ),
                          InkWell(
                            onTap: () => _launchURL(userData['tiktok']),
                            child: SvgPicture.asset(AppAssets.linkedinIcon),
                          ),
                          InkWell(
                            onTap: () => _launchURL(userData['tiktok']),
                            child: SvgPicture.asset(AppAssets.instagramIcon),
                          ),
                          InkWell(
                            onTap: () => _launchURL(userData['tiktok']),
                            child: SvgPicture.asset(AppAssets.facebookIcon),
                          ),
                          InkWell(
                            onTap: () => _launchURL(userData['tiktok']),
                            child: SvgPicture.asset(AppAssets.youtubeIcon),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      textWidget(heading: "Information"),
                      SizedBox(height: 16.h),
                      Column(
                        children: [
                          infoTile(
                            icon: AppAssets.locationIcon,
                            text: userData['location'] ?? 'No location',
                          ),
                          SizedBox(height: 15.h),
                          infoTile(
                            icon: AppAssets.emailIcon,
                            text: userData['email'] ?? 'No email',
                          ),
                          SizedBox(height: 15.h),
                          infoTile(
                            icon: AppAssets.phoneIcon,
                            text: userData['phonenumber'] ?? 'No phone number',
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      textWidget(heading: "Posts"),
                      SizedBox(height: 16.h),
                      userData['isPremium']?  StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(userId)
                            .collection('posts')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return SizedBox(); // or some widget like Text("No posts")
                          }

                          final posts = snapshot.data!.docs;

                          return ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: posts.length,
                            separatorBuilder: (context, index) => Column(
                              children: [
                                SizedBox(height: 10.h),
                                Divider(
                                  color: AppColors.kBorderColor.withOpacity(0.5),
                                ),
                                SizedBox(height: 10.h),
                              ],
                            ),
                            itemBuilder: (context, index) {
                              final postId = posts[index].id;
                              print(postId);

                              return PostWidget(
                                uid: userId,
                                postId: postId,
                                onChatTap: () {
                                  Get.to(ChatRoomScreen());

                                },
                              );
                            },
                          );
                        },
                      ): Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.lock_outline, size: 60, color: Colors.blueAccent),
                              const SizedBox(height: 16),
                              Text(
                                'Go Premium to Share Your Journey!',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Posting is exclusive to premium members.\nUpgrade now and let your travels inspire others!',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: () {
                                  Get.to(() => SubscriptionScreen());
                                  // RestartWidget.restartApp(context);
                                  print("ok");

                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Upgrade to Premium',
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )



                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget statsChip({
    required Color color,
    required String text,
    required String stats,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.kWhiteColor,
        borderRadius: BorderRadius.circular(100.0),
      ),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 10.sp,
              color: AppColors.kTextColor,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            stats,
            style: GoogleFonts.poppins(
              fontSize: 10.sp,
              color: AppColors.kTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget textWidget({
    required String heading,
  }) {
    return Text(
      heading,
      style: GoogleFonts.poppins(
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.kTextColor,
      ),
    );
  }

  Widget infoTile({
    required String icon,
    required String text,
  }) {
    return Row(
      children: [
        SvgPicture.asset(icon),
        SizedBox(width: 10.w),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 15.sp,
            color: AppColors.kTextColor,
          ),
        )
      ],
    );
  }
}