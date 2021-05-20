// To parse this JSON data, do
//
//     final GetCreditCardPojo = GetCreditCardPojoFromJson(jsonString);

import 'dart:convert';

GetCreditCardPojo GetCreditCardPojoFromJson(String str) =>
    GetCreditCardPojo.fromJson(json.decode(str));

String GetCreditCardPojoToJson(GetCreditCardPojo data) =>
    json.encode(data.toJson());

class GetCreditCardPojo {
  String detail;
  String statusCode;
  int count;
  dynamic next;
  dynamic previous;
  List<ResultCreditCard> results;

  GetCreditCardPojo({
    this.detail,
    this.statusCode,
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory GetCreditCardPojo.fromJson(Map<String, dynamic> json) =>
      GetCreditCardPojo(
        detail: json["detail"],
        statusCode: json["status_code"],
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: json["results"] == null
            ? null
            : List<ResultCreditCard>.from(
                json["results"].map((x) => ResultCreditCard.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "detail": detail,
        "status_code": statusCode,
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class ResultCreditCard {
  String cc_last_four;

  ResultCreditCard({
    this.cc_last_four,
  });

  factory ResultCreditCard.fromJson(Map<String, dynamic> json) =>
      ResultCreditCard(
        cc_last_four: json["cc_last_four"],
      );

  Map<String, dynamic> toJson() => {
        "cc_last_four": cc_last_four,
      };
}
