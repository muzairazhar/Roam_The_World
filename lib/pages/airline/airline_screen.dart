import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:roam_the_world_app/routes/app_routes.dart';
import 'package:roam_the_world_app/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roam_the_world_app/widgets/custom_text_field.dart';
import 'dart:convert';
import 'package:roam_the_world_app/models/airline_model.dart';

import '../subscription/subscription_screen.dart';

class AirlineScreen extends StatefulWidget {
  const AirlineScreen({super.key});

  @override
  State<AirlineScreen> createState() => _AirlineScreenState();
}

class _AirlineScreenState extends State<AirlineScreen> {
  List<Airline> _airlines = [];
  List<Airline> _filteredAirlines = [];
  bool _isLoading = true;
  String _errorMessage = '';
  final TextEditingController _searchController = TextEditingController();
  Map<String, dynamic>? _userData;


  @override
  void initState() {
    super.initState();
    _fetchAirlines();
    _searchController.addListener(_filterAirlines);
    _fetchUserData();
  }
  Future<void> _fetchUserData() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (doc.exists) {
      setState(() {
        _userData = doc.data();
      });
      print(_userData!['fullname']);
    }
  }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchAirlines() async {
    const String accessKey = 'a9420c4f19f967513060d55c26bbef4f';
    final String url = 'http://api.aviationstack.com/v1/airlines?access_key=$accessKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['data'] != null) {
          setState(() {
            _airlines = (data['data'] as List)
                .map((json) => Airline.fromJson(json))
                .toList();
            _filteredAirlines = List.from(_airlines);
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = 'No airline data found.';
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error While Fetching  a Data';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching airlines: $e';
      });
    }
  }


  void _filterAirlines() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredAirlines = _airlines.where((airline) {
        return airline.name.toLowerCase().contains(query) ||
            (airline.icaoCode?.toLowerCase().contains(query) ?? false);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhiteColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          "Airlines",
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
            children: [
              CustomTextField(
                controller: _searchController,
                hintText: "Search Airlines",
                prefixIcon: Icons.search,
                radius: 10.0,
              ),
              SizedBox(height: 30.h),
              _buildAirlinesList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAirlinesList() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          _errorMessage,
          style: GoogleFonts.poppins(color: Colors.red),
        ),
      );
    }

    if (_filteredAirlines.isEmpty) {
      return Center(
        child: Text(
          'No airlines found',
          style: GoogleFonts.poppins(),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: _filteredAirlines.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final airline = _filteredAirlines[index];
        return _airlineCard(airline);
      },
    );
  }

  Widget _airlineCard(Airline airline) {
    return InkWell(
      onTap: () {
        if (_userData!['isPremium'] == true) {
          Get.toNamed(AppRoutes.kAirlineDetailScreenRoute, arguments: airline);
        } else {
         showPremiumPlanPopup(context);
        }
      },
      borderRadius: BorderRadius.circular(5.0.r),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0.r),
          border: Border.all(
            color: AppColors.kBorderColor,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 50.0.h,
              width: 80.0.w,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.3),
              ),
              child: Center(
                child: Text(
                  airline.icaoCode?.substring(0, 1) ?? 'A',
                  style: GoogleFonts.poppins(
                    color: AppColors.primaryColor,
                    fontSize: 20.0.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    airline.name,
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      color: AppColors.kTextColor,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: AppColors.kYellowColor,
                            size: 20.0.sp,
                          ),
                          Text(
                            "4.9",
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              color: AppColors.kTextColor,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "View Details",
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: AppColors.primaryColor,
                            size: 18.0.sp,
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );

  }
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

}