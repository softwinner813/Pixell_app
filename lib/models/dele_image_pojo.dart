// To parse this JSON data, do
//
//     final deleteImagePojo = deleteImagePojoFromJson(jsonString);

import 'dart:convert';

DeleteImagePojo deleteImagePojoFromJson(String str) => DeleteImagePojo.fromJson(json.decode(str));

String deleteImagePojoToJson(DeleteImagePojo data) => json.encode(data.toJson());

class DeleteImagePojo {
  String status;
  String error;

  DeleteImagePojo({
    this.status,
    this.error,
  });

  factory DeleteImagePojo.fromJson(Map<String, dynamic> json) => DeleteImagePojo(
    status: json["status"],
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "error": error,
  };
}
