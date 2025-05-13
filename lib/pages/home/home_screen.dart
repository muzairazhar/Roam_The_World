import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roam_the_world_app/pages/chat/chat_room_screen.dart';
import 'package:roam_the_world_app/services/FcmService.dart';
import 'package:roam_the_world_app/services/Notifiction-Service.dart';
import 'package:roam_the_world_app/services/get_service_key.dart';
import 'package:roam_the_world_app/utils/app_assets.dart';
import 'package:roam_the_world_app/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roam_the_world_app/widgets/all_user_post.dart';
import 'package:roam_the_world_app/widgets/custom_text_field.dart';
import 'package:geocoding/geocoding.dart';
import 'package:roam_the_world_app/widgets/post_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationService notificationService = NotificationService();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  String currentLocation = ""; // <-- store the fetched location
  String locationName = ""; // <-- store the fetched location
  TextEditingController _searchController = TextEditingController(); // TextController for search
  List<QueryDocumentSnapshot> filteredPosts = [];

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    GetServerKey.getServerKeyToken();
    notificationService.getDeviceToken();
    FcmService.firebaseinit();
    notificationService.requestNotificationService();

    // Initialize filtered posts
    filteredPosts = [];
  }

  Future<void> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          locationName = "Location services are disabled. Please enable them in your device settings.";
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        final String? city = place.locality;
        final String? subAdmin = place.subAdministrativeArea;
        final String? admin = place.administrativeArea;
        final String? country = place.country;

        setState(() {
          locationName = city ?? subAdmin ?? admin ?? country ?? "Could not determine the specific location.";
        });
      } else {
        setState(() {
          locationName = "Unable to retrieve detailed location information.";
        });
      }
    } catch (e) {
      setState(() {
        locationName = "An unexpected error occurred: ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      backgroundColor: AppColors.kWhiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.kWhiteColor,
        elevation: 0.0,
        centerTitle: true,
        actions: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: CachedNetworkImage(
                imageUrl: "https://robohash.org/ccd4199abf062e84277adf15d310a9af?set=set4&bgset=&size=400x400",
                height: 40.0.h,
                width: 40.0.w,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 10.0.w),
        ],
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on, size: 20.0.sp, color: Colors.red),
              SizedBox(width: 5.0.w),
              Text(
                locationName,
                style: GoogleFonts.poppins(
                  color: AppColors.kTextColor,
                  fontSize: 16.0.sp,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
          child: Column(
            children: [
              banner(),
              SizedBox(height: 30,),// <-- Add banner widget here
              CustomTextField(
                controller: _searchController,
                hintText: "Search your next destinations",
                prefixIcon: Icons.search,
                radius: 10.0,
                onChanged: (value) {
                  filterPosts(value); // Call filter method when search text changes
                },
              ),
              SizedBox(height: 30.0.h),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
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

                  return filteredPosts.isEmpty && _searchController.text.isNotEmpty
                      ? Center(
                    child: Text(
                      "No results found.",
                      style: TextStyle(
                        fontSize: 18.0.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.kTextColor,
                      ),
                    ),
                  )
                      : ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: filteredPosts.isEmpty ? posts.length : filteredPosts.length,
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
                      final post = filteredPosts.isEmpty ? posts[index] : filteredPosts[index];
                      final postId = post.id;

                      return AllUserPost(
                        uid: userId,
                        postId: postId,
                        onChatTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatRoomScreen(

                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to filter posts based on destination
  void filterPosts(String query) {
    setState(() {
      filteredPosts = [];
    });

    FirebaseFirestore.instance
        .collection('posts')
        .where('destination', isGreaterThanOrEqualTo: query)
        .where('destination', isLessThanOrEqualTo: query + '\uf8ff')
        .get()
        .then((snapshot) {
      setState(() {
        filteredPosts = snapshot.docs;
      });
    });
  }

  // Banner widget displaying personalized greeting
  Widget banner() {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return SizedBox.shrink();

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              gradient: LinearGradient(
                colors: [
                  AppColors.kLightBlueColor.withOpacity(0.2),
                  AppColors.kLightCyanColor.withOpacity(0.5)
                ],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Good Morning, \n${snapshot.data!['fullname']}",
                      style: GoogleFonts.poppins(
                        height: 1.2,
                        color: AppColors.kTextColor,
                        fontSize: 24.0.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6.0.h),
                    Text(
                      "Where do you wanna go next?",
                      style: GoogleFonts.poppins(
                        color: AppColors.kTextColor,
                        fontSize: 13.0.sp,
                      ),
                    ),
                  ],
                ),
                Image.asset(AppAssets.homeBanner, height: 73.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget chip({ String? text, required bool isSelected}) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8.0.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : AppColors.kWhiteColor,
          borderRadius: BorderRadius.circular(8.0.r),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColors.kBorderColor,
          ),
        ),
        child: Center(
          child: Text(
            text!,
            style: GoogleFonts.poppins(
                fontSize: 14
            ),
          ),
        ),
      ),
    );
  }
}
