import 'package:flutter/cupertino.dart';
import 'package:ffmpeg_flutter_test/Avatar/json/BookDetailStruct.dart';
import 'package:ffmpeg_flutter_test/Avatar/json/BookStruct.dart';
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
    return ChangeNotifierProvider<CountModel>(
        create: (context) => CountModel()..increment(),
        child: ChangeNotifierProvider<AddBookModel>(
            create: (_) => AddBookModel(),
            child: Consumer<CountModel>(
                builder: (context, model, child) => Scaffold(
                    appBar: AppBar(
                      title: Text('書籍管理システム'),
                    ),
                    body: Container(
                      child: BookLists(),
                    ),
                    floatingActionButton:
                        Consumer<CountModel>(builder: (context, model, child) {
                      return FloatingActionButton(
                        onPressed: () async {
                          final bool? added = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddBookPage(),
                                fullscreenDialog: true,
                              ));

                          if (added != null && added) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.green,
                                content: Text("本を追加しました")));
                          }
                          model.getBookListHttp();
                        },
                        child: Icon(Icons.add),
                      );
                    })))));
  }
}

class CountText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      '${Provider.of<CountModel>(context).count}',
      style: Theme.of(context).textTheme.headline4,
    );
  }
}

class PostCode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      /// context からModelの値が使える
      '${Provider.of<CountModel>(context).address}',
      style: Theme.of(context).textTheme.headline4,
    );
  }
}

class PostcodeAddress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CountModel>(builder: (context, model, child) {
      return Text(
        /// context からModelの値が使える
        '${model.strtmp}',
        style: Theme.of(context).textTheme.headline4,
      );
    });
  }
}

class BookLists extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CountModel>(builder: (context, model, child) {
      final BookStruct? bookse = model.books;

      if (bookse == null) {
        return CircularProgressIndicator();
      }

      return Container(
        width: double.infinity,
        child: ListView.builder(
          itemCount: bookse.count,
          itemBuilder: (context, index) {
            return Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              child: Container(
                color: Colors.white,
                child: ListTile(
                  // leading: CircleAvatar(
                  //   backgroundColor: Colors.indigoAccent,
                  //   child: Text('dd'),
                  //   foregroundColor: Colors.white,
                  // ),
                  title: Text('${bookse.results[index].title}'),
                  subtitle: Text('${bookse.results[index].author}'),
                ),
              ),
              actions: <Widget>[
                IconSlideAction(
                  caption: 'Archive',
                  color: Colors.blue,
                  icon: Icons.archive,
                  onTap: () => null,
                ),
                IconSlideAction(
                    caption: 'Share',
                    color: Colors.indigo,
                    icon: Icons.share,
                    onTap: () => null),
              ],
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
                    model.getBookListHttp();
                  },
                ),
                IconSlideAction(
                    caption: '削除',
                    color: Colors.red,
                    icon: Icons.delete,
                    // model.deleteBookDio(bookse.results[index].bookId),

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
    CountModel model,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: Text("削除の確認"),
          content: Text("[${book.title}]を削除しますか"),
          actions: [
            TextButton(
              child: Text("いいえ"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("はい"),
              onPressed: () {
                model.deleteBookDio(book.bookId);
                Navigator.pop(context);
                model.getBookListHttp();
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
