// To parse this JSON data, do
//
//     final resetPojo = resetPojoFromJson(jsonString);

import 'dart:convert';

ResetPojo resetPojoFromJson(String str) => ResetPojo.fromJson(json.decode(str));

String resetPojoToJson(ResetPojo data) => json.encode(data.toJson());

class ResetPojo {
  String status;

  ResetPojo({
    this.status,
  });

  factory ResetPojo.fromJson(Map<String, dynamic> json) => ResetPojo(
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
      };
}
