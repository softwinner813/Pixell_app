// To parse this JSON data, do
//
//     final getUserDetailsPojo = getUserDetailsPojoFromJson(jsonString);

import 'dart:convert';

GetUserDetailsPojo getUserDetailsPojoFromJson(String str) => GetUserDetailsPojo.fromJson(json.decode(str));

String getUserDetailsPojoToJson(GetUserDetailsPojo data) => json.encode(data.toJson());

class GetUserDetailsPojo {
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
  int loginTimes;

  GetUserDetailsPojo({
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
    this.loginTimes,
  });

  factory GetUserDetailsPojo.fromJson(Map<String, dynamic> json) => GetUserDetailsPojo(
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
    loginTimes: json["login_times"],
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
    "login_times": loginTimes,
  };
}

class Profile {
  String description;
  List<Pic> pics;
  String thumbnail;
  String profilePic;
  bool isSeller;
  String isAgeVerified;
  String gender;
  String country;
  bool isSellingAdultContent;
  PhysicalAppearance physicalAppearance;

  Profile({
    this.description,
    this.pics,
    this.thumbnail,
    this.profilePic,
    this.isSeller,
    this.isAgeVerified,
    this.gender,
    this.country,
    this.isSellingAdultContent,
    this.physicalAppearance,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    description: json["description"],
    pics: List<Pic>.from(json["pics"].map((x) => Pic.fromJson(x))),
    thumbnail: json["thumbnail"],
    profilePic: json["profile_pic"],
    isSeller: json["is_seller"],
    isAgeVerified: json["is_age_verified"],
    gender: json["gender"],
    country: json["country"],
    isSellingAdultContent: json["is_selling_adult_content"],
    physicalAppearance: json["physical_appearance"] ==null ? null: PhysicalAppearance.fromJson(json["physical_appearance"]),
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "pics": List<dynamic>.from(pics.map((x) => x.toJson())),
    "thumbnail": thumbnail,
    "profile_pic": profilePic,
    "is_seller": isSeller,
    "is_age_verified": isAgeVerified,
    "gender": gender,
    "country": country,
    "is_selling_adult_content": isSellingAdultContent,
    "physical_appearance": physicalAppearance.toJson(),
  };
}

class PhysicalAppearance {
  int heightCm;
  int weightKg;
  String race;
  String body;

  PhysicalAppearance({
    this.heightCm,
    this.weightKg,
    this.race,
    this.body,
  });

  factory PhysicalAppearance.fromJson(Map<String, dynamic> json) => PhysicalAppearance(
    heightCm: json["height_cm"],
    weightKg: json["weight_kg"],
    race: json["race"],
    body: json["body"],
  );

  Map<String, dynamic> toJson() => {
    "height_cm": heightCm,
    "weight_kg": weightKg,
    "race": race,
    "body": body,
  };
}

class Pic {
  String regular;
  String thumbnail;

  Pic({
    this.regular,
    this.thumbnail,
  });

  factory Pic.fromJson(Map<String, dynamic> json) => Pic(
    regular: json["regular"],
    thumbnail: json["thumbnail"],
  );

  Map<String, dynamic> toJson() => {
    "regular": regular,
    "thumbnail": thumbnail,
  };
}
