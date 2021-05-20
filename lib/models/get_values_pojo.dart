// To parse this JSON data, do
//
//     final getValuesPojo = getValuesPojoFromJson(jsonString);

import 'dart:convert';

GetValuesPojo getValuesPojoFromJson(String str) => GetValuesPojo.fromJson(json.decode(str));

String getValuesPojoToJson(GetValuesPojo data) => json.encode(data.toJson());

class GetValuesPojo {
  PixelValues race;
  PixelValues body;
  PixelValues gender;
  PixelValues country;
  PixelValues bankAccountType;
  PixelValues redeemType;
  PixelValues countriesWithPresence;

  GetValuesPojo({
    this.race,
    this.body,
    this.gender,
    this.country,
    this.bankAccountType,
    this.redeemType,
    this.countriesWithPresence,
  });

  factory GetValuesPojo.fromJson(Map<String, dynamic> json) => GetValuesPojo(
    race: PixelValues.fromJson(json["race"]),
    body: PixelValues.fromJson(json["body"]),
    gender: PixelValues.fromJson(json["gender"]),
    country: PixelValues.fromJson(json["country"]),
    bankAccountType: PixelValues.fromJson(json["bank_account_type"]),
    redeemType: PixelValues.fromJson(json["redeem_type"]),
    countriesWithPresence: PixelValues.fromJson(json["presence_countries"])
  );

  Map<String, dynamic> toJson() => {
    "race": race.toJson(),
    "body": body.toJson(),
    "gender": gender.toJson(),
    "country": country.toJson(),
    "bank_account_type": bankAccountType.toJson(),
    "redeem_type": redeemType.toJson(),
    "presence_countries": countriesWithPresence.toJson(),
  };
}

class PixelValues {
  Map<String, String> json;

  PixelValues({
    this.json,
  });

  factory PixelValues.fromJson(Map<String, dynamic> json) => PixelValues(
      json: Map<String, String>.from(json)
  );

  Map<String, dynamic> toJson() => json;

  Map<String, String> toJsonStringType() => json;
}

