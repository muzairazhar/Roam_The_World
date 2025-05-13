import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roam_the_world_app/pages/chat/chat_room_screen.dart';
import 'package:roam_the_world_app/pages/post/post_detail_screen.dart';
import 'package:roam_the_world_app/pages/subscription/subscription_screen.dart';
import 'package:roam_the_world_app/services/Notifiction-Service.dart';
import 'package:roam_the_world_app/services/get_service_key.dart';
import 'package:roam_the_world_app/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roam_the_world_app/utils/app_assets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'FullProfileImageScreen_widget.dart';

class AllUserPost extends StatefulWidget {
  final String? uid;
  final String? postId;
  final void Function()? onChatTap;

  const AllUserPost({
    super.key,
    this.uid,
    this.postId,
    this.onChatTap,
  });

  @override
  State<AllUserPost> createState() => _AllUserPostState();
}

class _AllUserPostState extends State<AllUserPost> {
  NotificationService notificationService = NotificationService();
  GetServerKey getServerKey = GetServerKey();

  void initState() {
    super.initState();
    GetServerKey.getServerKeyToken();
    notificationService.requestNotificationService();
    notificationService.getDeviceToken();
    notificationService.firebaseInit(context);
    notificationService.setupInterractMessage(context);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  final userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("user taps on post");
      },
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .snapshots(), // 🔥 Listen to Post document changes
        builder: (context, postSnapshot) {
          if (postSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!postSnapshot.hasData || !postSnapshot.data!.exists) {
            return const Center(child: Text('Post not found'));
          }

          final postData = postSnapshot.data!.data() as Map<String, dynamic>;

          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(widget.uid)
                .snapshots(), // 🔥 Listen to User document changes
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                return const Center(child: Text('User not found'));
              }

              final userData =
                  userSnapshot.data!.data() as Map<String, dynamic>;

              return buildPostUI(postData, userData);
            },
          );
        },
      ),
    );
  }

  Widget buildPostUI(
      Map<String, dynamic> postData, Map<String, dynamic> userData) {
    final name = postData['name'] ?? 'Unknown';
    final cname = userData['fullname'] ?? 'Unknown';
    final allowContact = postData['allowcontact'] ?? false;
    final airline = postData['airline'] ?? '';
    final experience = postData['experience'] ?? '';
    final List<String> images = List<String>.from(postData['imageUrls'] ?? []);
    final String date = postData['startDate'] ?? 'No date';
    final String destination = postData['destination'] ?? 'No destination';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profile Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FullProfileImageScreen(
                          imageUrl: "https://avatar.iran.liara.run/public/boy",
                        ),
                      ),
                    );
                  },
                  child: Hero(
                    tag: 'profile_${widget.uid}',
                    child: CircleAvatar(
                      radius: 20.0,
                      backgroundImage: CachedNetworkImageProvider(
                        "https://avatar.iran.liara.run/public/boy",
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${postData['uId'] == userId ? cname : name}${postData['uId'] == userId ? ' (You)' : ''}',
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        color: AppColors.kTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      date,
                      style: GoogleFonts.poppins(
                        fontSize: 11.sp,
                        color: AppColors.kTextColor,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),

        SizedBox(height: 12.h),

        // Airline and Location
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    AppAssets.airlineIcon,
                    height: 20.h,
                  ),
                  SizedBox(width: 5.h),
                  Text(
                    airline,
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: AppColors.kTextColor,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                SvgPicture.asset(
                  AppAssets.locationIcon,
                  height: 20.h,
                ),
                SizedBox(width: 5.h),
                Text(
                  destination,
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: AppColors.kTextColor,
                  ),
                ),
              ],
            ),
          ],
        ),

        SizedBox(height: 12.h),

        // Destination Title
        Text(
          destination,
          style: GoogleFonts.poppins(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.kTextColor,
          ),
        ),

        SizedBox(height: 12.h),

        // Experience
        Text(
          experience,
          style: GoogleFonts.poppins(
            fontSize: 12.sp,
            color: AppColors.kTextColor.withOpacity(0.7),
            letterSpacing: 0.5,
          ),
        ),

        SizedBox(height: 12.h),

        // Tags (Hardcoded for now)
        Wrap(
          children: ["#Lake", "#Mountains", "#Hilly", "#Green"]
              .map((e) => tagsChip(text: e))
              .toList(),
        ),

        SizedBox(height: 2.h),

        // Main Image
        if (images.isNotEmpty)
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => Dialog(
                  backgroundColor: Colors.transparent,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: InteractiveViewer(
                      child: CachedNetworkImage(
                        imageUrl: images.first,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              );
            },
            child: Container(
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
          ),

        SizedBox(height: 12.h),

        // Other Images
        if (images.length > 0)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: images
                .skip(1)
                .take(4)
                .map(
                  (url) => InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => Dialog(
                          backgroundColor: Colors.transparent,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: InteractiveViewer(
                              child: CachedNetworkImage(
                                imageUrl: url,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
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
                  ),
                )
                .toList(),
          ),

        SizedBox(height: 12.h),

        // Like, Comment, Chat Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Like and Comment
            Row(
              children: [
                Icon(
                  FontAwesomeIcons.solidHeart,
                  color: Colors.red,
                  size: 18.sp,
                ),
                SizedBox(width: 5.w),
                Text(
                  "1.2k",
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: AppColors.kTextColor,
                  ),
                ),
                SizedBox(width: 10.w),
                Icon(
                  FontAwesomeIcons.solidComment,
                  color: AppColors.kYellowColor,
                  size: 18.sp,
                ),
                SizedBox(width: 5.w),
                Text(
                  "1.2k",
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: AppColors.kTextColor,
                  ),
                ),
              ],
            ),

            // Chat Button

            allowContact && postData['uId'] != userId
                ? InkWell(
                    onTap: () {
                      if (userData['isPremium']) {
                        // Navigate to chat screen
                        String roomId = chatRoomId(
                          userData['fullname'],
                          postData['name'],
                        );
                        print('username is ${postData['name']}');
                        print(
                            'here is the current username ${userData['fullname']}');
                        print(
                            'here is the post owner name ${postData['name']}');
                        print('here is the room id $roomId');

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatRoomScreen(
                              chatRoomId: roomId,
                              postMap: postData,
                              userMap: userData,
                              currentusername: userData['fullname'],
                            ),
                          ),
                        );
                      } else {
                        // Show your custom code (e.g., dialog, snackbar)
                        showPremiumPlanPopup(context);
                      }
                    },
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.solidMessage,
                          color: AppColors.primaryColor,
                          size: 18.sp,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          "Chat",
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            color: AppColors.kTextColor,
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
          ],
        ),
      ],
    );
  }

  void showPremiumPlanPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, size: 60, color: Colors.blueAccent),
                const SizedBox(height: 20),
                Text(
                  'Go Premium',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Unlock all premium features with one of our plans!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 30),

                /// Monthly Plan Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Get.to(SubscriptionScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text(
                    'Monthly - \$3',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 12),

                /// Yearly Plan Button
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Get.to(SubscriptionScreen());
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blueAccent,
                    side: BorderSide(color: Colors.blueAccent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text(
                    'Yearly - \$34',
                    style: TextStyle(fontSize: 16),
                  ),
                ),

                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Maybe later',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              ],
            ),
          ),
        );
      },
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
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 12.sp,
          color: AppColors.kTextColor,
        ),
      ),
    );
  }
}
