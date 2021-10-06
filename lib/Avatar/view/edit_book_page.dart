import 'package:flutter/material.dart';
import 'package:ffmpeg_flutter_test/Avatar/json/BookDetailStruct.dart';
import 'package:ffmpeg_flutter_test/Avatar/models/edit_book_model.dart';
import 'package:provider/provider.dart';

class EditBookPage extends StatelessWidget {
  final BookDetailStruct book;
  EditBookPage(this.book);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditBookModel>(
      create: (_) => EditBookModel(book),
      child: Scaffold(
        appBar: AppBar(
          title: Text('本一覧'),
        ),
        body: Center(
          child: Consumer<EditBookModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: model.titleController,
                    decoration: InputDecoration(
                      hintText: '本のタイトル',
                    ),
                    onChanged: (text) {
                      model.title = text;
                      model.setTitle(text);
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: model.authorController,
                    decoration: InputDecoration(
                      hintText: '著者',
                    ),
                    onChanged: (text) {
                      model.author = text;
                      model.setAuthor(text);
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: model.salesDateController,
                    decoration: InputDecoration(
                      hintText: '発売日',
                    ),
                    onChanged: (text) {
                      model.title = text;
                      model.setTitle(text);
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: model.titleKanaController,
                    decoration: InputDecoration(
                      hintText: '本のカタカナタイトル',
                    ),
                    onChanged: (text) {
                      model.title = text;
                      model.setTitle(text);
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: model.authorKanaController,
                    decoration: InputDecoration(
                      hintText: '著者カタカナ',
                    ),
                    onChanged: (text) {
                      model.author = text;
                      model.setAuthor(text);
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: model.isbnController,
                    decoration: InputDecoration(
                      hintText: 'isbn本のタイトル',
                    ),
                    onChanged: (text) {
                      model.title = text;
                      model.setTitle(text);
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        model.editBookDio();
                      },
                      child: Text('更新する'))
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
