
import 'package:flutterbookapp/src/domain/model/Book.dart';

class IBookRepository {

  Future<List<Book>> getAllBooks() {}

  Future<Book> getBookById(int id) {}

  insertBook(Book book) {}

  updateBook(Book book) {}

  deleteBookById(int id) {}
}