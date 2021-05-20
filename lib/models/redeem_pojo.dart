// To parse this JSON data, do
//
//     final redeemPojo = redeemPojoFromJson(jsonString);

import 'dart:convert';

RedeemPojo redeemPojoFromJson(String str) =>
    RedeemPojo.fromJson(json.decode(str));

String redeemPojoToJson(RedeemPojo data) => json.encode(data.toJson());

class RedeemPojo {
  String detail;
  String statusCode;
  bool success;
  Data data;

  RedeemPojo({
    this.detail,
    this.statusCode,
    this.success,
    this.data,
  });

  factory RedeemPojo.fromJson(Map<String, dynamic> json) => RedeemPojo(
        detail: json["detail"],
        statusCode: json["status_code"],
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "detail": detail,
        "status_code": statusCode,
        "success": success,
        "data": data.toJson(),
      };
}

class Data {
  double redeemCash;

  Data({
    this.redeemCash,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        redeemCash: json["redeem_cash"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "redeem_cash": redeemCash,
      };
}
