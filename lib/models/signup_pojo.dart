// To parse this JSON data, do
//
//     final signupPojo = signupPojoFromJson(jsonString);

import 'dart:convert';

SignupPojo signupPojoFromJson(String str) => SignupPojo.fromJson(json.decode(str));

String signupPojoToJson(SignupPojo data) => json.encode(data.toJson());

class SignupPojo {
  int id;
  String token;
  String username;
  String password;
  bool isStaff;
  DateTime dateOfBirth;
  String email;
  String firstName;
  String lastName;
  Profile profile;

  SignupPojo({
    this.id,
    this.token,
    this.username,
    this.password,
    this.isStaff,
    this.dateOfBirth,
    this.email,
    this.firstName,
    this.lastName,
    this.profile,
  });

  factory SignupPojo.fromJson(Map<String, dynamic> json) => SignupPojo(
    id: json["id"],
    token: json["token"],
    username: json["username"],
    password: json["password"],
    isStaff: json["is_staff"],
    dateOfBirth: DateTime.parse(json["date_of_birth"]),
    email: json["email"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    profile: json["profile"] ==null ? null: Profile.fromJson(json["profile"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "token": token,
    "username": username,
    "password": password,
    "is_staff": isStaff,
    "date_of_birth": dateOfBirth.toIso8601String(),
    "email": email,
    "first_name": firstName,
    "last_name": lastName,
    "profile": profile.toJson(),
  };
}

class Profile {
  String description;
  List<dynamic> pics;
  String thumbnail;
  bool isSeller;
  String isAgeVerified;
  bool isSellingAdultContent;
  PhysicalAppearance physicalAppearance;

  Profile({
    this.description,
    this.pics,
    this.thumbnail,
    this.isSeller,
    this.isAgeVerified,
    this.isSellingAdultContent,
    this.physicalAppearance,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    description: json["description"],
    pics: List<dynamic>.from(json["pics"].map((x) => x)),
    thumbnail: json["thumbnail"]==null?null:json["thumbnail"],
    isSeller: json["is_seller"],
    isAgeVerified: json["is_age_verified"],
    isSellingAdultContent: json["is_selling_adult_content"],
    physicalAppearance: json["physical_appearance"] ==null ? null: PhysicalAppearance.fromJson(json["physical_appearance"]),
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "pics": List<dynamic>.from(pics.map((x) => x)),
    "thumbnail": thumbnail,
    "is_seller": isSeller,
    "is_age_verified": isAgeVerified,
    "is_selling_adult_content": isSellingAdultContent,
    "physical_appearance": physicalAppearance.toJson(),
  };
}

class PhysicalAppearance {
  PhysicalAppearance();

  factory PhysicalAppearance.fromJson(Map<String, dynamic> json) => PhysicalAppearance(
  );

  Map<String, dynamic> toJson() => {
  };
}
