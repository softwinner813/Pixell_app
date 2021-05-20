import 'dart:convert';

GetHintsPojo getHintsPojoFromJson(String str) => GetHintsPojo.fromJson(json.decode(str));

String getHintsPojoToJson(GetHintsPojo data) => json.encode(data.toJson());

class GetHintsPojo {
  PixelHints hints;

  GetHintsPojo({
    this.hints,
  });

  factory GetHintsPojo.fromJson(Map<String, dynamic> json) => GetHintsPojo(
    hints: PixelHints.fromJson(json),
  );

  Map<String, dynamic> toJson() => {
    "hints": hints.toJson(),
  };
}

class PixelHints {
  Map<String, dynamic> json;

  PixelHints({
    this.json,
  });

  factory PixelHints.fromJson(Map<String, dynamic> json) => PixelHints(
      json: Map<String, dynamic>.from(json)
  );

  Map<String, String> getHint(String id) {
    return Map<String, String>.from(json[id]);
  }

  Map<String, dynamic> toJson() => json;
}

