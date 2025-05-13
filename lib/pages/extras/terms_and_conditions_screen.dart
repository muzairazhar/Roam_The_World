import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roam_the_world_app/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roam_the_world_app/widgets/custom_button.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.kWhiteColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          "Terms & Conditions",
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
              _buildParagraph(
                  "Welcome to Roam The World! Your privacy matters to us, and we are committed to protecting your personal information. This Privacy Policy outlines how we collect, use, and safeguard your data when you use our travel and tour mobile application (“App”)."),
              _buildParagraph(
                  "Welcome Roam The World, welcome! We are committed to safeguarding your confidential data because we respect your privacy. This privacy statement describes how we gather, process, and protect your information when you use our mobile application for travel and tours (\"App\")."),
              SizedBox(height: 20.h),

              _buildSectionTitle("1. Information We Gather"),
              _buildBullet("Personal Information: Name, phone number, email address, profile information, and booking payment details."),
              _buildBullet("Location Information: GPS-based information to offer nearby attractions, travel advice, and navigation support."),
              _buildBullet("Usage Data: Information on how you use the app, such as travel searches, places you've visited, and preferences."),
              _buildBullet("Device Information: Details about the type of device, operating system, browser, and IP address that are used to optimise the performance of an application."),
              _buildBullet("Communication Data: Details gleaned from queries, comments, and customer service exchanges."),

              SizedBox(height: 20.h),
              _buildSectionTitle("2. How Your Information Is Used"),
              _buildBullet("Offer trip Services: Make trip arrangements, suggestions, and reservations easier."),
              _buildBullet("Customise travel recommendations based on past activities and preferences to improve the user experience."),
              _buildBullet("Enhance the functionality of the app by analysing user interactions to provide new features and maximise efficiency."),
              _buildBullet("Send Notifications: With permission, notify users of promotions, schedule changes, and booking confirmations."),
              _buildBullet("Ensure Compliance: Meet legal standards and defend against fraudulent activity."),

              SizedBox(height: 20.h),
              _buildSectionTitle("3. Information Sharing"),
              _buildBullet("We place a high priority on data security and only exchange information in the following circumstances:"),
              _buildBullet("Travel Partners: Hotels, airlines, tour operators, and payment processors that handle your reservations."),
              _buildBullet("Legal Requirements: If required by government officials, law enforcement, or regulatory bodies."),
              _buildBullet("Business Transactions: When acquisitions, mergers, or transfers of businesses impact our operations."),

              SizedBox(height: 20.h),
              _buildSectionTitle("4. Location-Based Services"),
              _buildBullet("Our app uses location information to provide real-time navigation support."),
              _buildBullet("Offers personalised recommendations for sights and restaurants."),

              SizedBox(height: 20.h),
              _buildSectionTitle("5. Third-Party Services & Integrations"),
              _buildParagraph("The App integrates third-party services for payments, bookings, and analytics. These third parties have independent privacy policies, and we encourage users to review them."),

              SizedBox(height: 20.h),
              _buildSectionTitle("6. Cookies & Tracking Technologies"),
              _buildParagraph("We may use cookies, beacons, and tracking technologies to improve user experience and analyze usage trends. Users can manage or disable cookies in their browser settings."),

              SizedBox(height: 20.h),
              _buildSectionTitle("7. Children’s Privacy"),
              _buildParagraph("The App is \"not\" intended for children under [age], and we do not knowingly collect data from minors without parental consent."),

              SizedBox(height: 20.h),
              _buildSectionTitle("8. Data Retention"),
              _buildParagraph("We retain personal data only as long as necessary for providing services or complying with legal obligations. Users may request deletion of their data under applicable laws."),

              SizedBox(height: 20.h),
              _buildSectionTitle("9. Transfers of Data Internationally"),
              _buildParagraph("Data may be collected and transferred in areas with differing privacy regulations if users access our services from outside of [country of operation]. We guarantee adherence to relevant laws."),

              SizedBox(height: 20.h),
              _buildSectionTitle("10. Changes to Privacy Policy"),
              _buildParagraph("This privacy statement might be updated from time to time. When there are major updates, users will receive an email or in-app notifications."),

              SizedBox(height: 20.h),
              _buildSectionTitle("11. Contact Details"),
              _buildParagraph("If you have any queries, worries, or privacy requests, please contact us at:"),
              _buildBullet("Email: roamtheworld11@gmail.com"),
              _buildBullet("Address: 7234 Broadmore Road Jennings LA, 70546"),
              _buildBullet("Customer Support: +13373293105"),

              SizedBox(height: 40.h),
              Row(
                children: [
                  SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: Checkbox(
                      checkColor: Colors.white,
                      value: false,
                      onChanged: (bool? value) {
                        // Checkbox logic if needed
                      },
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          color: AppColors.kTextColor,
                          fontSize: 14.sp,
                        ),
                        children: [
                          TextSpan(text: "I have read and agree to the "),
                          TextSpan(
                            text: "Terms & Conditions",
                            style: GoogleFonts.poppins(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40.h),
              Center(
                child: CustomButton(
                  onPressed: () {},
                  text: "Save",
                  width: 200.w,
                  height: 42.h,
                ),
              ),
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

  Widget _buildParagraph(String content) {
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

  Widget _buildBullet(String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• ", style: GoogleFonts.poppins(fontSize: 14.sp)),
          Expanded(
            child: Text(
              content,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: AppColors.kTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
