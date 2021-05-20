// To parse this JSON data, do
//
//     final changePasswordPojo = changePasswordPojoFromJson(jsonString);

import 'dart:convert';

ChangePasswordPojo changePasswordPojoFromJson(String str) => ChangePasswordPojo.fromJson(json.decode(str));

String changePasswordPojoToJson(ChangePasswordPojo data) => json.encode(data.toJson());

class ChangePasswordPojo {
  int id;
  String token;
  String username;
  String password;
  bool isStaff;
  DateTime dateOfBirth;
  String email;
  String firstName;
  String lastName;

  ChangePasswordPojo({
    this.id,
    this.token,
    this.username,
    this.password,
    this.isStaff,
    this.dateOfBirth,
    this.email,
    this.firstName,
    this.lastName,
  });

  factory ChangePasswordPojo.fromJson(Map<String, dynamic> json) => ChangePasswordPojo(
    id: json["id"],
    token: json["token"],
    username: json["username"],
    password: json["password"],
    isStaff: json["is_staff"],
    dateOfBirth: DateTime.parse(json["date_of_birth"]),
    email: json["email"],
    firstName: json["first_name"],
    lastName: json["last_name"],
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
  };
}
