// To parse this JSON data, do
//
//     final updateRequestPojo = updateRequestPojoFromJson(jsonString);

import 'dart:convert';

UpdateRequestPojo updateRequestPojoFromJson(String str) => UpdateRequestPojo.fromJson(json.decode(str));

String updateRequestPojoToJson(UpdateRequestPojo data) => json.encode(data.toJson());

class UpdateRequestPojo {
  String detail;
  String statusCode;
  int id;
  User userFrom;
  User userTo;
  String status;
  int amount;
  List<int> request;
  DateTime creationTime;
  DateTime updateTime;
  DateTime expirationDate;
  int chargeAmount;
  String code;
  Map<String, dynamic> meta;

  UpdateRequestPojo({
    this.detail,
    this.statusCode,
    this.id,
    this.userFrom,
    this.userTo,
    this.status,
    this.amount,
    this.request,
    this.creationTime,
    this.updateTime,
    this.expirationDate,
    this.chargeAmount,
    this.code,
    this.meta,
  });

  factory UpdateRequestPojo.fromJson(Map<String, dynamic> json) => UpdateRequestPojo(
    detail: json["detail"],
    statusCode: json["status_code"],
    id: json["id"],
    userFrom: json["user_from"] == null ? null : User.fromJson(json["user_from"]),
    userTo: json["userTo"] == null ? null : User.fromJson(json["userTo"]),
    status: json["status"],
    amount: json["amount"],
    request: json["request"] == null ? null : List<int>.from(json["request"].map((x) => x)),
    creationTime: json["creationTime"] == null ? null : DateTime.parse(json["creation_time"]),
    updateTime: json["updateTime"] == null ? null : DateTime.parse(json["updateTime"]),
    expirationDate: json["expirationDate"] == null ? null : DateTime.parse(json["expirationDate"]),
    chargeAmount: json["charge_amount"],
    code: json["code"],
    meta: json["meta"],
  );

  Map<String, dynamic> toJson() => {
    "detail": detail,
    "status_code": statusCode,
    "id": id,
    "user_from": userFrom.toJson(),
    "user_to": userTo.toJson(),
    "status": status,
    "amount": amount,
    "request": List<dynamic>.from(request.map((x) => x)),
    "creation_time": creationTime.toIso8601String(),
    "update_time": updateTime.toIso8601String(),
    "expiration_date": "${expirationDate.year.toString().padLeft(4, '0')}-${expirationDate.month.toString().padLeft(2, '0')}-${expirationDate.day.toString().padLeft(2, '0')}",
    "charge_amount": chargeAmount,
    "code": code,
    "meta": meta,
  };
}

class User {
  int id;
  String name;
  String thumbnail;

  User({
    this.id,
    this.name,
    this.thumbnail,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    thumbnail: json["thumbnail"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "thumbnail": thumbnail,
  };
}
