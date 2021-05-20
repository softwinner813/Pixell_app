// To parse this JSON data, do
//
//     final getRatesPojo = getRatesPojoFromJson(jsonString);

import 'dart:convert';

GetRatesPojo getRatesPojoFromJson(String str) =>
    GetRatesPojo.fromJson(json.decode(str));

String getRatesPojoToJson(GetRatesPojo data) => json.encode(data.toJson());

class GetRatesPojo {
  double rate;
  double amount;

  GetRatesPojo({
    this.rate,
    this.amount,
  });

  factory GetRatesPojo.fromJson(Map<String, dynamic> json) => GetRatesPojo(
        rate: json["rate"] == null ? null : json["rate"].toDouble(),
        amount: json["amount"] == null ? null : json["amount"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "rate": rate,
        "amount": amount,
      };
}
