// To parse this JSON data, do
//
//     final balanceSummaryPojo = balanceSummaryPojoFromJson(jsonString);

import 'dart:convert';

BalanceSummaryPojo balanceSummaryPojoFromJson(String str) => BalanceSummaryPojo.fromJson(json.decode(str));

String balanceSummaryPojoToJson(BalanceSummaryPojo data) => json.encode(data.toJson());

class BalanceSummaryPojo {
  String detail;
  String statusCode;
  double earned;
  double earnedPending;
  double redeemed;
  double redeemedPending;

  BalanceSummaryPojo({
    this.detail,
    this.statusCode,
    this.earned,
    this.earnedPending,
    this.redeemed,
    this.redeemedPending,
  });

  factory BalanceSummaryPojo.fromJson(Map<String, dynamic> json) => BalanceSummaryPojo(
    detail: json["detail"],
    statusCode: json["status_code"],
    earned: json["earned"].toDouble(),
    earnedPending: json["earned_pending"].toDouble(),
    redeemed: json["redeemed"].toDouble(),
    redeemedPending: json["redeemed_pending"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "detail": detail,
    "status_code": statusCode,
    "earned": earned,
    "earned_pending": earnedPending,
    "redeemed": redeemed,
    "redeemed_pending": redeemedPending,
  };
}
