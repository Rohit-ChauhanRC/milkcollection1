// To parse this JSON data, do
//
//     final loginModel = loginModelFromMap(jsonString);

import 'dart:convert';

List<LoginModel> loginModelFromMap(String str) =>
    List<LoginModel>.from(json.decode(str).map((x) => LoginModel.fromMap(x)));

String loginModelToMap(List<LoginModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class LoginModel {
  String centerId;
  String vilageName;
  String address;
  DateTime dateOfOpening;
  String staffNmae;
  String fatherName;
  String mobileNo;
  String bankName;
  String accountNo;
  String ifscCode;
  String tabletSimNo;
  String monthlyRent;
  String rentAgreement;
  String ownerName;
  String remark;
  String accountName;
  String ownerAccountNo;
  String userName;
  String userPswd;
  String pin;
  String centerName;

  LoginModel({
    required this.centerId,
    required this.vilageName,
    required this.address,
    required this.dateOfOpening,
    required this.staffNmae,
    required this.fatherName,
    required this.mobileNo,
    required this.bankName,
    required this.accountNo,
    required this.ifscCode,
    required this.tabletSimNo,
    required this.monthlyRent,
    required this.rentAgreement,
    required this.ownerName,
    required this.remark,
    required this.accountName,
    required this.ownerAccountNo,
    required this.userName,
    required this.userPswd,
    required this.pin,
    required this.centerName,
  });

  factory LoginModel.fromMap(Map<String, dynamic> json) => LoginModel(
        centerId: json["Center_Id"],
        vilageName: json["Vilage_Name"],
        address: json["Address"],
        dateOfOpening: DateTime.parse(json["Date_Of_Opening"]),
        staffNmae: json["Staff_Nmae"],
        fatherName: json["Father_Name"],
        mobileNo: json["Mobile_No"],
        bankName: json["Bank_Name"],
        accountNo: json["Account_No"],
        ifscCode: json["Ifsc_Code"],
        tabletSimNo: json["Tablet_Sim_No"],
        monthlyRent: json["Monthly_Rent"],
        rentAgreement: json["Rent_Agreement"],
        ownerName: json["Owner_Name"],
        remark: json["Remark"],
        accountName: json["Account_Name"],
        ownerAccountNo: json["Owner_Account_No"],
        userName: json["UserName"],
        userPswd: json["User_Pswd"],
        pin: json["Pin"],
        centerName: json["CenterName"],
      );

  Map<String, dynamic> toMap() => {
        "Center_Id": centerId,
        "Vilage_Name": vilageName,
        "Address": address,
        "Date_Of_Opening":
            "${dateOfOpening.year.toString().padLeft(4, '0')}-${dateOfOpening.month.toString().padLeft(2, '0')}-${dateOfOpening.day.toString().padLeft(2, '0')}",
        "Staff_Nmae": staffNmae,
        "Father_Name": fatherName,
        "Mobile_No": mobileNo,
        "Bank_Name": bankName,
        "Account_No": accountNo,
        "Ifsc_Code": ifscCode,
        "Tablet_Sim_No": tabletSimNo,
        "Monthly_Rent": monthlyRent,
        "Rent_Agreement": rentAgreement,
        "Owner_Name": ownerName,
        "Remark": remark,
        "Account_Name": accountName,
        "Owner_Account_No": ownerAccountNo,
        "UserName": userName,
        "User_Pswd": userPswd,
        "Pin": pin,
        "CenterName": centerName,
      };
}
