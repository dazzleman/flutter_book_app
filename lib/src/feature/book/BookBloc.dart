import 'dart:async';
import 'package:flutterbookapp/src/data/repository/DbBookRepository.dart';
import 'package:flutterbookapp/src/domain/interfaces/IBookRepository.dart';
import 'package:flutterbookapp/src/domain/model/Book.dart';
import 'package:rxdart/rxdart.dart';

class BookBloc {
  IBookRepository _repository;

  final _booksSubject = BehaviorSubject<List<Book>>.seeded(null);

  StreamController _actionAddBookController = StreamController();
  StreamController _actionUpdateBookController = StreamController();
  StreamController _actionDeleteBookController = StreamController();

  BookBloc() {
    _repository = DbBookRepository();

    _getBooks();

    _actionAddBookController.stream.listen(_addBook);
    _actionUpdateBookController.stream.listen(_updateBook);
    _actionDeleteBookController.stream.listen(_deleteBook);
  }

  Stream get bookList => _booksSubject.stream;
  Sink get _addBookValue => _booksSubject.sink;
  
  StreamSink get addBookStream => _actionAddBookController.sink;
  StreamSink get updateBookStream => _actionUpdateBookController.sink;
  StreamSink get deleteBookStream => _actionDeleteBookController.sink;

  void _getBooks() {
    _repository.getAllBooks().then((books) => _addBookValue.add(books));
  }

  void _addBook(dynamic book) {
    _repository.insertBook(book).then((_) => _getBooks());
  }

  void _updateBook(dynamic book) {
    _repository.updateBook(book).then((_) => _getBooks());
  }

  void _deleteBook(dynamic id) {
    _repository.deleteBookById(id).then((_) => _getBooks());
  }

  void dispose() {
    _booksSubject.close();
    _actionAddBookController.close();
    _actionUpdateBookController.close();
    _actionDeleteBookController.close();
  }
}
