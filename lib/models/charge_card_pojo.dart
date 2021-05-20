// To parse this JSON data, do
//
//     final ChargeCardPojo = ChargeCardPojoFromJson(jsonString);

import 'dart:convert';

ChargeCardPojo ChargeCardPojoFromJson(String str) => ChargeCardPojo.fromJson(json.decode(str));

String ChargeCardPojoToJson(ChargeCardPojo data) => json.encode(data.toJson());

class ChargeCardPojo {
  String detail;
  String statusCode;
  bool success;
 
  ChargeCardPojo({
    this.detail,
    this.statusCode,
    this.success,
  });

  factory ChargeCardPojo.fromJson(Map<String, dynamic> json) => ChargeCardPojo(
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
