import 'package:milkcollection/app/data/models/ratechart_model.dart';
import 'package:sqflite/sqflite.dart';

import 'local_database.dart';

class RateChartCMDB {
  //
  final tableName = 'gudaaspurratechartcm';

  Future<void> createTable(Database database) async {
    await database.execute("""
  CREATE TABLE IF NOT EXISTS $tableName (
    "id" INTEGER ,
    "Fat" TEXT,
    "Price" FLOAT,
    "MilkType" TEXT ,
    "Snf" TEXT ,
    "InsertedDate" TEXT,
    "Counters" TEXT,
    "CollectionCenterId" TEXT,
    PRIMARY KEY("id" AUTOINCREMENT)
  );
""");
  }

  Future<int> create({
    String? fat,
    String? price,
    String? milkType,
    String? snf,
    String? insertedDate,
    String? counters,
    String? collectionCenterId,
  }) async {
    final database = await DataBaseService().database;
    return await database.rawInsert(
      '''
        INSERT INTO $tableName (Fat,Price,MilkType,Snf,InsertedDate,Counters,CollectionCenterId) VALUES (?,?,?,?,?,?,?)
      ''',
      [fat, price, milkType, snf, insertedDate, counters, collectionCenterId],
    );
  }

  Future<List<RatechartModel>> fetchAll() async {
    final database = await DataBaseService().database;
    final farmers = await database.rawQuery('''
        SELECT * from $tableName
      ''');

    return farmers.map((e) => RatechartModel.fromMap(e)).toList();
  }

  Future<List<RatechartModel>> fetchByMilkType(String milktype) async {
    final database = await DataBaseService().database;
    final farmers = await database.rawQuery('''
        SELECT * from $tableName where MilkType =?
      ''', [milktype]);

    return farmers.map((e) => RatechartModel.fromMap(e)).toList();
  }

  Future<List<RatechartModel>> fetchPrice(String fat, String snf) async {
    final database = await DataBaseService().database;
    final farmers = await database.rawQuery('''
        SELECT * from $tableName where Fat = ? AND Snf = ?
      ''', [fat, snf]);

    return farmers.map((e) => RatechartModel.fromMap(e)).toList();
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
