import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roam_the_world_app/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.kWhiteColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          "Privacy Policy",
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('1. Types of Data We Collect'),
              _buildSectionContent(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.'),
              _buildSectionContent(
                  'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.'),
              SizedBox(height: 20),
              _buildSectionTitle('2. Use of Your Personal Data'),
              _buildSectionContent(
                  'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, sjdfhgkjsdh fkjsdh fkjsdhf kjkhsdlfj hsdkfj hksjdhf kjsdhf kjshdfkj hsdkjf hsdkjf h totam rem aperiam.'),
              _buildSectionContent(
                  'Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit.'),
              SizedBox(height: 20),
              _buildSectionTitle('3. Disclosure of Your Personal Data'),
              _buildSectionContent(
                  'At vero eos et accusamus et iusto odio  sdjhgfsjedhfjksdhfhjsd dkhf ksdhf khsdkf hksdhf ksdhfk hsdkfjh sdkfh ksdhf kshdf ksdhf kshdignissimos ducimus qui blanditiis  ssseeexx qawdras kldjh falaskjdl;kasjd;jas;d;aslked;lajrdf;alwked;lkasd praesentium voluptatum deleniti atque corrupti quos dolores.'),
              _buildSectionContent(
                  'Et harum quidem rerum facilis asdfasdasdasd ajsfhdajb jhas jnbasjdk nasjdh ajsndj hasjdbn uahsndj nasjhd jasbfhasjnb ah ihaskfh asijd kasd iuaskdh aishdj jkash iajkfh aiksf jdkashdfk est et expedita distinctio.'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Text(
        content,
        style: GoogleFonts.poppins(
          fontSize: 14.sp,
          color: AppColors.kTextColor,
        ),
      ),
    );
  }
}
