// ignore_for_file: file_names

class UserModel {
  final String uId;
  final String password;
  final String fullname;
  final String email;
  final String userDeviceToken;
  final String role;
  final String phonenumber;
  final String location;
  final String about;
  final String tiktok;
  final String linkdin;
  final String instagram;
  final String facebook;
  final String youtube;
  final bool isActive;
  final bool isPremium;
  final bool Status;
  final dynamic createdAt;


  UserModel({
    required this.uId,
    required this.tiktok,
    required this.linkdin,
    required this.instagram,
    required this.facebook,
    required this.youtube,
    required this.password,
    required this.location,
    required this.phonenumber,
    required this.about,
    required this.fullname,
    required this.email,
    required this.userDeviceToken,
    required this.role,
    required this.isActive,
    required this.isPremium,
    required this.Status,
    required this.createdAt,

  });

  // Serialize the UserModel instance to a JSON map
  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'tiktok':tiktok,
      'linkdin':linkdin,
       'instagram':instagram,
      'facebook':facebook,
      'youtube':youtube,
      'password':password,
      'fullname': fullname,
      'email': email,
      'userDeviceToken': userDeviceToken,
      'phonenumber':phonenumber,
      'location':location,
      'about':about,
      'role': role,
      'isActive': isActive,
      'isPremium':isPremium,
      'Status':Status,
      'createdAt': createdAt,


    };
  }

  // Create a UserModel instance from a JSON map
  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      uId: json['uId'],
      tiktok: json['tiktok'],
      linkdin: json['linkdin'],
      instagram: json['instagram'],
      facebook: json['facebook'],
      youtube: json['youtube'],
      phonenumber:json['phonenumber'],
      password: json['password'],
      location:json['location'],
      about:json['about'],
      fullname: json['fullname'],
      email: json['email'],
      userDeviceToken: json['userDeviceToken'],
      role: json['role'],
      isActive: json['isActive'],
        isPremium:json['isPremium'],
        Status:json['Status'],
      createdAt: json['createdAt'].toString(),
 
    );
  }
}
