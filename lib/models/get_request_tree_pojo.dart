// To parse this JSON data, do
//
//     final requestTreePojo = requestTreePojoFromJson(jsonString);

import 'dart:convert';

import 'package:pixell_app/utils/my_constants.dart';

List<RequestTreePojo> requestTreePojoFromJson(String str) =>
    List<RequestTreePojo>.from(
        json.decode(str).map((x) => RequestTreePojo.fromJson(x)));

String requestTreePojoToJson(List<RequestTreePojo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RequestTreePojo {
  RequestTreePojoData data;
  int id;
  List<RequestTreePojoChild> children;

  RequestTreePojo({
    this.data,
    this.id,
    this.children,
  });

  factory RequestTreePojo.fromJson(Map<String, dynamic> json) =>
      RequestTreePojo(
        data: json["data"] == null
            ? null
            : RequestTreePojoData.fromJson(json["data"]),
        id: json["id"] == null ? null : json["id"],
        children: json["children"] == null
            ? null
            : List<RequestTreePojoChild>.from(
                json["children"].map((x) => RequestTreePojoChild.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "id": id,
        "children": List<dynamic>.from(children.map((x) => x.toJson())),
      };
}

class RequestTreePojoChild {
  FluffyData data;
  int id;
  var selectedName = '';
  var selectedImg = '';
  int selectedId;
  var previousSelectedParentName;
  List<PurpleChild> children;

  RequestTreePojoChild(
      {this.data, this.id, this.children, this.selectedName, this.selectedImg, this.selectedId,this.previousSelectedParentName});

  factory RequestTreePojoChild.fromJson(Map<String, dynamic> json) =>
      RequestTreePojoChild(
        data: json["data"] == null ? null : FluffyData.fromJson(json["data"]),
        id: json["id"] == null ? null : json["id"],
        children: json["children"] == null
            ? null
            : List<PurpleChild>.from(
                json["children"].map((x) => PurpleChild.fromJson(x))),
        selectedName: '',
        selectedId: MyConstants.TEMP_TREE_NOT_SELECTID,
        previousSelectedParentName: '',
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "id": id,
        "children": List<dynamic>.from(children.map((x) => x.toJson())),
      };
}

class PurpleChild {
  TentacledData data;
  int id;
  List<FluffyChild> children;

  PurpleChild({
    this.data,
    this.id,
    this.children,
  });

  factory PurpleChild.fromJson(Map<String, dynamic> json) => PurpleChild(
        data:
            json["data"] == null ? null : TentacledData.fromJson(json["data"]),
        id: json["id"] == null ? null : json["id"],
        children: json["children"] == null
            ? null
            : List<FluffyChild>.from(
                json["children"].map((x) => FluffyChild.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "id": id,
        "children": children == null
            ? null
            : List<dynamic>.from(children.map((x) => x.toJson())),
      };
}

class FluffyChild {
  FluffyData data;
  int id;
  List<TentacledChild> children;

  FluffyChild({
    this.data,
    this.id,
    this.children,
  });

  factory FluffyChild.fromJson(Map<String, dynamic> json) => FluffyChild(
        data: json["data"] == null ? null : FluffyData.fromJson(json["data"]),
        id: json["id"] == null ? null : json["id"],
        children: json["children"] == null
            ? null
            : List<TentacledChild>.from(
                json["children"].map((x) => TentacledChild.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "id": id,
        "children": children == null
            ? null
            : List<dynamic>.from(children.map((x) => x.toJson())),
      };
}

class TentacledChild {
  FluffyData data;
  int id;
  List<StickyChild> children;

  TentacledChild({
    this.data,
    this.id,
    this.children,
  });

  factory TentacledChild.fromJson(Map<String, dynamic> json) => TentacledChild(
        data: json["data"] == null ? null : FluffyData.fromJson(json["data"]),
        id: json["id"] == null ? null : json["id"],
        children: json["children"] == null
            ? null
            : List<StickyChild>.from(
                json["children"].map((x) => StickyChild.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "id": id,
        "children": List<dynamic>.from(children.map((x) => x.toJson())),
      };
}

class StickyChild {
  PurpleData data;
  int id;
  var children;

  StickyChild({
    this.data,
    this.id,
    this.children,
  });

  factory StickyChild.fromJson(Map<String, dynamic> json) => StickyChild(
        data: json["data"] == null ? null : PurpleData.fromJson(json["data"]),
        id: json["id"] == null ? null : json["id"],
        children: null,
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "id": id,
        "children": children,
      };
}

class PurpleData {
  String name;
  PurpleMetadata metadata;
  String img;

  PurpleData({
    this.name,
    this.metadata,
    this.img,
  });

  factory PurpleData.fromJson(Map<String, dynamic> json) => PurpleData(
        name: json["name"] == null ? null : json["name"],
        metadata: json["metadata"] == null
            ? null
            : PurpleMetadata.fromJson(json["metadata"]),
        img: json["img"] == null ? null : json["img"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "metadata": metadata == null ? null : metadata.toJson(),
        "img": img
      };
}

class PurpleMetadata {
  Filters filters;

  PurpleMetadata({
    this.filters,
  });

  factory PurpleMetadata.fromJson(Map<String, dynamic> json) => PurpleMetadata(
        filters:
            json["filters"] == null ? null : Filters.fromJson(json["filters"]),
      );

  Map<String, dynamic> toJson() => {
        "filters": filters.toJson(),
      };
}

class Filters {
  String gender;

  Filters({
    this.gender,
  });

  factory Filters.fromJson(Map<String, dynamic> json) => Filters(
        gender: json["gender"] == null ? null : json["gender"],
      );

  Map<String, dynamic> toJson() => {
        "gender": gender,
      };
}

class FluffyData {
  String name;
  String img;

  FluffyData({
    this.name,
    this.img,
  });

  factory FluffyData.fromJson(Map<String, dynamic> json) => FluffyData(
        name: json["name"] == null ? null : json["name"],
        img: json["img"] == null ? null : json["img"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "img": img,
      };
}

class TentacledData {
  FluffyMetadata metadata;
  String name;
  String img;

  TentacledData({
    this.metadata,
    this.name,
    this.img,
  });

  factory TentacledData.fromJson(Map<String, dynamic> json) => TentacledData(
        metadata: json["metadata"] == null
            ? null
            : FluffyMetadata.fromJson(json["metadata"]),
        name: json["name"] == null ? null : json["name"],
        img: json["img"] == null ? null : json["img"],
      );

  Map<String, dynamic> toJson() => {
        "metadata": metadata == null ? null : metadata.toJson(),
        "name": name,
        "img": img,
      };
}

class FluffyMetadata {
  String description;

  FluffyMetadata({
    this.description,
  });

  factory FluffyMetadata.fromJson(Map<String, dynamic> json) => FluffyMetadata(
        description: json["description"] == null ? null : json["description"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
      };
}

class RequestTreePojoData {
  TentacledMetadata metadata;
  String name;
  String img;

  RequestTreePojoData({
    this.metadata,
    this.name,
    this.img,
  });

  factory RequestTreePojoData.fromJson(Map<String, dynamic> json) =>
      RequestTreePojoData(
        metadata: json["metadata"] == null
            ? null
            : TentacledMetadata.fromJson(json["metadata"]),
        name: json["name"] == null ? null : json["name"],
        img: json["img"] == null ? null : json["img"],
      );

  Map<String, dynamic> toJson() => {
        "metadata": metadata.toJson(),
        "name": name,
        "img": img,
      };
}

class TentacledMetadata {
  bool root;

  TentacledMetadata({
    this.root,
  });

  factory TentacledMetadata.fromJson(Map<String, dynamic> json) =>
      TentacledMetadata(
        root: json["root"],
      );

  Map<String, dynamic> toJson() => {
        "root": root,
      };
}
