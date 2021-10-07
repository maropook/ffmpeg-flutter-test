import 'package:flutter/cupertino.dart';
import 'package:ffmpeg_flutter_test/Avatar/json/book_detail_struct.dart';
import 'package:ffmpeg_flutter_test/Avatar/json/book_struct.dart';
import 'package:ffmpeg_flutter_test/Avatar/models/add_book_model.dart';
import 'package:ffmpeg_flutter_test/Avatar/models/logic.dart';
import 'package:ffmpeg_flutter_test/Avatar/view/add_book_page.dart';
import 'package:ffmpeg_flutter_test/Avatar/view/edit_book_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ApiTop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookModel>(
        create: (context) => BookModel()..getBookList(),
        child: ChangeNotifierProvider<AddBookModel>(
            create: (_) => AddBookModel(),
            child: Consumer<BookModel>(
                builder: (context, model, child) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Avatar管理'),
                    ),
                    body: Container(
                      child: const BookLists(),
                    ),
                    floatingActionButton:
                        Consumer<BookModel>(builder: (context, model, child) {
                      return FloatingActionButton(
                        onPressed: () async {
                          final bool? added = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddBookPage(),
                                fullscreenDialog: true,
                              ));

                          if (added != null && added) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text("本を追加しました")));
                          }
                          model.getBookListDio();
                        },
                        child: const Icon(Icons.add),
                      );
                    })))));
  }
}

class BookLists extends StatelessWidget {
  const BookLists({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BookModel>(builder: (context, model, child) {
      final BookStruct? bookse = model.books;

      if (bookse == null) {
        return const CircularProgressIndicator();
      }

      return SizedBox(
        width: double.infinity,
        child: ListView.builder(
          itemCount: bookse.count,
          itemBuilder: (context, index) {
            return Slidable(
              actionPane: const SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              child: Container(
                color: Colors.white,
                child: ListTile(
                  title: Text(bookse.results[index].title),
                  subtitle: Text(bookse.results[index].author),
                ),
              ),
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: '編集',
                  color: Colors.black45,
                  icon: Icons.more_horiz,
                  onTap: () async {
                    final String? title = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditBookPage(BookDetailStruct(
                            bookId: bookse.results[index].bookId,
                            title: bookse.results[index].title,
                            titleKana: bookse.results[index].titleKana,
                            author: bookse.results[index].author,
                            authorKana: bookse.results[index].authorKana,
                            isbn: bookse.results[index].isbn,
                            salesDate: bookse.results[index].salesDate)),
                      ),
                    );
                    model.getBookListDio();
                  },
                ),
                IconSlideAction(
                    caption: '削除',
                    color: Colors.red,
                    icon: Icons.delete,
                    onTap: () async {
                      await showConfirmDialog(
                        context,
                        BookDetailStruct(
                            bookId: bookse.results[index].bookId,
                            title: bookse.results[index].title,
                            titleKana: bookse.results[index].titleKana,
                            author: bookse.results[index].author,
                            authorKana: bookse.results[index].authorKana,
                            isbn: bookse.results[index].isbn,
                            salesDate: bookse.results[index].salesDate),
                        model,
                      );
                    }),
              ],
            );
          },
        ),
      );
    });
  }

  Future showConfirmDialog(
    BuildContext context,
    BookDetailStruct book,
    BookModel model,
  ) {
    return showDialog<dynamic>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text("削除の確認"),
          content: Text("[${book.title}]を削除しますか"),
          actions: [
            TextButton(
              child: const Text("いいえ"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("はい"),
              onPressed: () {
                model.deleteBookDio(book.bookId);
                Navigator.pop(context);
                model.getBookListDio();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    content: Text("${book.title}を削除しました")));
              },
            ),
          ],
        );
      },
    );
  }
}
