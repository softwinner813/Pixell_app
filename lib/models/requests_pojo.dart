// To parse this JSON data, do
//
//     final requestsPojo = requestsPojoFromJson(jsonString);

import 'dart:convert';

RequestsPojo requestsPojoFromJson(String str) =>
    RequestsPojo.fromJson(json.decode(str));

String requestsPojoToJson(RequestsPojo data) => json.encode(data.toJson());

class RequestsPojo {
  String detail;
  String statusCode;
  int count;
  dynamic next;
  dynamic previous;
  List<Result> results;

  RequestsPojo({
    this.detail,
    this.statusCode,
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory RequestsPojo.fromJson(Map<String, dynamic> json) => RequestsPojo(
        detail: json["detail"],
        statusCode: json["status_code"],
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: json["results"] == null
            ? null
            : List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
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

class Result {
  int id;
  UserFrom userFrom;
  UserTo userTo;
  String status;
  int amount;
  int chargeAmount;
  List<int> request;
  DateTime creationTime;
  DateTime updateTime;
  DateTime expirationDate;
  String asset_link;
  bool clickable = true;

  Result({
    this.id,
    this.userFrom,
    this.userTo,
    this.status,
    this.amount,
    this.chargeAmount,
    this.request,
    this.creationTime,
    this.updateTime,
    this.expirationDate,
    this.asset_link,
    this.clickable,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        userFrom: UserFrom.fromJson(json["user_from"]),
        userTo: UserTo.fromJson(json["user_to"]),
        status: json["status"],
        amount: json["amount"],
        chargeAmount: json["charge_amount"],
        request: List<int>.from(json["request"].map((x) => x)),
        creationTime: DateTime.parse(json["creation_time"]),
        updateTime: DateTime.parse(json["update_time"]),
        expirationDate: DateTime.parse(json["expiration_date"]),
        asset_link: json["asset_link"]==null ? null : json["asset_link"],
        clickable: true,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_from": userFrom.toJson(),
        "user_to": userTo.toJson(),
        "status": status,
        "amount": amount,
        "charge_amount": chargeAmount,
        "request": List<dynamic>.from(request.map((x) => x)),
        "creation_time": creationTime.toIso8601String(),
        "update_time": updateTime.toIso8601String(),
        "expiration_date":
            "${expirationDate.year.toString().padLeft(4, '0')}-${expirationDate.month.toString().padLeft(2, '0')}-${expirationDate.day.toString().padLeft(2, '0')}",
        "asset_link": asset_link,
      };
}

class UserFrom {
  int id;
  String name;
  String thumbnail;

  UserFrom({
    this.id,
    this.name,
    this.thumbnail,
  });

  factory UserFrom.fromJson(Map<String, dynamic> json) => UserFrom(
        id: json["id"],
        name: json["name"],
        thumbnail: json["thumbnail"] == null ? null : json["thumbnail"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "thumbnail": thumbnail,
      };
}

class UserTo {
  int id;
  String name;
  String thumbnail;

  UserTo({
    this.id,
    this.name,
    this.thumbnail,
  });

  factory UserTo.fromJson(Map<String, dynamic> json) => UserTo(
        id: json["id"],
        name: json["name"],
        thumbnail: json["thumbnail"] == null ? null : json["thumbnail"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "thumbnail": thumbnail,
      };
}
