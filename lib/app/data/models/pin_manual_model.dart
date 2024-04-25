// To parse this JSON data, do
//
//     final pinnmanualModel = pinnmanualModelFromMap(jsonString);

import 'dart:convert';

List<PinnmanualModel> pinnmanualModelFromMap(String str) =>
    List<PinnmanualModel>.from(
        json.decode(str).map((x) => PinnmanualModel.fromMap(x)));

String pinnmanualModelToMap(List<PinnmanualModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class PinnmanualModel {
  int? centerId;
  int? pin;
  DateTime? insertDate;
  String? insertTime;

  PinnmanualModel({
    this.centerId,
    this.pin,
    this.insertDate,
    this.insertTime,
  });

  factory PinnmanualModel.fromMap(Map<String, dynamic> json) => PinnmanualModel(
        centerId: json["Center_Id"],
        pin: json["Pin"],
        insertDate: json["InsertDate"] == null
            ? null
            : DateTime.parse(json["InsertDate"]),
        insertTime: json["InsertTime"],
      );

  Map<String, dynamic> toMap() => {
        "Center_Id": centerId,
        "Pin": pin,
        "InsertDate":
            "${insertDate!.year.toString().padLeft(4, '0')}-${insertDate!.month.toString().padLeft(2, '0')}-${insertDate!.day.toString().padLeft(2, '0')}",
        "InsertTime": insertTime,
      };
}
