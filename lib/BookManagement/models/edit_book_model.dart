import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:ffmpeg_flutter_test/BookManagement/json/BookDetailStruct.dart';
import 'package:ffmpeg_flutter_test/BookManagement/json/JsonStruct.dart';
import 'package:ffmpeg_flutter_test/BookManagement/json/Yahooapis.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

import 'package:ffmpeg_flutter_test/BookManagement/json/JsonStruct.dart';
import 'package:ffmpeg_flutter_test/BookManagement/json/BookStruct.dart';
import 'package:ffmpeg_flutter_test/BookManagement/json/Yahooapis.dart';
// import 'package:yahoo_api_flutter/lib/json/BookStruct.dart';

class EditBookModel extends ChangeNotifier {
  final BookDetailStruct bookdetail;

  EditBookModel(this.bookdetail) {
    authorController.text = bookdetail.author;
    titleController.text = bookdetail.title;
    authorKanaController.text = bookdetail.authorKana;
    titleKanaController.text = bookdetail.titleKana;
    isbnController.text = bookdetail.isbn;
    salesDateController.text = bookdetail.salesDate;
  }

  /// 初期値
  int count = 0;
  String address = "アドレス";
  String res = "";
  String strtmp = "";
  BookStruct? books;

  int editBookId = 0;
  final authorController = TextEditingController();
  final titleController = TextEditingController();
  final authorKanaController = TextEditingController();
  final titleKanaController = TextEditingController();
  final isbnController = TextEditingController();
  final salesDateController = TextEditingController();

  int? bookId;
  String? title;
  String? titleKana;
  String? author;
  String? authorKana;
  String? isbn;
  String? salesDate;

  /// count の更新メソッド
  Future<void> increment() async {
    count++;
    while (true) {
      await Future.delayed(Duration(seconds: 3));
      notifyListeners();
    }
  }

  void setTitle(String title) {
    this.title = title;
    notifyListeners();
  }

  void setAuthor(String author) {
    this.author = author;
    notifyListeners();
  }

  String apiURL = "http://localhost:8000/book/book/";

  void editBookDio() async {
    //dioを使ったapi操作 responseはデコードされたmapを返す
    //
    this.bookId = bookdetail.bookId;
    this.author = authorController.text;
    this.title = titleController.text;
    this.authorKana = authorKanaController.text;
    this.titleKana = titleKanaController.text;
    this.isbn = isbnController.text;
    this.salesDate = salesDateController.text;

    var response = await Dio()
        .put(
      'http://localhost:8000/book/book/${bookId}/',
      data: new FormData.fromMap({
        'title': title,
        'title_kana': titleKana,
        'author': author,
        'author_kana': authorKana,
        'isbn': isbn,
        'sales_date': salesDate,
      }),
    )
        .then((response) {
      print(response.data);

      return response.data;
    }).catchError((err) {
      print(err);
      return null;
    });
  }
}
