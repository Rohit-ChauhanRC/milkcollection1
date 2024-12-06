import 'package:milkcollection/app/data/models/milk_collection_model.dart';
import 'package:sqflite/sqflite.dart';

import 'local_database.dart';

class MilkCollectionDB {
  //
  final tableName = 'gudaaspurmilkcollection';

  Future<void> createTable(Database database) async {
    await database.execute("""
  CREATE TABLE IF NOT EXISTS $tableName (
    "id" INTEGER ,
    "Collection_Date" TEXT,
    "Inserted_Time" TEXT,
    "FarmerId" INTEGER,
    "Farmer_Name" TEXT,
    "Collection_Mode" TEXT,
    "Scale_Mode" TEXT,
    "Analyze_Mode" TEXT,
    "Milk_Status" TEXT,
    "Milk_Type" TEXT,
    "Rate_Chart_Name" TEXT,
    "Qty" REAL,
    "FAT" REAL,
    "SNF" REAL,
    "Added_Water" REAL,
    "Rate_Per_Liter" REAL,
    "Total_Amt" REAL,
    "CollectionCenterId" INTEGER,
    "CollectionCenterName" TEXT,
    "Calculations_ID" TEXT,
    "Shift" TEXT,
    "FUploaded" INTEGER,
    PRIMARY KEY("id" AUTOINCREMENT)
  );
""");
  }
  // PRIMARY KEY("id" AUTOINCREMENT)
  //

  Future<void> create({
    int? FarmerId,
    String? Farmer_Name,
    String? Calculations_ID,
    String? Collection_Date,
    String? Inserted_Time,
    String? Collection_Mode,
    String? Scale_Mode,
    String? Analyze_Mode,
    String? Milk_Status,
    String? Milk_Type,
    String? Rate_Chart_Name,
    String? CollectionCenterName,
    String? CollectionCenterId,
    String? Shift,
    double? Qty,
    double? FAT,
    double? SNF,
    double? Added_Water,
    double? Rate_Per_Liter,
    double? Total_Amt,
    int? FUploaded,
  }) async {
    try {
      final database = await DataBaseService().database;
      await database.rawInsert(
        '''
        INSERT INTO $tableName (Calculations_ID,Collection_Date,Inserted_Time,FarmerId,Farmer_Name,Collection_Mode,Scale_Mode,Analyze_Mode,Milk_Status,Milk_Type,Rate_Chart_Name,Qty,FAT,SNF,Added_Water,Rate_Per_Liter,Total_Amt,CollectionCenterId,CollectionCenterName,Shift,FUploaded) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
      ''',
        [
          Calculations_ID,
          Collection_Date,
          Inserted_Time,
          FarmerId,
          Farmer_Name,
          Collection_Mode,
          Scale_Mode,
          Analyze_Mode,
          Milk_Status,
          Milk_Type,
          Rate_Chart_Name,
          Qty,
          FAT,
          SNF,
          Added_Water,
          Rate_Per_Liter,
          Total_Amt,
          CollectionCenterId,
          CollectionCenterName,
          Shift,
          FUploaded
        ],
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<MilkCollectionModel>> fetchAll() async {
    final database = await DataBaseService().database;
    final farmers = await database.rawQuery('''
        SELECT * from $tableName 
      ''');

    return farmers.map((e) => MilkCollectionModel.fromMap(e)).toList();
  }

  Future<List<MilkCollectionModel>> fetchByName(String name) async {
    final database = await DataBaseService().database;
    final farmers = await database.rawQuery('''
        SELECT * from $tableName WHERE FarmerName = ?
      ''', [name]);

    return farmers.map((e) => MilkCollectionModel.fromMap(e)).toList();
  }

  Future<MilkCollectionModel> fetchById(int id) async {
    final database = await DataBaseService().database;
    final farmer = await database.rawQuery('''
        SELECT * from $tableName WHERE FarmerID = ? 
      
      ''', [id]);
    return MilkCollectionModel.fromMap(
        farmer.isNotEmpty ? farmer.first : <String, dynamic>{});
  }

  Future<MilkCollectionModel> fetchByFUoloaded(bool FUploaded) async {
    final database = await DataBaseService().database;
    final farmer = await database.rawQuery('''
        SELECT * from $tableName WHERE FUploaded = ? 
      
      ''', [FUploaded]);
    return MilkCollectionModel.fromMap(
        farmer.isNotEmpty ? farmer.first : <String, dynamic>{});
  }

  Future<Iterable<MilkCollectionModel>> fetchByDate(
      String from, String shift) async {
    final database = await DataBaseService().database;
    final products = await database.rawQuery('''
        SELECT * from $tableName WHERE Collection_Date ==? AND Shift == ?
      
      ''', [from, shift]);
    print(products.toSet());
    return products.map((e) => MilkCollectionModel.fromMap(e)).toList();
  }

  Future<int> update({
    String? farmerId,
    int? FUploaded,
  }) async {
    final database = await DataBaseService().database;
    return await database.update(
      tableName,
      {
        if (FUploaded != null) 'FUploaded': FUploaded,
      },
      where: 'Calculations_ID = ?',
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
    if (oldVersion < newVersion) {
      db.execute("ALTER TABLE $tableName ADD COLUMN Calculations_ID TEXT;");
    }
  }
}
