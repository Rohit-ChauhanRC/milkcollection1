// To parse this JSON data, do
//
//     final CansModel = CansModelFromMap(jsonString);

import 'dart:convert';

List<CansModel> cansModelFromMap(String str) =>
    List<CansModel>.from(json.decode(str).map((x) => CansModel.fromMap(x)));

String cansModelToMap(List<CansModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class CansModel {
  String? date;
  String? shift;
  String? cowCans;
  String? bufCans;
  int? FUploaded;

  CansModel({
    this.date,
    this.shift,
    this.cowCans,
    this.bufCans,
    this.FUploaded,
  });

  factory CansModel.fromMap(Map<String, dynamic> json) => CansModel(
        date: json["_Date_"],
        shift: json["shift"],
        cowCans: json["cow_cans"],
        bufCans: json["buff_cans"],
        FUploaded: json["FUploaded"] ?? 1,
      );

  Map<String, dynamic> toMap() => {
        "_Date_": date,
        "shift": shift,
        "cow_cans": cowCans,
        "buff_cans": bufCans,
        "FUploaded": FUploaded,
      };
}
