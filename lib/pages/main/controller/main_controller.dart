import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../subscription/subscription_screen.dart';

class MainController extends GetxController {
  // Observable user data
  Rx<Map<String, dynamic>> userData = Rx<Map<String, dynamic>>({});

  int selectedIndex = 0;

  @override
  void onInit() {
    super.onInit();
    fetchUserData(); // Call the function when the controller is initialized
  }

  // Fetch user data from Firestore
  Future<void> fetchUserData() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (doc.exists) {
      // Updating the userData with Firestore data
      userData.value = doc.data()!;
    }
  }

  final List<String> icons = [
    'assets/icons/home.svg',
    'assets/icons/map.svg',
    'assets/icons/airline.svg',
    'assets/icons/chat.svg',
    'assets/icons/profile.svg',
  ];

  final List<String> names = [
    'Feed',
    'Map',
    'Airlines',
    'Chat',
    'Profile',
  ];

  // Function to handle the tab change
  void changeTabIndex(int index, BuildContext context) {
    if (index == 3 && userData.value['isPremium'] != true) {
      // If not premium and trying to access the Chat tab
      showPremiumPlanPopup(context);
    } else {
      // If premium or not Chat tab, change to the selected tab
      selectedIndex = index;
      update();
    }
  }

  // Show popup if the user is not premium
  void showPremiumPlanPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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

                // Monthly Plan Button
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

                // Yearly Plan Button
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
}
