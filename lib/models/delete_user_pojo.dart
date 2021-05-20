// To parse this JSON data, do
//
//     final deleteUserPojo = deleteUserPojoFromJson(jsonString);

import 'dart:convert';

DeleteUserPojo deleteUserPojoFromJson(String str) => DeleteUserPojo.fromJson(json.decode(str));

String deleteUserPojoToJson(DeleteUserPojo data) => json.encode(data.toJson());

class DeleteUserPojo {
  String detail;
  String statusCode;
  bool success;

  DeleteUserPojo({
    this.detail,
    this.statusCode,
    this.success,
  });

  factory DeleteUserPojo.fromJson(Map<String, dynamic> json) => DeleteUserPojo(
    detail: json["detail"],
    statusCode: json["status_code"],
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "detail": detail,
    "status_code": statusCode,
    "success": success,
  };
}
