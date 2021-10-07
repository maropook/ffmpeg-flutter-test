import 'dart:async';
import 'package:dio/dio.dart';
import 'package:ffmpeg_flutter_test/Avatar/json/book_detail_struct.dart';
import 'package:flutter/material.dart';

class EditBookModel extends ChangeNotifier {
  EditBookModel(this.bookdetail) {
    authorController.text = bookdetail.author;
    titleController.text = bookdetail.title;
    authorKanaController.text = bookdetail.authorKana;
    titleKanaController.text = bookdetail.titleKana;
    isbnController.text = bookdetail.isbn;
    salesDateController.text = bookdetail.salesDate;
  }

  final BookDetailStruct bookdetail;

  final TextEditingController authorController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorKanaController = TextEditingController();
  final TextEditingController titleKanaController = TextEditingController();
  final TextEditingController isbnController = TextEditingController();
  final TextEditingController salesDateController = TextEditingController();

  int? bookId;
  String? title;
  String? titleKana;
  String? author;
  String? authorKana;
  String? isbn;
  String? salesDate;

  /// count の更新メソッド
  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void setTitle(String title) {
    this.title = title;
    notifyListeners();
  }

  void setAuthor(String author) {
    this.author = author;
    notifyListeners();
  }

  String apiURL = 'http://localhost:8000/book/book/';

  Future<void> editBookDio() async {
    //dioを使ったapi操作 responseはデコードされたmapを返す
    bookId = bookdetail.bookId;
    author = authorController.text;
    title = titleController.text;
    authorKana = authorKanaController.text;
    titleKana = titleKanaController.text;
    isbn = isbnController.text;
    salesDate = salesDateController.text;

    final Map<String, dynamic>? response = await Dio()
        .put<Map<String, dynamic>>(
      'http://localhost:8000/book/book/${bookId}/',
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
