import 'package:milkcollection/app/data/local_database/rateChartCM_db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'cans_db.dart';
import 'farmer_db.dart';
import 'milk_collection_db.dart';
import 'ratechart_db.dart';

class DataBaseService {
  Database? _database;

  Future<Database> get database async {
    //
    if (_database != null) {
      return _database!;
    }

    _database = await _initialize();
    return _database!;
  }

  Future<String> get fullPath async {
    const name = 'milkcollector.db';
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future<Database> _initialize() async {
    final path = await fullPath;
    var database = await openDatabase(
      path,
      version: 2,
      onCreate: create,
      singleInstance: true,
      onUpgrade: onUpgrade,
    );
    return database;
  }

  Future<void> create(Database database, int verion) async {
    await FarmerDB().createTable(database);
    await RateChartDB().createTable(database);
    await MilkCollectionDB().createTable(database);
    await CansDB().createTable(database);
    await RateChartCMDB().createTable(database);
    // await ReceivingDB().createTable(database);
    // await SellDB().createTable(database);
    // await ProfileDB().createTable(database);
  }

  void onUpgrade(Database database, int oldVersion, int newVersion) async {
    MilkCollectionDB().onUpgrade(database, oldVersion, newVersion);
    // VendorDB().onUpgrade(database, oldVersion, newVersion);
    // ReceivingDB().onUpgrade(database, oldVersion, newVersion);
    // SellDB().onUpgrade(database, oldVersion, newVersion);
    // ProfileDB().onUpgrade(database, oldVersion, newVersion);
  }
}
