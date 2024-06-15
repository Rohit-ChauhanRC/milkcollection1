import 'package:milkcollection/app/data/models/farmer_list_model.dart';
import 'package:sqflite/sqflite.dart';

import 'local_database.dart';

class FarmerDB {
  //
  final tableName = 'farmer';

  Future<void> createTable(Database database) async {
    await database.execute("""
  CREATE TABLE IF NOT EXISTS $tableName (
    "FarmerID" INTEGER NOT NULL,
    "Key_id" INTEGER ,
    "FarmerName" TEXT NOT NULL,
    "BankName" TEXT NOT NULL,
    "BranchName" TEXT NOT NULL,
    "AccountName" TEXT,
    "IFSCCode" TEXT,
    "AadharCardNo" TEXT,
    "MobileNumber" TEXT,
    "NoOfCows" INTEGER,
    "NoOfBuffalos" INTEGER,
    "ModeOfPay" INTEGER,
    "RF_ID" TEXT,
    "Address" TEXT,
    "ExportParameter1" TEXT,
    "ExportParameter2" TEXT,
    "ExportParameter3" TEXT,
    "MCPGroup" TEXT,
    "CenterID" INTEGER,
    "FUploaded" INTEGER,
    PRIMARY KEY("Key_id" AUTOINCREMENT)
  );
""");
  }
  // PRIMARY KEY("id" AUTOINCREMENT)
  //

  Future<int> create({
    required int farmerId,
    required String farmerName,
    required String bankName,
    required String branchName,
    String? accountName,
    String? iFSCCode,
    String? aadharCardNo,
    String? mobileNumber,
    int? noOfCows,
    int? noOfBuffalos,
    int? modeOfPay,
    String? rFID,
    String? address,
    String? exportParameter1,
    String? exportParameter2,
    String? exportParameter3,
    String? mCPGroup,
    int? centerID,
    int? FUploaded,
  }) async {
    final database = await DataBaseService().database;
    return await database.rawInsert(
      '''
        INSERT INTO $tableName (FarmerID,FarmerName,BankName,BranchName,AccountName,IFSCCode,AadharCardNo,MobileNumber,NoOfCows,NoOfBuffalos,ModeOfPay,RF_ID,Address,ExportParameter1,ExportParameter2,ExportParameter3,MCPGroup,CenterID,FUploaded) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
      ''',
      [
        farmerId,
        farmerName,
        bankName,
        branchName,
        accountName,
        iFSCCode,
        aadharCardNo,
        mobileNumber,
        noOfCows,
        noOfBuffalos,
        modeOfPay,
        rFID,
        address,
        exportParameter1,
        exportParameter2,
        exportParameter3,
        mCPGroup,
        centerID,
        FUploaded,
      ],
    );
  }

  Future<List<FarmerListModel>> fetchAll() async {
    final database = await DataBaseService().database;
    final farmers = await database.rawQuery('''
        SELECT * from $tableName 
      ''');

    return farmers.map((e) => FarmerListModel.fromMap(e)).toList();
  }

  Future<List<FarmerListModel>> fetchByName(String name) async {
    final database = await DataBaseService().database;
    final farmers = await database.rawQuery('''
        SELECT * from $tableName WHERE FarmerName = ?
      ''', [name]);

    return farmers.map((e) => FarmerListModel.fromMap(e)).toList();
  }

  Future<FarmerListModel> fetchById(String id) async {
    final database = await DataBaseService().database;
    final farmer = await database.rawQuery('''
        SELECT * from $tableName WHERE FarmerID = ? 
      
      ''', [id]);
    return FarmerListModel.fromMap(
        farmer.isNotEmpty ? farmer.first : <String, dynamic>{});
  }

  Future<FarmerListModel> fetchByFUoloaded(bool FUploaded) async {
    final database = await DataBaseService().database;
    final farmer = await database.rawQuery('''
        SELECT * from $tableName WHERE FUploaded = ? 
      
      ''', [FUploaded]);
    return FarmerListModel.fromMap(
        farmer.isNotEmpty ? farmer.first : <String, dynamic>{});
  }

  Future<int> update({
    int? calculationsID,
    required int farmerId,
    String? farmerName,
    String? bankName,
    String? branchName,
    String? accountName,
    String? iFSCCode,
    String? aadharCardNo,
    String? mobileNumber,
    int? noOfCows,
    int? noOfBuffalos,
    int? modeOfPay,
    String? rFID,
    String? address,
    String? exportParameter1,
    String? exportParameter2,
    String? exportParameter3,
    String? mCPGroup,
    int? centerID,
    int? FUploaded,
  }) async {
    final database = await DataBaseService().database;
    return await database.update(
      tableName,
      {
        if (farmerName != null) 'FarmerName': farmerName,
        if (bankName != null) 'BankName': bankName,
        if (branchName != null) 'BranchName': branchName,
        if (accountName != null) 'AccountName': accountName,
        if (iFSCCode != null) 'IFSCCode': iFSCCode,
        if (aadharCardNo != null) 'AadharCardNo': aadharCardNo,
        if (mobileNumber != null) 'MobileNumber': mobileNumber,
        if (noOfCows != null) 'NoOfCows': noOfCows,
        if (noOfBuffalos != null) 'NoOfBuffalos': noOfBuffalos,
        if (modeOfPay != null) 'ModeOfPay': modeOfPay,
        if (rFID != null) 'RF_ID': rFID,
        if (address != null) 'Address': address,
        if (exportParameter1 != null) 'ExportParameter1': exportParameter1,
        if (exportParameter2 != null) 'ExportParameter2': exportParameter2,
        if (exportParameter3 != null) 'ExportParameter3': exportParameter3,
        if (mCPGroup != null) 'MCPGroup': mCPGroup,
        if (centerID != null) 'CenterID': centerID,
        if (FUploaded != null) 'FUploaded': FUploaded,
      },
      where: 'FarmerID = ?',
      conflictAlgorithm: ConflictAlgorithm.rollback,
      whereArgs: [farmerId],
    );
  }

  Future<void> delete({required int id}) async {
    final database = await DataBaseService().database;

    await database.rawDelete('''
  DELETE FROM $tableName WHERE Key_id = ?
''', [id]);
  }

  Future<void> deleteTable() async {
    final database = await DataBaseService().database;

    await database.delete(tableName);
  }

  void onUpgrade(Database db, int oldVersion, int newVersion) {
    // if (oldVersion < newVersion) {
    //   db.execute("ALTER TABLE $tableName ADD COLUMN newCol TEXT;");
    // }
  }
}
