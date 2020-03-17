import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';

import 'model.dart';

//db辅助操作.
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  final String tableName = "table_city";
  final String columnId = "id";
  final String columncityName = "cityname";
  final String columncityID = "cityID";
  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'sqflite.db');
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  //创建数据库表.
  void _onCreate(Database db, int version) async {
    await db.execute(
        "create table $tableName($columnId integer primary key,$columncityName text not null ,$columncityID text not null )");
    print("Table is created");
  }

//插入.
  Future<int> saveItem(CityName city) async {
    var dbClient = await db;
    int res = await dbClient.insert("$tableName", city.toMap());
    print(res.toString());
    return res;
  }

  //查询.
  Future<List> getTotalList() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableName ");
    return result.toList();
  }

  //查询总数.
  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery(
        "SELECT COUNT(*) FROM $tableName"
    ));
  }

//按照id查询.
  Future<CityName> getItem(int id) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableName WHERE id = $id");
    if (result.length == 0) return null;
    return CityName.fromMap(result.first);
  }


  //清空数据.
  Future<int> clear() async {
    var dbClient = await db;
    return await dbClient.delete(tableName);
  }


  //根据id删除.
  Future<int> deleteItem(int id) async {
    var dbClient = await db;
    return await dbClient.delete(tableName,
        where: "$columnId = ?", whereArgs: [id]);
  }

  //修改.
  Future<int> updateItem(CityName city) async {
    var dbClient = await db;
    return await dbClient.update("$tableName", city.toMap(),
        where: "$columnId = ?", whereArgs: [city.id]);
  }

  //关闭.
  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}