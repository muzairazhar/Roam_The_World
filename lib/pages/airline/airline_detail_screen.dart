import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roam_the_world_app/models/airline_model.dart';
import 'package:roam_the_world_app/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AirlineDetailScreen extends StatelessWidget {
  const AirlineDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Airline airline = Get.arguments;

    return Scaffold(
      backgroundColor: AppColors.kWhiteColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
          child: Column(
            children: [
              Container(
                height: 240.0.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.3),
                ),
                child: Center(
                  child: Text(
                    airline.icaoCode?.substring(0, 1) ?? 'A',
                    style: GoogleFonts.poppins(
                      color: AppColors.primaryColor,
                      fontSize: 40.0.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    airline.name,
                    style: GoogleFonts.poppins(
                      fontSize: 24.sp,
                      color: AppColors.kTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: AppColors.kYellowColor,
                        size: 20.0.sp,
                      ),
                      Text(
                        "4.9", // Optional: Replace with real rating if you have it
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: AppColors.kTextColor,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "ICAO: ${airline.icaoCode ?? 'N/A'}",
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: AppColors.kTextColor,
                    ),
                  ),
                  Text(
                    "IATA: ${airline.iataCode ?? 'N/A'}",
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: AppColors.kTextColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Country: ${airline.country ?? 'Unknown'}",
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: AppColors.kTextColor,
                  ),
                ),
              ),
              SizedBox(height: 28.h),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: 3, // example reviews
                separatorBuilder: (context, index) => Column(
                  children: [
                    SizedBox(height: 10.h),
                    Divider(
                      color: AppColors.kBorderColor.withOpacity(0.5),
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
                itemBuilder: (context, index) => reviewCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget reviewCard() {
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20.0,
              backgroundImage: CachedNetworkImageProvider(
                "https://robohash.org/${DateTime.now().microsecondsSinceEpoch}?set=set4",
              ),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "User ${DateTime.now().second}", // dummy name
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    color: AppColors.kTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "April 2025",
                  style: GoogleFonts.poppins(
                    fontSize: 11.sp,
                    color: AppColors.kTextColor,
                  ),
                )
              ],
            )
          ],
        ),
        SizedBox(height: 12.h),
        Text(
          "Great airline with smooth service and friendly crew.",
          style: GoogleFonts.poppins(
            fontSize: 12.sp,
            color: AppColors.kTextColor.withOpacity(0.7),
            letterSpacing: 0.5,
          ),
        )
      ],
    );
  }
}
