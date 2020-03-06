import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterbookapp/src/feature/book/BookPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Библиотека книг',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BookPage(),
    );
  }
}
