// To parse this JSON data, do
//
//     final getSellersPojo = getSellersPojoFromJson(jsonString);

import 'dart:convert';

GetSellersPojo getSellersPojoFromJson(String str) => GetSellersPojo.fromJson(json.decode(str));

String getSellersPojoToJson(GetSellersPojo data) => json.encode(data.toJson());

class GetSellersPojo {
  int count;
  dynamic next;
  dynamic previous;
  List<Result> results;

  GetSellersPojo({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory GetSellersPojo.fromJson(Map<String, dynamic> json) => GetSellersPojo(
    count: json["count"],
    next: json["next"],
    previous: json["previous"],
    results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "next": next,
    "previous": previous,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };
}

class Result {
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

  Result({
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

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    token: json["token"],
    username: json["username"],
    password: json["password"],
    isStaff: json["is_staff"],
    dateOfBirth: DateTime.parse(json["date_of_birth"]),
    email: json["email"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    profile: Profile.fromJson(json["profile"]),
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
  dynamic pics;
  String thumbnail;
  bool isSeller;
  bool isSellingAdultContent;
  PhysicalAppearance physicalAppearance;
  IsAgeVerified isAgeVerified;
  String profilePic;
  Gender gender;
  Country country;

  Profile({
    this.description,
    this.pics,
    this.thumbnail,
    this.isSeller,
    this.isSellingAdultContent,
    this.physicalAppearance,
    this.isAgeVerified,
    this.profilePic,
    this.gender,
    this.country,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    description: json["description"],
    pics: json["pics"],
    thumbnail: json["thumbnail"],
    isSeller: json["is_seller"],
    isSellingAdultContent: json["is_selling_adult_content"],
    physicalAppearance: json["physical_appearance"] == null ? null : PhysicalAppearance.fromJson(json["physical_appearance"]),
    isAgeVerified: json["is_age_verified"] == null ? null : isAgeVerifiedValues.map[json["is_age_verified"]],
    profilePic: json["profile_pic"] == null ? null : json["profile_pic"],
    gender: json["gender"] == null ? null : genderValues.map[json["gender"]],
    country: json["country"] == null ? null : countryValues.map[json["country"]],
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "pics": pics,
    "thumbnail": thumbnail,
    "is_seller": isSeller,
    "is_selling_adult_content": isSellingAdultContent,
    "physical_appearance": physicalAppearance == null ? null : physicalAppearance.toJson(),
    "is_age_verified": isAgeVerified == null ? null : isAgeVerifiedValues.reverse[isAgeVerified],
    "profile_pic": profilePic == null ? null : profilePic,
    "gender": gender == null ? null : genderValues.reverse[gender],
    "country": country == null ? null : countryValues.reverse[country],
  };
}

enum Country { JP, MX, US }

final countryValues = EnumValues({
  "JP": Country.JP,
  "MX": Country.MX,
  "US": Country.US
});

enum Gender { FEMALE, MALE }

final genderValues = EnumValues({
  "FEMALE": Gender.FEMALE,
  "MALE": Gender.MALE
});

enum IsAgeVerified { VERIFIED }

final isAgeVerifiedValues = EnumValues({
  "VERIFIED": IsAgeVerified.VERIFIED
});

class PhysicalAppearance {
  int heightCm;
  int weightKg;
  Race race;
  Body body;

  PhysicalAppearance({
    this.heightCm,
    this.weightKg,
    this.race,
    this.body,
  });

  factory PhysicalAppearance.fromJson(Map<String, dynamic> json) => PhysicalAppearance(
    heightCm: json["height_cm"] == null ? null : json["height_cm"],
    weightKg: json["weight_kg"] == null ? null : json["weight_kg"],
    race: json["race"] == null ? null : raceValues.map[json["race"]],
    body: json["body"] == null ? null : bodyValues.map[json["body"]],
  );

  Map<String, dynamic> toJson() => {
    "height_cm": heightCm == null ? null : heightCm,
    "weight_kg": weightKg == null ? null : weightKg,
    "race": race == null ? null : raceValues.reverse[race],
    "body": body == null ? null : bodyValues.reverse[body],
  };
}

enum Body { FIT, SLIM }

final bodyValues = EnumValues({
  "FIT": Body.FIT,
  "SLIM": Body.SLIM
});

enum Race { BLACK, LATIN, ASIAN }

final raceValues = EnumValues({
  "ASIAN": Race.ASIAN,
  "BLACK": Race.BLACK,
  "LATIN": Race.LATIN
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
