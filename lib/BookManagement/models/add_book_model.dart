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

class AddBookModel extends ChangeNotifier {
  /// 初期値

  BookStruct? books;

  final authorController = TextEditingController();
  final titleController = TextEditingController();
  final authorKanaController = TextEditingController();
  final titleKanaController = TextEditingController();
  final isbnController = TextEditingController();
  final salesDateController = TextEditingController();

  String? title;
  String? titleKana;
  String? author;
  String? authorKana;
  String? isbn;
  String? salesDate;

  /// count の更新メソッド
  Future<void> increment() async {
    //getZipcode();
    // getYahooHttp();
    // deleteBookDio(46);
    //editBookDio(47);
    //nogetBookListDio();

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

  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  String apiURL = "http://localhost:8000/book/book/";

  var addbook = {
    'title': "入力する値",
    'title_kana': "titleKana",
    'author': "author",
    'author_kana': "authorKana",
    'isbn': "isbn",
    'sales_date': "salesDate",
  };

  Future addBookDio() async {
    //dioを使ったapi操作 responseはデコードされたmapを返す．
    if (title == null || title == "") {
      throw '本のタイトルが空です';
    }
    if (author == null || author == "") {
      throw '著者が入力されていません';
    }
    if (titleKana == null || titleKana == "") {
      throw '本のタイトルカタカナが空です';
    }
    if (authorKana == null || authorKana == "") {
      throw '著者カタカナが入力されていません';
    }
    if (isbn == null || isbn == "") {
      throw 'isbnコードが空です';
    }
    if (salesDate == null || salesDate == "") {
      throw '発売日が入力されていません';
    }
    var response = await Dio()
        .post(
      'http://localhost:8000/book/book/',
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
