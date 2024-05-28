import 'package:milkcollection/app/data/models/cans_model.dart';
import 'package:sqflite/sqflite.dart';

import 'local_database.dart';

class CansDB {
  //
  final tableName = 'cansdb';

  Future<void> createTable(Database database) async {
    await database.execute("""
  CREATE TABLE IF NOT EXISTS $tableName (
    "_Date_" TEXT NOT NULL,
    "id" INTEGER ,
    "shift" TEXT NOT NULL,
    "cow_cans" TEXT NOT NULL,
    "buff_cans" TEXT NOT NULL,
    "FUploaded" INTEGER,
    PRIMARY KEY("id" AUTOINCREMENT)
  );
""");
  }
  // PRIMARY KEY("id" AUTOINCREMENT)
  //

  Future<int> create({
    String? date,
    String? shift,
    String? cowCans,
    String? bufCans,
    int? FUploaded,
  }) async {
    final database = await DataBaseService().database;
    return await database.rawInsert(
      '''
        INSERT INTO $tableName (_Date_,
       shift,
       cow_cans,
       buff_cans,
        FUploaded) VALUES (?,?,?,?,?)
      ''',
      [date, shift, cowCans, bufCans, FUploaded],
    );
  }

  Future<List<CansModel>> fetchAll() async {
    final database = await DataBaseService().database;
    final farmers = await database.rawQuery('''
        SELECT * from $tableName 
      ''');

    return farmers.map((e) => CansModel.fromMap(e)).toList();
  }

  Future<List<CansModel>> fetchCans(String date, String shift) async {
    final database = await DataBaseService().database;
    final farmers = await database.rawQuery('''
        SELECT * from $tableName WHERE _Date_ =? AND
       shift = ?
      ''', [date, shift]);

    return farmers.map((e) => CansModel.fromMap(e)).toList();
  }

  Future<CansModel> fetchById(String id) async {
    final database = await DataBaseService().database;
    final farmer = await database.rawQuery('''
        SELECT * from $tableName WHERE FarmerID = ? 
      
      ''', [id]);
    return CansModel.fromMap(
        farmer.isNotEmpty ? farmer.first : <String, dynamic>{});
  }

  Future<CansModel> fetchByFUoloaded(bool FUploaded) async {
    final database = await DataBaseService().database;
    final farmer = await database.rawQuery('''
        SELECT * from $tableName WHERE FUploaded = ? 
      
      ''', [FUploaded]);
    return CansModel.fromMap(
        farmer.isNotEmpty ? farmer.first : <String, dynamic>{});
  }

  Future<int> update({
    String? date,
    String? shift,
    String? cowCans,
    String? bufCans,
    int? FUploaded,
  }) async {
    final database = await DataBaseService().database;
    return await database.update(
      tableName,
      {
        if (date != null) '_Date_': date,
        if (shift != null) 'shift': shift,
        if (cowCans != null) 'cowCans': cowCans,
        if (bufCans != null) 'bufCans': bufCans,
        if (FUploaded != null) 'FUploaded': FUploaded,
      },
      where: '_Date_ = ? AND shift =?',
      conflictAlgorithm: ConflictAlgorithm.rollback,
      whereArgs: [date, shift],
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
