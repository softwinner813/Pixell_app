// To parse this JSON data, do
//
//     final postImagePojo = postImagePojoFromJson(jsonString);

import 'dart:convert';

PostImagePojo postImagePojoFromJson(String str) => PostImagePojo.fromJson(json.decode(str));

String postImagePojoToJson(PostImagePojo data) => json.encode(data.toJson());

class PostImagePojo {
  String url;
  String thumbnail;

  PostImagePojo({
    this.url,
    this.thumbnail,
  });

  factory PostImagePojo.fromJson(Map<String, dynamic> json) => PostImagePojo(
    url: json["url"],
    thumbnail: json["thumbnail"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "thumbnail": thumbnail,
  };
}
