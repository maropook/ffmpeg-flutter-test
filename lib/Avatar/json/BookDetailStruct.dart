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
    bookId = json['book_id'];
    title = json['title'];
    titleKana = json['title_kana'];
    author = json['author'];
    authorKana = json['author_kana'];
    isbn = json['isbn'];
    salesDate = json['sales_date'];
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
