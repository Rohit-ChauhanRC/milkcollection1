// To parse this JSON data, do
//
//     final milkCollectionModel = milkCollectionModelFromMap(jsonString);

import 'dart:convert';

List<MilkCollectionModel> milkCollectionModelFromMap(String str) =>
    List<MilkCollectionModel>.from(
        json.decode(str).map((x) => MilkCollectionModel.fromMap(x)));

String milkCollectionModelToMap(List<MilkCollectionModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class MilkCollectionModel {
  String? collectionDate;
  String? insertedTime;
  String? calculationsId;
  int? farmerId;
  String? farmerName;
  String? collectionMode;
  String? scaleMode;
  String? analyzeMode;
  String? milkStatus;
  String? milkType;
  String? rateChartName;
  double? qty;
  double? fat;
  double? snf;
  double? addedWater;
  double? ratePerLiter;
  double? totalAmt;
  int? collectionCenterId;
  String? collectionCenterName;
  String? shift;
  int? FUploaded;

  MilkCollectionModel({
    this.collectionDate,
    this.insertedTime,
    this.calculationsId,
    this.farmerId,
    this.farmerName,
    this.collectionMode,
    this.scaleMode,
    this.analyzeMode,
    this.milkStatus,
    this.milkType,
    this.rateChartName,
    this.qty,
    this.fat,
    this.snf,
    this.addedWater,
    this.ratePerLiter,
    this.totalAmt,
    this.collectionCenterId,
    this.collectionCenterName,
    this.shift,
    this.FUploaded,
  });

  factory MilkCollectionModel.fromMap(Map<String, dynamic> json) =>
      MilkCollectionModel(
        collectionDate: json["Collection_Date"],
        insertedTime: json["Inserted_Time"],
        calculationsId: json["Calculations_ID"].toString(),
        farmerId: json["FarmerId"],
        farmerName: json["Farmer_Name"],
        collectionMode: json["Collection_Mode"],
        scaleMode: json["Scale_Mode"],
        analyzeMode: json["Analyze_Mode"],
        milkStatus: json["Milk_Status"],
        milkType: json["Milk_Type"],
        rateChartName: json["Rate_Chart_Name"],
        qty: json["Qty"],
        fat: json["FAT"],
        snf: json["SNF"],
        addedWater: json["Added_Water"],
        ratePerLiter: json["Rate_Per_Liter"]?.toDouble(),
        totalAmt: json["Total_Amt"]?.toDouble(),
        collectionCenterId: json["CollectionCenterId"],
        collectionCenterName: json["CollectionCenterName"],
        shift: json["Shift"],
        FUploaded: json["FUploaded"] ?? 1,
      );

  Map<String, dynamic> toMap() => {
        "Collection_Date": collectionDate,
        "Inserted_Time": insertedTime,
        "Calculations_ID": calculationsId,
        "FarmerId": farmerId,
        "Farmer_Name": farmerName,
        "Collection_Mode": collectionMode,
        "Scale_Mode": scaleMode,
        "Analyze_Mode": analyzeMode,
        "Milk_Status": milkStatus,
        "Milk_Type": milkType,
        "Rate_Chart_Name": rateChartName,
        "Qty": qty,
        "FAT": fat,
        "SNF": snf,
        "Added_Water": addedWater,
        "Rate_Per_Liter": ratePerLiter,
        "Total_Amt": totalAmt,
        "CollectionCenterId": collectionCenterId,
        "CollectionCenterName": collectionCenterName,
        "Shift": shift,
        "FUploaded": FUploaded,
      };
}
