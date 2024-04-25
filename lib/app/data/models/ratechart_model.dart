// To parse this JSON data, do
//
//     final ratechartModel = ratechartModelFromMap(jsonString);

import 'dart:convert';

List<RatechartModel> ratechartModelFromMap(String str) =>
    List<RatechartModel>.from(
        json.decode(str).map((x) => RatechartModel.fromMap(x)));

String ratechartModelToMap(List<RatechartModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class RatechartModel {
  String fat;
  String snf;
  double price;
  String milkType;
  DateTime insertedDate;
  String counters;

  RatechartModel({
    required this.fat,
    required this.snf,
    required this.price,
    required this.milkType,
    required this.insertedDate,
    required this.counters,
  });

  factory RatechartModel.fromMap(Map<String, dynamic> json) => RatechartModel(
        fat: json["Fat"],
        snf: json["Snf"],
        price: json["Price"]?.toDouble(),
        milkType: json["MilkType"],
        insertedDate: DateTime.parse(json["InsertedDate"]),
        counters: json["Counters"],
      );

  Map<String, dynamic> toMap() => {
        "Fat": fat,
        "Snf": snf,
        "Price": price,
        "MilkType": milkType,
        "InsertedDate":
            "${insertedDate.year.toString().padLeft(4, '0')}-${insertedDate.month.toString().padLeft(2, '0')}-${insertedDate.day.toString().padLeft(2, '0')}",
        "Counters": counters,
      };
}
