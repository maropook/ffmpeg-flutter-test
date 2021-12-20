import 'dart:async';
import 'package:dio/dio.dart';
import 'package:ffmpeg_flutter_test/Avatar/json/book_struct.dart';
import 'package:flutter/material.dart';

class AddBookModel extends ChangeNotifier {
  /// 初期値

  BookStruct? books;

  final TextEditingController authorController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorKanaController = TextEditingController();
  final TextEditingController titleKanaController = TextEditingController();
  final TextEditingController isbnController = TextEditingController();
  final TextEditingController salesDateController = TextEditingController();

  String? title;
  String? titleKana;
  String? author;
  String? authorKana;
  String? isbn;
  String? salesDate;

  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> addBookDio() async {
    //dioを使ったapi操作 responseはデコードされたmapを返す．
    if (title == null || title == '') {
      throw '本のタイトルが空です';
    }
    if (author == null || author == '') {
      throw '著者が入力されていません';
    }
    if (titleKana == null || titleKana == '') {
      throw '本のタイトルカタカナが空です';
    }
    if (authorKana == null || authorKana == '') {
      throw '著者カタカナが入力されていません';
    }
    if (isbn == null || isbn == '') {
      throw 'isbnコードが空です';
    }
    if (salesDate == null || salesDate == '') {
      throw '発売日が入力されていません';
    }
    var response = await Dio()
        .post<Map<String, dynamic>>(
      'http://localhost:8000/book/book/',
      data: FormData.fromMap(<String, dynamic>{
        'title': title,
        'title_kana': titleKana,
        'author': author,
        'author_kana': authorKana,
        'isbn': isbn,
        'sales_date': salesDate,
      }),
    )
        .then((Response<Map<String, dynamic>> response) {
      debugPrint('${response.data}');

      return response.data;
    }).catchError((dynamic err) {
      debugPrint('$err');
      return null;
    });
  }
}
