// ignore_for_file: file_names

class PostModel {
  final String uId;
  final String province;
  final String city;
  final String destination;
  final String airline;
  final String startDate;
  final String endDate;
  final String experience;
  final List<String> imageUrls;
  final String tags;
  final String name;
  final bool allowcontact; // ✅ declare the field
  final String? devicetoken;
  final String? Status;
  final String? Country;

  // ✅ declare the field

  PostModel({
    required this.uId,
    required this.province,
    required this.city,
    required this.destination,
    required this.airline,
    required this.startDate,
    required this.endDate,
    required this.experience,
    required this.imageUrls,
    required this.tags,
    required this.allowcontact,
    required this.name, // ✅ assign it here too
             this.devicetoken,
              this.Status,
              this.Country,


  });

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'province': province,
      'city': city,
      'destination': destination,
      'airline': airline,
      'startDate': startDate,
      'endDate': endDate,
      'experience': experience,
      'imageUrls': imageUrls,
      'tags': tags,
      'allowcontact': allowcontact,
      'devicetoken':devicetoken,
      'name':name,
       'status':Status,
      'country':Country
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> json) {
    return PostModel(
      uId: json['uId'] ?? '',
      province: json['province'] ?? '',
      city: json['city'] ?? '',
      destination: json['destination'] ?? '',
      airline: json['airline'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      experience: json['experience'] ?? '',
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      tags: json['tags'] ?? '',
      allowcontact: json['allowcontact'] ?? false,
      devicetoken: json['devicetoken'],
      name:json['name'],
      Status: json['Status'],
     Country: json['Country']
     // ✅ safe fallback
    );
  }
}
