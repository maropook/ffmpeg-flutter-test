import 'package:flutter/material.dart';

class BookStruct {
  late int count;
  Null next;
  Null previous;
  late List<Results> results;

  BookStruct(
      {required this.count,
      required this.next,
      required this.previous,
      required this.results});

  BookStruct.fromJson(Map<String, dynamic> json) {
    count = json['count'] as int;
    next = json['next'] as Null;
    previous = json['previous'] as Null;
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((dynamic v) {
        results.add(new Results.fromJson(
          v as Map<String, dynamic>,
        ));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    data['results'] = this.results.map((v) => v.toJson()).toList();
    return data;
  }
}

class Results {
  late int bookId;
  late String title;
  late String titleKana;
  late String author;
  late String authorKana;
  late String isbn;
  late String salesDate;

  Results(
      {required this.bookId,
      required this.title,
      required this.titleKana,
      required this.author,
      required this.authorKana,
      required this.isbn,
      required this.salesDate});

  Results.fromJson(Map<String, dynamic> json) {
    bookId = json['book_id'] as int;
    title = json['title'] as String;
    titleKana = json['title_kana'] as String;
    author = json['author'] as String;
    authorKana = json['author_kana'] as String;
    isbn = json['isbn'] as String;
    salesDate = json['sales_date'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['book_id'] = this.bookId;
    data['title'] = this.title;
    data['title_kana'] = this.titleKana;
    data['author'] = this.author;
    data['author_kana'] = this.authorKana;
    data['isbn'] = this.isbn;
    data['sales_date'] = this.salesDate;
    return data;
  }
}
