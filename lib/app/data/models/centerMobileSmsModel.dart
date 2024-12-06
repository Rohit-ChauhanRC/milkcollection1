import 'dart:convert';

List<CenterMobileSmsModel> centerMobileSmsModelFromMap(String str) =>
    List<CenterMobileSmsModel>.from(
        json.decode(str).map((x) => CenterMobileSmsModel.fromMap(x)));

String centerMobileSmsModelToMap(List<CenterMobileSmsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class CenterMobileSmsModel {
  String? mobile1;
  String? mobile2;
  String? mobile3;

  CenterMobileSmsModel({
    this.mobile1,
    this.mobile2,
    this.mobile3,
  });

  factory CenterMobileSmsModel.fromMap(Map<String, dynamic> json) =>
      CenterMobileSmsModel(
        mobile1: json["mobile1"],
        mobile2: json["mobile2"],
        mobile3: json["mobile3"],
      );

  Map<String, dynamic> toMap() => {
        "mobile1": mobile1,
        "mobile2": mobile2,
        "mobile3": mobile3,
      };
}
