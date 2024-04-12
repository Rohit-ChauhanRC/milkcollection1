// To parse this JSON data, do
//
//     final farmerModel = farmerModelFromMap(jsonString);

import 'dart:convert';

List<FarmerModel> farmerModelFromMap(String str) =>
    List<FarmerModel>.from(json.decode(str).map((x) => FarmerModel.fromMap(x)));

String farmerModelToMap(List<FarmerModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class FarmerModel {
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
  RfId rfId;
  String address;
  String exportParameter1;
  String exportParameter2;
  String exportParameter3;
  int centerId;
  McpGroup mcpGroup;

  FarmerModel({
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

  factory FarmerModel.fromMap(Map<String, dynamic> json) => FarmerModel(
        farmerId: json["FarmerID"],
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
        rfId: rfIdValues.map[json["RF_ID"]]!,
        address: json["Address"],
        exportParameter1: json["ExportParameter1"],
        exportParameter2: json["ExportParameter2"],
        exportParameter3: json["ExportParameter3"],
        centerId: json["CenterID"],
        mcpGroup: mcpGroupValues.map[json["MCPGroup"]]!,
      );

  Map<String, dynamic> toMap() => {
        "FarmerID": farmerId,
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
        "RF_ID": rfIdValues.reverse[rfId],
        "Address": address,
        "ExportParameter1": exportParameter1,
        "ExportParameter2": exportParameter2,
        "ExportParameter3": exportParameter3,
        "CenterID": centerId,
        "MCPGroup": mcpGroupValues.reverse[mcpGroup],
      };
}

enum McpGroup { MAKLIFE }

final mcpGroupValues = EnumValues({"Maklife": McpGroup.MAKLIFE});

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
