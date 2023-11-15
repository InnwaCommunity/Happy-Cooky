import 'dart:io';
import 'package:new_project/models/menu_item.dart';
import 'package:new_project/models/total_balance_model.dart';
import 'package:new_project/models/usage_item.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:developer' as dev;

class SqliteService {
  SqliteService._privateConstructor();
  static final SqliteService instance = SqliteService._privateConstructor();

  static Database? _db;

  static const dbversion = 1;
  static const String dbname = 'happycooky.db';
  static const String tbltotalrecords = 'TotalBalanceRecord';
  static const String tblmenuitemrecords = 'MenuItemRecord';
  static const String tblusagerecords = 'tblusagerecords';

  static const String totalautoid = 'totalautoid';
  static const String totalbalance = 'totalbalance';
  static const String totaldes = 'totaldes';
  static const String insertdate = "insertdate";
  static const String starttimerangedate = "starttimerangedate";
  static const String endtimerangedate = 'endtimerangedate';
  static const String sharestatus = 'sharestatus';

  static const String menuitemautoid = "menuitemautoid";
  static const String menuname = "menuname";
  static const String menuprice = "menuprice";
  static const String menudesc = "menudesc";
  static const String menuitemdate = "menuitemdate";

  static const String usageautoid = "usageautoid";
  static const String usageamount = "usageamount";
  static const String remainingbalance = "remainingbalance";

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbname);
    return await openDatabase(path,
        version: dbversion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future<void> _onCreate(Database db, int version) async {
    try {
      await db.execute('''
          CREATE TABLE $tbltotalrecords (
            $totalautoid INTEGER PRIMARY KEY AUTOINCREMENT,
            $totalbalance TEXT NOT NULL,
            $totaldes TEXT NOT NULL,
            $insertdate TEXT NOT NULL,
            $starttimerangedate TEXT NOT NULL,
            $endtimerangedate TEXT NOT NULL,
            $sharestatus TEXT NOT NULL
          )
          ''');

      await db.execute('''
          CREATE TABLE $tblmenuitemrecords (
            $menuitemautoid INTEGER PRIMARY KEY AUTOINCREMENT,
            $menuname TEXT NOT NULL,
            $menuprice TEXT NOT NULL,
            $menudesc TEXT NOT NULL,
            $menuitemdate TEXT NOT NULL,
            $sharestatus TEXT NOT NULL
          )
          ''');

      await db.execute('''
          CREATE TABLE $tblusagerecords (
            $usageautoid INTEGER PRIMARY KEY AUTOINCREMENT,
            $totalbalance TEXT NOT NULL,
            $usageamount TEXT NOT NULL,
            $remainingbalance TEXT NOT NULL,
            $insertdate TEXT NOT NULL,
            $sharestatus TEXT NOT NULL
          )
          ''');
    } catch (error) {
      dev.log(error.toString());
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  Future<bool> saveTotalBalance(TotalBalanceModel record) async {
    try {
      Database db = await instance.db;
      await db.insert(tbltotalrecords, record.toMap());
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> saveMenuItem(MenuItem menuItem) async {
    try {
      Database db = await instance.db;
      await db.insert(tblmenuitemrecords, menuItem.toMap());
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> saveUsageBalance(UsageItem usageItem) async {
    try {
      Database db = await instance.db;
      await db.insert(tblusagerecords, usageItem.toMap());
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<List<TotalBalanceModel>> getTotalBalanceList() async {
    Database db = await instance.db;

    try {
      final List<Map<String, dynamic>> maps = await db.query(tbltotalrecords);

      if (maps.isNotEmpty) {
        return List.generate(maps.length, (i) {
          return TotalBalanceModel.fromMap(maps[i]);
        });
      }
    } catch (error) {
      return [];
    }

    return [];
  }
}
