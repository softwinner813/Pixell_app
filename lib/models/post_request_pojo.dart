// To parse this JSON data, do
//
//     final postRequestPojo = postRequestPojoFromJson(jsonString);

import 'dart:convert';

PostRequestPojo postRequestPojoFromJson(String str) => PostRequestPojo.fromJson(json.decode(str));

String postRequestPojoToJson(PostRequestPojo data) => json.encode(data.toJson());

class PostRequestPojo {
  int id;
  User userFrom;
  User userTo;
  String status;
  int amount;
  List<int> request;
  DateTime creationTime;
  DateTime updateTime;
  String detail;
  String statusCode;

  PostRequestPojo({
    this.id,
    this.userFrom,
    this.userTo,
    this.status,
    this.amount,
    this.request,
    this.creationTime,
    this.updateTime,
    this.detail,
    this.statusCode,
  });

  factory PostRequestPojo.fromJson(Map<String, dynamic> json) => PostRequestPojo(
    id: json["id"],
    userFrom: json["user_from"] ==null ? null: User.fromJson(json["user_from"]),
    userTo: json["user_to"] ==null ? null: User.fromJson(json["user_to"]),
    status: json["status"],
    amount: json["amount"],
    request: json["request"] ==null ? null: List<int>.from(json["request"].map((x) => x)),
    creationTime: json["creation_time"] ==null ? null: DateTime.parse(json["creation_time"]),
    updateTime: json["updateTime"] ==null ? null: DateTime.parse(json["updateTime"]),
    detail: json["detail"],
    statusCode: json["status_code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_from": userFrom.toJson(),
    "user_to": userTo.toJson(),
    "status": status,
    "amount": amount,
    "request": List<dynamic>.from(request.map((x) => x)),
    "creation_time": creationTime.toIso8601String(),
    "update_time": updateTime.toIso8601String(),
    "detail": detail,
    "status_code": statusCode,
  };
}

class User {
  int id;
  String name;

  User({
    this.id,
    this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
