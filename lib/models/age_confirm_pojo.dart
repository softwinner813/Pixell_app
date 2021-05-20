// To parse this JSON data, do
//
//     final ageConfirmPojo = ageConfirmPojoFromJson(jsonString);

import 'dart:convert';

AgeConfirmPojo ageConfirmPojoFromJson(String str) => AgeConfirmPojo.fromJson(json.decode(str));

String ageConfirmPojoToJson(AgeConfirmPojo data) => json.encode(data.toJson());

class AgeConfirmPojo {
  bool success;
  String detail;
  String statusCode;

  AgeConfirmPojo({
    this.success,
    this.detail,
    this.statusCode,
  });

  factory AgeConfirmPojo.fromJson(Map<String, dynamic> json) => AgeConfirmPojo(
    success: json["success"],
    detail: json["detail"],
    statusCode: json["status_code"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "detail": detail,
    "status_code": statusCode,
  };
}
