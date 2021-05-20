// To parse this JSON data, do
//
//     final postFcmToken = postFcmTokenFromJson(jsonString);

import 'dart:convert';

PostFcmToken postFcmTokenFromJson(String str) => PostFcmToken.fromJson(json.decode(str));

String postFcmTokenToJson(PostFcmToken data) => json.encode(data.toJson());

class PostFcmToken {
  String error;
  String message;

  PostFcmToken({
    this.error,
    this.message,
  });

  factory PostFcmToken.fromJson(Map<String, dynamic> json) => PostFcmToken(
    error: json["error"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
  };
}
