import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:ffmpeg_flutter_test/Avatar/json/BookDetailStruct.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

import 'package:ffmpeg_flutter_test/Avatar/json/BookStruct.dart';
// import 'package:yahoo_api_flutter/lib/json/BookStruct.dart';

class CountModel extends ChangeNotifier {
  //final BookDetailStruct bookdetail;

  // CountModel(this.bookdetail) {
  //   authorController.text = bookdetail.author;
  //   titleController.text = bookdetail.title;
  //   authorKanaController.text = bookdetail.authorKana;
  //   titleKanaController.text = bookdetail.titleKana;
  //   isbnController.text = bookdetail.isbn;
  //   salesDateController.text = bookdetail.salesDate;
  // }

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
  Future<void> getBookList() async {
    getBookListDio();
    getBookListHttp();
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      notifyListeners();
    }
  }

  String apiURL = "http://localhost:8000/book/book/";

  void deleteBookDio(id) async {
    //dioを使ったapi操作 responseはデコードされたmapを返す．
    var response = await Dio()
        .delete(
      'http://localhost:8000/book/book/${id}/',
    )
        .then((response) {
      print(response.data);
      getBookList();
      return response.data;
    }).catchError((err) {
      print(err);
      return null;
    });
  }

  void getBookListHttp() async {
    var uri = Uri.parse('http://localhost:8000/book/book/');
    http.Response res = await http.get(uri);
    if (res.statusCode == 200) {
      String data = Utf8Decoder(allowMalformed: true).convert(res.bodyBytes);
      Map<String, dynamic> map = jsonDecode(data);
      var book = BookStruct.fromJson(map);
      print(book.count);

      books = BookStruct.fromJson(map);

      for (var i = 0; i < book.count; i++) {
        print(book.results[i].title);
      }

      while (true) {
        await Future.delayed(Duration(seconds: 3));
        notifyListeners();
      }
    } else {
      throw Exception('Failed to load post');
    }
  }

  void getBookListDio() async {
    //dioを使ったapi操作 responseはデコードされたmapを返す．
    try {
      var response = await Dio().get('http://localhost:8000/book/book/');
      var book = BookStruct.fromJson(response.data);

      books = BookStruct.fromJson(response.data);

      print(book.count);
      for (var i = 0; i < book.count; i++) {
        //print(book.results[i].title);
        // print(book.results[i]);
      }

      while (true) {
        await Future.delayed(Duration(seconds: 3));
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  void nogetBookListDio() async {
    //dioを使ったapi操作 responseはデコードされたmapを返す．
    try {
      var response = await Dio().get('http://localhost:8000/book/book/');
      final Map<String, dynamic> map =
          new Map<String, dynamic>.from(response.data);

      String nobook = map['results'][0]['title'];
      for (var i = 0; i < map.length; i++) {
        print(map['results'][i]['title']);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> requestAddCoder(String address) async {
    List<Location> locations = await locationFromAddress(address);
    print(locations.first.latitude);
    print(locations.first.longitude); //緯度と経度
  }
}
