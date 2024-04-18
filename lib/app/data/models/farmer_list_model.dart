// To parse this JSON data, do
//
//     final farmerListModel = farmerListModelFromMap(jsonString);

import 'dart:convert';

List<FarmerListModel> farmerListModelFromMap(String str) =>
    List<FarmerListModel>.from(
        json.decode(str).map((x) => FarmerListModel.fromMap(x)));

String farmerListModelToMap(List<FarmerListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class FarmerListModel {
  int farmerId;
  int calculationsId;
  String farmerName;
  String bankName;
  String branchName;
  String accountName;
  String ifscCode;
  String aadharCardNo;
  String mobileNumber;
  int noOfCows;
  int noOfBuffalos;
  int modeOfPay;
  String rfId;
  String address;
  String exportParameter1;
  String exportParameter2;
  String exportParameter3;
  int centerId;
  String mcpGroup;

  FarmerListModel({
    required this.farmerId,
    required this.calculationsId,
    required this.farmerName,
    required this.bankName,
    required this.branchName,
    required this.accountName,
    required this.ifscCode,
    required this.aadharCardNo,
    required this.mobileNumber,
    required this.noOfCows,
    required this.noOfBuffalos,
    required this.modeOfPay,
    required this.rfId,
    required this.address,
    required this.exportParameter1,
    required this.exportParameter2,
    required this.exportParameter3,
    required this.centerId,
    required this.mcpGroup,
  });

  factory FarmerListModel.fromMap(Map<String, dynamic> json) => FarmerListModel(
        farmerId: json["FarmerId"],
        calculationsId: json["CalculationsID"],
        farmerName: json["FarmerName"],
        bankName: json["BankName"],
        branchName: json["BranchName"],
        accountName: json["AccountName"],
        ifscCode: json["IFSCCode"],
        aadharCardNo: json["AadharCardNo"],
        mobileNumber: json["MobileNumber"],
        noOfCows: json["NoOfCows"],
        noOfBuffalos: json["NoOfBuffalos"],
        modeOfPay: json["ModeOfPay"],
        rfId: json["RF_ID"],
        address: json["Address"],
        exportParameter1: json["ExportParameter1"],
        exportParameter2: json["ExportParameter2"],
        exportParameter3: json["ExportParameter3"],
        centerId: json["CenterID"],
        mcpGroup: json["MCPGroup"]!,
      );

  Map<String, dynamic> toMap() => {
        "FarmerId": farmerId,
        "CalculationsID": calculationsId,
        "FarmerName": farmerName,
        "BankName": bankName,
        "BranchName": branchName,
        "AccountName": accountName,
        "IFSCCode": ifscCode,
        "AadharCardNo": aadharCardNo,
        "MobileNumber": mobileNumber,
        "NoOfCows": noOfCows,
        "NoOfBuffalos": noOfBuffalos,
        "ModeOfPay": modeOfPay,
        "RF_ID": rfId,
        "Address": address,
        "ExportParameter1": exportParameter1,
        "ExportParameter2": exportParameter2,
        "ExportParameter3": exportParameter3,
        "CenterID": centerId,
        "MCPGroup": mcpGroup,
      };
}

// enum McpGroup { MAKLIFE }

// final mcpGroupValues = EnumValues({"Maklife": McpGroup.MAKLIFE});

enum RfId { NULL }

final rfIdValues = EnumValues({"null": RfId.NULL});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
