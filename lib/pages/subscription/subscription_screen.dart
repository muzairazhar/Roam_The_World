import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:roam_the_world_app/pages/splash/splash_screen.dart';
import 'package:roam_the_world_app/routes/app_routes.dart';
import 'package:roam_the_world_app/services/payment-service.dart';
import 'package:roam_the_world_app/utils/app_colors.dart';
import 'package:roam_the_world_app/widgets/custom_button.dart';
import 'package:restart_app/restart_app.dart';

import '../../widgets/restart_widget.dart';


class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  PaymentService paymentService = PaymentService();
  bool isPremium = false;
  String? expiryDate;

  @override
  void initState() {
    super.initState();
    checkPremiumStatus();
  }

  Future<void> checkPremiumStatus() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final data = userDoc.data();

    if (data != null && data['isPremium'] == true) {
      String expiry = 'Unknown';

      // Fetch the first (or latest) document in the 'payment' subcollection
      final paymentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('payment')
          .orderBy('expire_on', descending: true) // Optional, if there are multiple payments
          .limit(1)
          .get();

      if (paymentSnapshot.docs.isNotEmpty) {
        final paymentData = paymentSnapshot.docs.first.data();
        expiry = paymentData['expire_on']?.toString() ?? 'Unknown';

        // Optional: convert from Timestamp to formatted date
        if (paymentData['expire_on'] is Timestamp) {
          expiry = DateFormat.yMMMd().format((paymentData['expire_on'] as Timestamp).toDate());
        }
      }

      setState(() {
        isPremium = true;
        expiryDate = expiry;
      });
    }
  }


  Future<void> cancelSubscription() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'isPremium': false,
    });

    setState(() {
      isPremium = false;
      expiryDate = null;
    });


    Get.snackbar(
      "Subscription Cancelled",
      "Your premium subscription has been cancelled.",
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
   await Get.offAll(SplashScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Get Premium Now!",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w400),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 50.h),
        child: isPremium
            ? buildPremiumConfirmation()
            : Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildSubscriptionCard(
              title: "Standard/",
              subtitle: "Monthly Subscription",
              price: "\$10.00",
              gradientColors: [Color(0xFF2694FB), Color(0xFF49C8F5)],
              color: AppColors.primaryColor,
              onPressed: () {
                makepaymentMonthly();
              },
            ),
            SizedBox(height: 50),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: buildSubscriptionCard(
                title: "Premium/",
                subtitle: "Quarterly Subscription",
                price: "\$34.00",
                gradientColors: [Color(0xFF58DFAC), Colors.tealAccent],
                color: Color(0xFF58DFAC),
                onPressed: () {
                  makepaymentyearly();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPremiumConfirmation() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(30.w),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE6F0FA), Color(0xFFD2E9FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(color: Colors.blueAccent, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade100.withOpacity(0.4),
              blurRadius: 12,
              spreadRadius: 4,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.verified_user_rounded, size: 80, color: Colors.blueAccent),
            SizedBox(height: 20.h),
            Text(
              "Premium Member",
              style: GoogleFonts.poppins(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              "Your subscription is active until",
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              expiryDate ?? "Unknown",
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 30.h),
            CustomButton(
              onPressed: cancelSubscription,
              text: "Cancel Subscription",
              textColor: Colors.white,
              buttonColor: Colors.redAccent,
              fontSize: 16.sp,
              width: 200.w,
              height: 45.h,
              padding: EdgeInsets.symmetric(horizontal: 0.w),
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSubscriptionCard({
    required String title,
    required String subtitle,
    required String price,
    required List<Color> gradientColors,
    required Color color,
    required void Function() onPressed,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            spreadRadius: 2,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  text: title,
                  style: GoogleFonts.poppins(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.kWhiteColor,
                  ),
                  children: [
                    TextSpan(
                      text: subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: AppColors.kWhiteColor,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                price,
                style: GoogleFonts.poppins(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.kWhiteColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          CustomButton(
            onPressed: onPressed,
            text: "Subscribe",
            textColor: color,
            buttonColor: AppColors.kWhiteColor,
            fontSize: 16.sp,
            width: 120.w,
            height: 35.h,
            padding: EdgeInsets.symmetric(horizontal: 0.w),
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
  }
  Future<void> makepaymentyearly() async {
    try {
      int price = 34;  // Set the price here

      print("Price being sent: $price");

      // Make sure to call your backend service for PaymentIntent
      var paymentIntent = await paymentService.createPaymentIntent(price.toString(), "USD");

      // Ensure paymentIntent is valid
      if (paymentIntent == null || paymentIntent['client_secret'] == null) {
        throw Exception("PaymentIntent creation failed.");
      }

      // Initializing the PaymentSheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['client_secret'],
          googlePay: PaymentSheetGooglePay(
            testEnv: true,
            merchantCountryCode: "US",
            currencyCode: "USD",
          ),
          merchantDisplayName: "ROAM_THE_WORLD",
        ),
      );

      await displayPaymentSheetyear();
    } catch (e) {
      print("Payment Exception: $e");
      Get.snackbar("Error", "Something went wrong while creating the payment", backgroundColor: Colors.red);
    }
  }

  Future<void> makepaymentMonthly() async {
    try {
      int price = 10; // USD

      // Call your backend or service that returns a PaymentIntent
      var paymentIntent = await paymentService.createPaymentIntent(price.toString(), "USD");

      if (paymentIntent == null || paymentIntent['client_secret'] == null) {
        throw Exception("PaymentIntent creation failed.");
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['client_secret'],
          googlePay: PaymentSheetGooglePay(
            testEnv: true,
            merchantCountryCode: "US",
            currencyCode: "USD",
          ),
          merchantDisplayName: "ROAM_THE_WORLD",
        ),
      );

      // Store intent for later use
      paymentIntent = paymentIntent;

      await displayPaymentSheetMonthly(context); // ↓ see below
    } catch (e) {
      print("Payment Exception: $e");
      Get.snackbar("Error", "Something went wrong", backgroundColor: Colors.red);
    }
  }
  Future<void> displayPaymentSheetMonthly(BuildContext context) async {
    try {
      await Stripe.instance.presentPaymentSheet();

      // Save user payment info
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DateTime now = DateTime.now();
      DateTime expiryDate = now.add(Duration(days: 30)); // 1 month premium
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'isPremium': true,
      });
      Map<String, dynamic> paymentData = {
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'isPremium': true,
        'paymentAmount': 10, // or 34 for yearly
        'currency': 'USD',
        'paymentType': 'monthly', // or 'yearly'
        'paymentStatus': 'success',
        'timestamp': FieldValue.serverTimestamp(),
        'expire_on':DateFormat.yMMMMd().format(expiryDate)
      };
     await FirebaseFirestore.instance.collection('users').doc(userId).collection('payment').add(paymentData);
      Get.offAll(SplashScreen());
      print('ok horah hai');


      Get.snackbar(
        "Paid",
        "Payment successful! Premium active until ${DateFormat.yMMMMd().format(expiryDate)}",
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      print('ok horah hai');


    } on StripeException catch (e) {
      print("Stripe Exception: $e");
      Get.snackbar("Cancelled", "Payment was cancelled.", backgroundColor: Colors.orange);
    } catch (e) {
      print("General Exception: $e");
      Get.snackbar("Error", "Something went wrong", backgroundColor: Colors.red);
    }
  }
  displayPaymentSheetyear() async {
    try {
      DateTime now = DateTime.now();
      DateTime expiryDate = DateTime(now.year, now.year + 1, now.day);
      // Show the payment sheet to the user
      await Stripe.instance.presentPaymentSheet();

      // ✅ Update isPremium to true in Firestore
      String userId = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'isPremium': true,
      });
      Map<String, dynamic> paymentData = {
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'isPremium': true,
        'paymentAmount': 34, // or 34 for yearly
        'currency': 'USD',
        'paymentType': 'Yearly', // or 'yearly'
        'paymentStatus': 'success',
        'timestamp': FieldValue.serverTimestamp(),
        'expire_on':DateFormat.yMMMMd().format(expiryDate)
      };
     await FirebaseFirestore.instance.collection('users').doc(userId).collection('payment').add(paymentData);
          Get.offAll(SplashScreen());
      // ✅ Show success message
      Get.snackbar(
        "Paid",
        "Payment successful! Premium active until ${DateFormat.yMMMMd().format(expiryDate)}",
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );


      // Clear payment intent
      // paymentIntent = null;
    } on StripeException catch (e) {
      print('Stripe Error: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment Cancelled")),
      );
    } catch (e) {
      print("Other Error: $e");
      Get.snackbar(
        "Error",
        "Error while processing payment",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

}
