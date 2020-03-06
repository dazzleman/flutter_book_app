import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDB();
    return _database;
  }

  _initDB() async {
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String path = join(documentsDir.path, "AppDB.db");
    return await openDatabase(
        path,
        version: 1,
        onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE BookModel ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "name TEXT,"
          "author TEXT"
          ")");

      await db.execute("INSERT INTO BookModel "
          "(id,name,author)"
          "VALUES (0,'Мастер и Маргарита','Михаил Афанасьевич Булгаков')");
      await db.execute("INSERT INTO BookModel "
          "(id,name,author)"
          "VALUES (1,'Цветы для Элджернона','Даниел Киз')");
      await db.execute("INSERT INTO BookModel "
          "(id,name,author)"
          "VALUES (2,'Над пропастью во ржи','Джером Д. Сэлинджер')");
    });
  }
}
