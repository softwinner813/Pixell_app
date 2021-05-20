import 'dart:convert';

ReportUserPojo userPojoFromJson(String str) => ReportUserPojo.fromJson(json.decode(str));

String reportUserPojoToJson(ReportUserPojo data) => json.encode(data.toJson());

class ReportUserPojo {
  String error;
  bool success;
  String detail;

  ReportUserPojo(
      {
        this.error,
        this.success,
        this.detail});

  factory ReportUserPojo.fromJson(Map<String, dynamic> json) => ReportUserPojo(
    error: json["error"],
    success: json["success"],
    detail: json["detail"],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "success": success,
    "error": detail,
  };
}