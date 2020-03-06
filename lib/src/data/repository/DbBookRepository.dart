import 'dart:async';

import 'package:flutterbookapp/src/data/model/BookModel.dart';
import 'package:flutterbookapp/src/data/source/DBProvider.dart';
import 'package:flutterbookapp/src/domain/interfaces/IBookRepository.dart';
import 'package:flutterbookapp/src/domain/model/Book.dart';
import 'package:sqflite/sqlite_api.dart';

class DbBookRepository implements IBookRepository {
  Future<Database> _database;

  DbBookRepository() {
    _database = DBProvider.db.database;
  }

  @override
  Future<List<Book>> getAllBooks() async {
    final db = await _database;

    final List<Map<String, dynamic>> maps = await db.query('BookModel');
    if (maps.isNotEmpty) {
      return List.generate(maps.length, (i) {
        return Book(
          maps[i]['id'],
          maps[i]['name'],
          maps[i]['author'],
        );
      });
    } else
      return [];
  }

  @override
  Future<Book> getBookById(int id) async {
    final db = await _database;
    var res = await db.query("BookModel", where: "id = ?", whereArgs: [id]);
    BookModel model = res.isNotEmpty ? BookModel.fromMap(res.first) : null;

    return Book(model.id, model.name, model.author);
  }

  @override
  Future<void> insertBook(Book book) async {
    final db = await _database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM BookModel");
    int id = table.first["id"];

    return db.rawInsert(
        "INSERT INTO BookModel (id,name,author)"
        " VALUES (?,?,?)",
        [
          id,
          book.name,
          book.author,
        ]);
  }

  @override
  Future<void> updateBook(Book book) async {
    final db = await _database;

    BookModel model =
        BookModel(id: book.id, name: book.name, author: book.author);
    return db.update("BookModel", model.toMap(),
        where: "id = ?", whereArgs: [model.id]);
  }

  @override
  Future<void> deleteBookById(int id) async {
    final db = await _database;
    return db.delete("BookModel", where: "id = ?", whereArgs: [id]);
  }
}
