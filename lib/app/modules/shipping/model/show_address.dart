// To parse this JSON data, do
//
//     final showAddressModel = showAddressModelFromJson(jsonString);

import 'dart:convert';

ShowAddressModel showAddressModelFromJson(String str) =>
    ShowAddressModel.fromJson(json.decode(str));

String showAddressModelToJson(ShowAddressModel data) =>
    json.encode(data.toJson());

class ShowAddressModel {
  final List<Datum>? data;

  ShowAddressModel({
    this.data,
  });

  factory ShowAddressModel.fromJson(Map<String, dynamic> json) =>
      ShowAddressModel(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  final int? id;
  final int? userId;
  final String? label;
  final String? address;
  final dynamic apartment;
  final String? latitude;
  final String? longitude;

  Datum({
    this.id,
    this.userId,
    this.label,
    this.address,
    this.apartment,
    this.latitude,
    this.longitude,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["user_id"],
        label: json["label"],
        address: json["address"],
        apartment: json["apartment"],
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "label": label,
        "address": address,
        "apartment": apartment,
        "latitude": latitude,
        "longitude": longitude,
      };
}
