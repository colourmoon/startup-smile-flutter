// To parse this JSON data, do
//
//     final addressZoneModel = addressZoneModelFromJson(jsonString);

import 'dart:convert';

AddressZoneModel addressZoneModelFromJson(String str) =>
    AddressZoneModel.fromJson(json.decode(str));

String addressZoneModelToJson(AddressZoneModel data) =>
    json.encode(data.toJson());

class AddressZoneModel {
  final Data? data;

  AddressZoneModel({
    this.data,
  });

  factory AddressZoneModel.fromJson(Map<String, dynamic> json) =>
      AddressZoneModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class Data {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? latitude;
  final String? longitude;
  final String? address;
  final String? deliveryRadiusKilometer;
  final String? deliveryChargePerKilo;
  final String? minimumOrderAmount;
  final String? currencyMinimumOrderAmount;
  final int? status;

  Data({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.latitude,
    this.longitude,
    this.address,
    this.deliveryRadiusKilometer,
    this.deliveryChargePerKilo,
    this.minimumOrderAmount,
    this.currencyMinimumOrderAmount,
    this.status,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        address: json["address"],
        deliveryRadiusKilometer: json["delivery_radius_kilometer"],
        deliveryChargePerKilo: json["delivery_charge_per_kilo"],
        minimumOrderAmount: json["minimum_order_amount"],
        currencyMinimumOrderAmount: json["currency_minimum_order_amount"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
        "delivery_radius_kilometer": deliveryRadiusKilometer,
        "delivery_charge_per_kilo": deliveryChargePerKilo,
        "minimum_order_amount": minimumOrderAmount,
        "currency_minimum_order_amount": currencyMinimumOrderAmount,
        "status": status,
      };
}
