class BookDetailStruct {
  late int bookId;
  late String title;
  late String titleKana;
  late String author;
  late String authorKana;
  late String isbn;
  late String salesDate;

  BookDetailStruct(
      {required this.bookId,
      required this.title,
      required this.titleKana,
      required this.author,
      required this.authorKana,
      required this.isbn,
      required this.salesDate});

  BookDetailStruct.fromJson(Map<String, dynamic> json) {
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
