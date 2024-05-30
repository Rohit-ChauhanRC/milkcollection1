// To parse this JSON data, do
//
//     final getFarmerPaymentDetailsModel = getFarmerPaymentDetailsModelFromMap(jsonString);

import 'dart:convert';

List<GetFarmerPaymentDetailsModel> getFarmerPaymentDetailsModelFromMap(
        String str) =>
    List<GetFarmerPaymentDetailsModel>.from(
        json.decode(str).map((x) => GetFarmerPaymentDetailsModel.fromMap(x)));

String getFarmerPaymentDetailsModelToMap(
        List<GetFarmerPaymentDetailsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class GetFarmerPaymentDetailsModel {
  String? idNo;
  String? farmerName;
  String? collectionDate;
  String? shift;
  String? milkType;
  String? quantity;
  String? fat;
  String? snf;
  String? addedWater;
  String? rate;
  String? totalAmount;
  String? centerId;
  String? fromDate;
  String? toDate;
  String? payGenerationDate;

  GetFarmerPaymentDetailsModel({
    this.idNo,
    this.farmerName,
    this.collectionDate,
    this.shift,
    this.milkType,
    this.quantity,
    this.fat,
    this.snf,
    this.addedWater,
    this.rate,
    this.totalAmount,
    this.centerId,
    this.fromDate,
    this.toDate,
    this.payGenerationDate,
  });

  factory GetFarmerPaymentDetailsModel.fromMap(Map<String, dynamic> json) =>
      GetFarmerPaymentDetailsModel(
        idNo: json["ID_No"],
        farmerName: json["FarmerName"],
        collectionDate: json["CollectionDate"],
        shift: json["Shift"]!,
        milkType: json["MilkType"],
        quantity: json["Quantity"],
        fat: json["FAT"],
        snf: json["SNF"],
        addedWater: json["Added_water"],
        rate: json["Rate"],
        totalAmount: json["TotalAmount"],
        centerId: json["CenterID"],
        fromDate: json["FromDate"],
        toDate: json["ToDate"],
        payGenerationDate: json["PayGenerationDate"]!,
      );

  Map<String, dynamic> toMap() => {
        "ID_No": idNo,
        "FarmerName": farmerName,
        "CollectionDate": collectionDate,
        "Shift": shift,
        "MilkType": milkType,
        "Quantity": quantity,
        "FAT": fat,
        "SNF": snf,
        "Added_water": addedWater,
        "Rate": rate,
        "TotalAmount": totalAmount,
        "CenterID": centerId,
        "FromDate": fromDate,
        "ToDate": toDate,
        "PayGenerationDate": payGenerationDate,
      };
}
