// To parse this JSON data, do
//
//     final accountPojo = accountPojoFromJson(jsonString);

import 'dart:convert';

AccountPojo accountPojoFromJson(String str) =>
    AccountPojo.fromJson(json.decode(str));

String accountPojoToJson(AccountPojo data) => json.encode(data.toJson());

class AccountPojo {
  String detail;
  String statusCode;
  int count;
  dynamic next;
  dynamic previous;
  List<ResultAccount> results;

  AccountPojo({
    this.detail,
    this.statusCode,
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory AccountPojo.fromJson(Map<String, dynamic> json) => AccountPojo(
        detail: json["detail"],
        statusCode: json["status_code"],
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: json["results"] == null
            ? null
            : List<ResultAccount>.from(
                json["results"].map((x) => ResultAccount.fromJson(x))),
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

class ResultAccount {
  int id;
  int user;
  AmazonAccount amazonAccount;
  BankAccount bankAccount;

  ResultAccount({
    this.id,
    this.user,
    this.amazonAccount,
    this.bankAccount,
  });

  factory ResultAccount.fromJson(Map<String, dynamic> json) => ResultAccount(
        id: json["id"],
        user: json["user"],
        amazonAccount: json["amazon_account"] == null
            ? null
            : AmazonAccount.fromJson(json["amazon_account"]),
        bankAccount: json["bank_account"] == null
            ? null
            : BankAccount.fromJson(json["bank_account"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "amazon_account": amazonAccount.toJson(),
        "bank_account": bankAccount.toJson(),
      };
}

class AmazonAccount {
  String username;
  String country;

  AmazonAccount({
    this.username,
    this.country,
  });

  factory AmazonAccount.fromJson(Map<String, dynamic> json) => AmazonAccount(
        username: json["username"],
        country: json["country"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "country": country,
      };
}

class BankAccount {
  String ownerName;
  String bankName;
  String number;
  String country;
  String swift;
  String branchName;
  String branchAddress;
  String type;

  BankAccount(
      {this.ownerName,
      this.bankName,
      this.number,
      this.country,
      this.swift,
      this.branchName,
      this.branchAddress,
      this.type});

  factory BankAccount.fromJson(Map<String, dynamic> json) => BankAccount(
        ownerName: json["owner_name"],
        bankName: json["bank_name"],
        number: json["number"],
        country: json["country"],
        swift: json["swift"],
        branchName: json["branch_name"],
        branchAddress: json["branch_address"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "owner_name": ownerName,
        "bank_name": bankName,
        "number": number,
        "country": country,
        "swift": swift,
        "branch_name": branchName,
        "branch_address": branchAddress,
        "type": type
      };
}
