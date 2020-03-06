import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterbookapp/src/domain/model/Book.dart';
import 'package:flutterbookapp/src/feature/book/BookBloc.dart';

class BookPage extends StatefulWidget {
  BookPage({Key key}) : super(key: key);

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  final BookBloc bloc = BookBloc();

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Библиотека книг'),
      ),
      body: StreamBuilder<List<Book>>(
        stream: bloc.bookList,
        builder: (context, snapshot) {
          Widget widget;
          if (snapshot.data != null && snapshot.data.isNotEmpty)
            widget = _buildList(context, snapshot.data);
          else
            widget = Container(
              child: new Text("Список пуст"),
            );
          return widget;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createAlertDialog(context),
        tooltip: 'Добавить книгу',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<Book> items) {
    return ListView.separated(
      padding: const EdgeInsets.all(10.0),
      itemCount: items.length,
      itemBuilder: (context, i) {
        return _buildRow(context, items[i]);
      },
      separatorBuilder: (context, index) {
        return Divider(thickness: 2);
      },
    );
  }

  Widget _buildRow(BuildContext context, Book book) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(color: Colors.red),
      onDismissed: (direction) {
        bloc.deleteBookStream.add(book.id);
      },
      child: ListTile(
        title: Column(
          children: <Widget>[
            Text(
              book.name,
              textAlign: TextAlign.start,
              style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
            ),
            Text(
              book.author,
              textAlign: TextAlign.start,
              style: TextStyle(color: Color.fromARGB(255, 87, 81, 81)),
            )
          ],
        ),
        onTap: () => _createEditAlertDialog(context, book),
      ),
    );
  }

  _createAlertDialog(BuildContext context) {
    Book book = Book(0, "", "");

    return showDialog(
        context: context, builder: (_) => _createDialog(context, book, false));
  }

  _createEditAlertDialog(BuildContext context, Book book) {
    return showDialog(
        context: context, builder: (_) => _createDialog(context, book, true));
  }

  AlertDialog _createDialog(BuildContext context, Book book, bool isEdit) {
    final TextEditingController _textNameEditController =
        TextEditingController(text: book.name);

    final TextEditingController _textDescriptionEditController =
        TextEditingController(text: book.author);

    String _title, btnOk;
    if (isEdit) {
      _title = "Обновить книгу";
      btnOk = "Обновить";
    } else {
      _title = "Добавьте книгу";
      btnOk = "Добавить";
    }

    return AlertDialog(
      title: Text(_title),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new TextField(
              autofocus: true,
              decoration:
                  new InputDecoration(labelText: 'Введите название книги'),
              controller: _textNameEditController),
          new TextField(
              autofocus: true,
              decoration:
                  new InputDecoration(labelText: 'Введите автора книги'),
              controller: _textDescriptionEditController)
        ],
      ),
      actions: <Widget>[
        MaterialButton(
          elevation: 5.0,
          child: Text("Отмена"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        MaterialButton(
          elevation: 5.0,
          onPressed: () {
            book.name = _textNameEditController.text.toString();
            book.author = _textDescriptionEditController.text.toString();

            if (isEdit)
              bloc.updateBookStream.add(book);
            else
              bloc.addBookStream.add(book);

            Navigator.of(context).pop();
          },
          child: Text(btnOk),
        )
      ],
    );
  }
}
