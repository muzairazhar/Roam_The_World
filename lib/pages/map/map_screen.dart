import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; // <- added
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart' as places;
import 'package:roam_the_world_app/utils/app_colors.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../subscription/subscription_screen.dart';

const String kGoogleApiKey = 'AIzaSyAgexi_bjpGcB_MQxQSbDz4UiQpHPCDYjc';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String? _selectedStatus;
  Color? _selectedColor;

  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  final places.FlutterGooglePlacesSdk _places = places.FlutterGooglePlacesSdk(kGoogleApiKey);
  LatLng _currentPosition = const LatLng(31.5204, 74.3587);
  Map<String, dynamic>? _userData;
  // Default: Lahore
  @override
  void initState() {
    super.initState();
    _determinePosition();
    _fetchUserData();
  }
  Future<void> _fetchUserData() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (doc.exists) {
      setState(() {
        _userData = doc.data();
        print(_userData!['fullname']);
      });
    }
  }


  Future<void> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _markers.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: _currentPosition,
          infoWindow: const InfoWindow(title: 'Your Location'),
        ),
      );
    });

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(_currentPosition, 14));
  }


  Future<void> _handleSearch() async {
    final result = await showSearch(
      context: context,
      delegate: PlacesSearchDelegate(_places),
    );

    if (result != null) {
      final place = await _places.fetchPlace(result.placeId, fields: [
        places.PlaceField.Location,
        places.PlaceField.Name,
      ]);
      final lat = place.place?.latLng?.lat ?? 0.0;
      final lng = place.place?.latLng?.lng ?? 0.0;
      final name = place.place?.name ?? "Selected Location";

      final selectedPosition = LatLng(lat, lng);
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId(result.placeId),
            position: selectedPosition,
            infoWindow: InfoWindow(title: name),
          ),
        );
      });

      final controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLngZoom(selectedPosition, 14));
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Make Your Territory'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _handleSearch,
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: _currentPosition, zoom: 12),
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (controller) => _controller.complete(controller),

        // ✅ Handles map tap, gets LatLng & reverse geocodes to name
        onTap: (LatLng latLng) async {
          try {
            List<Placemark> placemarks = await placemarkFromCoordinates(
              latLng.latitude,
              latLng.longitude,
            );

            String locationName = "Unknown Location";
            if (placemarks.isNotEmpty) {
              final place = placemarks.first;
              locationName = [
                if (place.locality != "") place.locality,
                if (place.administrativeArea != "") place.administrativeArea,
                if (place.country != "") place.country,
              ].join(", ");
            }

            countryPopup(
              context: context,
              location: latLng,
              locationName: locationName,
            );
          } catch (e) {
            print("Error getting location name: $e");
            countryPopup(
              context: context,
              location: latLng,
              locationName: "Unknown Location",
            );
          }
        },
      ),
    );
  }
  void countryPopup({
    required BuildContext context,
    required LatLng location,
    required String locationName,
  })
  {
    // Move state variables here, copy existing selection
    String? tempSelectedStatus = _selectedStatus;
    Color? tempSelectedColor = _selectedColor;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.kBackgroundColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              content: SizedBox(
                width: 300.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            FontAwesomeIcons.xmark,
                            color: AppColors.primaryColor,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      locationName,
                      style: GoogleFonts.poppins(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5.h),
                    countryStats(locationName),

                    SizedBox(height: 20.h),
                    Text(
                      "Pick an option",
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: AppColors.kTextColor,
                      ),
                    ),
                    SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSelectableOption("Been", AppColors.primaryColor, tempSelectedStatus, tempSelectedColor, (status, color) {
                        setState(() {
                          tempSelectedStatus = status;
                          tempSelectedColor = color;
                        });
                      }),
                      _buildSelectableOption("Want", AppColors.kYellowColor, tempSelectedStatus, tempSelectedColor, (status, color) {
                        setState(() {
                          tempSelectedStatus = status;
                          tempSelectedColor = color;
                        });
                      }),
                      _buildSelectableOption("Live", Colors.red, tempSelectedStatus, tempSelectedColor, (status, color) {
                        setState(() {
                          tempSelectedStatus = status;
                          tempSelectedColor = color;
                        });
                      }),
                      _buildSelectableOption("Lived", Colors.green, tempSelectedStatus, tempSelectedColor, (status, color) {
                        setState(() {
                          tempSelectedStatus = status;
                          tempSelectedColor = color;
                        });
                      }),
                    ],
                  ),

                    SizedBox(height: 20.h),
                    CustomButton(
                      onPressed: () {
                        if (tempSelectedStatus == null || tempSelectedColor == null) {
                          Get.snackbar("Select Option", "Please select a status option.");
                          return;
                        }

                        // Save back to global variables
                        _selectedStatus = tempSelectedStatus;
                        _selectedColor = tempSelectedColor;

                        // Check if user is premium
                        if (!_userData!['isPremium']) {
                          showPremiumPlanPopup(context);
                          return;
                        }

                        // Navigate only if user is premium
                        Get.back();
                        Get.toNamed(
                          AppRoutes.kAddPostScreenScreenRoute,
                          arguments: {
                            'location': location,
                            'status': _selectedStatus,
                            'color': _selectedColor!.value,
                            'locationName': locationName,
                          },
                        );
                      },
                      text: "Add Post",
                      width: 200.w,
                      height: 42.h,
                    ),

                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  Widget _buildSelectableOption(String status, Color color, String? tempSelectedStatus, Color? tempSelectedColor, Function(String, Color) onSelected) {
    return GestureDetector(
      onTap: () {
        onSelected(status, color);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: tempSelectedStatus == status ? color.withOpacity(0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: tempSelectedStatus == status ? color : Colors.transparent,
          ),
        ),
        child: Text(
          status,
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: tempSelectedStatus == status ? color : AppColors.kTextColor,
          ),
        ),
      ),
    );
  }




  Widget countryStats(String locationName) {
    return InkWell(
      onTap: () {
        Get.back();
        Get.toNamed(
          AppRoutes.kCountryBasePostsScreenRoute,
          arguments: locationName, // pass selected country here
        );
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.kWhiteColor,
                border: Border.all(color: AppColors.primaryColor),
              ),
              child: Center(
                child: Icon(
                  Icons.location_pin,
                  color: AppColors.primaryColor,
                  size: 20.sp,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Flexible(
              child: Text(
                "View all Posts of people who have been to this Location!",
                style: GoogleFonts.poppins(fontSize: 12.sp, color: AppColors.kTextColor),
              ),
            ),
            SizedBox(width: 10.w),
            Icon(Icons.chevron_right, color: AppColors.kTextColor, size: 20.sp),
          ],
        ),
      ),
    );
  }

  Widget selectOptionCard({required Color color, required String text}) {
    return Column(
      children: [
        Container(
          width: 30.w,
          height: 30.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        Text(
          text,
          style: GoogleFonts.poppins(fontSize: 12.sp, color: AppColors.kTextColor),
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
  // Widget countryStats() {
  //   return InkWell(
  //     onTap: () {
  //       Get.back();
  //       Get.toNamed(AppRoutes.kCountryBasePostsScreenRoute);
  //     },
  //     borderRadius: BorderRadius.circular(10),
  //     child: Container(
  //       width: double.infinity,
  //       padding: EdgeInsets.symmetric(
  //         horizontal: 10.w,
  //         vertical: 10.h,
  //       ),
  //       decoration: BoxDecoration(
  //         color: AppColors.primaryColor.withOpacity(0.2),
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //       child: Row(
  //         children: [
  //           Container(
  //             width: 40.w,
  //             height: 40.h,
  //             decoration: BoxDecoration(
  //               shape: BoxShape.circle,
  //               color: AppColors.kWhiteColor,
  //               border: Border.all(
  //                 color: AppColors.primaryColor,
  //               ),
  //             ),
  //             child: Center(
  //               child: Icon(
  //                 Icons.location_pin,
  //                 color: AppColors.primaryColor,
  //                 size: 20.sp,
  //               ),
  //             ),
  //           ),
  //           SizedBox(width: 10.w),
  //           Flexible(
  //             child: Text(
  //               "View 98 Posts of people who have been to this country!",
  //               style: GoogleFonts.poppins(
  //                 fontSize: 12.sp,
  //                 color: AppColors.kTextColor,
  //               ),
  //             ),
  //           ),
  //           SizedBox(width: 10.w),
  //           Icon(
  //             Icons.chevron_right,
  //             color: AppColors.kTextColor,
  //             size: 20.sp,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }


}



class PlacesSearchDelegate extends SearchDelegate<places.AutocompletePrediction> {
  final places.FlutterGooglePlacesSdk _places;

  PlacesSearchDelegate(this._places);

  List<places.AutocompletePrediction> _suggestions = [];
  Map<String, double> _distances = {};
  bool _isLoading = false;
  Position? _currentPosition;

  Future<void> _getCurrentLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition();
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<void> _fetchSuggestions(String query, VoidCallback update) async {
    _isLoading = true;
    _suggestions.clear();
    _distances.clear();
    update();

    await _getCurrentLocation();

    try {
      final response = await _places.findAutocompletePredictions(query);
      _suggestions = response.predictions;

      for (var prediction in _suggestions) {
        final placeId = prediction.placeId;

        final details = await _places.fetchPlace(
          placeId,
          fields: [places.PlaceField.Location],
        );

        final location = details.place?.latLng;

        if (_currentPosition != null && location != null) {
          final distanceInMeters = Geolocator.distanceBetween(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
            location.lat,
            location.lng,
          );
          final distanceInKm = distanceInMeters / 1000;
          _distances[placeId] = distanceInKm;
        }
      }
    } catch (e) {
      print("Error fetching suggestions or distances: $e");
    }

    _isLoading = false;
    update();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        if (query.length >= 2 && !_isLoading && _suggestions.isEmpty) {
          _fetchSuggestions(query, () => setState(() {}));
        }

        if (_isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_suggestions.isEmpty) {
          return const Center(child: Text("No suggestions"));
        }

        return ListView.builder(
          itemCount: _suggestions.length,
          itemBuilder: (context, index) {
            final prediction = _suggestions[index];
            final distance = _distances[prediction.placeId];

            return ListTile(
              title: Text(prediction.fullText),
              subtitle: distance != null
                  ? Text('${distance.toStringAsFixed(2)} km away')
                  : const Text("Distance unknown"),
              onTap: () => close(context, prediction),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) => Container();

  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () {
        query = '';
        _suggestions.clear();
        _distances.clear();
        _isLoading = false;
        showSuggestions(context);
      },
    ),
  ];

  @override
  Widget buildLeading(BuildContext context) => const BackButton();
}



