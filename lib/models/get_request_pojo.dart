// To parse this JSON data, do
//
//     final requestsPojo = requestsPojoFromJson(jsonString);

import 'dart:convert';
import 'package:pixell_app/models/requests_pojo.dart';

GetRequestPojo requestPojoFromJson(String str) =>
    GetRequestPojo.fromJson(json.decode(str));


class GetRequestPojo {

  Result result;

  GetRequestPojo({
    this.result,
  });

  factory GetRequestPojo.fromJson(Map<String, dynamic> json) => GetRequestPojo(
    result: json == null
        ? null
        : Result.fromJson(json)
  );

  Map<String, dynamic> toJson() => result.toJson();
}