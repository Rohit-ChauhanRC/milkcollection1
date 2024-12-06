// To parse this JSON data, do
//
//     final getFarmerPaymentModel = getFarmerPaymentModelFromMap(jsonString);

import 'dart:convert';

List<GetFarmerPaymentModel> getFarmerPaymentModelFromMap(String str) =>
    List<GetFarmerPaymentModel>.from(
        json.decode(str).map((x) => GetFarmerPaymentModel.fromMap(x)));

String getFarmerPaymentModelToMap(List<GetFarmerPaymentModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class GetFarmerPaymentModel {
  String? idNo;
  String? centerId;
  String? farmerName;
  String? totalAmount;
  String? oldAdj;
  String? netAmount;
  String? nameInBank;
  String? accountNo;
  String? ifscCode;
  String? fromDate;
  String? toDate;
  String? paymentId;
  String? payGenerationDate;
  String? totalQty;
  String? releaseDate;

  GetFarmerPaymentModel({
    this.idNo,
    this.centerId,
    this.farmerName,
    this.totalAmount,
    this.oldAdj,
    this.netAmount,
    this.nameInBank,
    this.accountNo,
    this.ifscCode,
    this.fromDate,
    this.toDate,
    this.paymentId,
    this.payGenerationDate,
    this.totalQty,
    this.releaseDate,
  });

  factory GetFarmerPaymentModel.fromMap(Map<String, dynamic> json) =>
      GetFarmerPaymentModel(
        idNo: json["ID_No"],
        centerId: json["CenterID"],
        farmerName: json["FarmerName"],
        totalAmount: json["TotalAmount"],
        oldAdj: json["OldAdj"],
        netAmount: json["NetAmount"],
        nameInBank: json["NameInBank"],
        accountNo: json["AccountNo"],
        ifscCode: json["IFSCCode"],
        fromDate: json["FromDate"],
        toDate: json["ToDate"],
        paymentId: json["Payment_Id"],
        payGenerationDate: json["PayGenerationDate"],
        totalQty: json["TotalQty"],
        releaseDate: json["Release_Date"],
      );

  Map<String, dynamic> toMap() => {
        "ID_No": idNo,
        "CenterID": centerId,
        "FarmerName": farmerName,
        "TotalAmount": totalAmount,
        "OldAdj": oldAdj,
        "NetAmount": netAmount,
        "NameInBank": nameInBank,
        "AccountNo": accountNo,
        "IFSCCode": ifscCode,
        "FromDate": fromDate,
        "ToDate": toDate,
        "Payment_Id": paymentId,
        "PayGenerationDate": payGenerationDate,
        "TotalQty": totalQty,
        "Release_Date": releaseDate,
      };
}
