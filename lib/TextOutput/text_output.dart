//非同期処理用ライブラリ
import 'dart:async';
//ファイル出力用ライブラリ
import 'dart:io';

import 'package:flutter/material.dart';
//アプリがファイルを保存可能な場所を取得するライブラリ
import 'package:path_provider/path_provider.dart';

//テキストフィールドの状態を管理するためのクラス
final _textController = TextEditingController();
//出力するテキストファイル名
final _fileName = 'editTextField.txt';

class TextOutput extends StatefulWidget {
  @override
  _TextOutputState createState() => _TextOutputState();
}

//ステートフル
class _TextOutputState extends State<TextOutput> {
  //読み込んだテキストファイルを出力
  String _out = '';

  //ファイルの出力処理
  void outButton() async {
    getFilePath().then((File file) {
      file.writeAsString(_textController.text);
    });
  }

  //ファイルの読み込みと変数への格納処理
  void loadButton() async {
    setState(() {
      load().then((String value) {
        setState(() {
          _out = value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("outputtext"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('テキストを入力してください'),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                autofocus: true,
                controller: _textController,
                decoration: InputDecoration(icon: Icon(Icons.arrow_forward)),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              //ファイル出力用のボタン(ボタン押下でoutButtonメソッドを呼び出し)
              child: ElevatedButton(
                  child: Text('ファイルに出力する'), onPressed: outButton),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              //ファイル読み込み用のボタン(ボタン押下でloadButtonメソッドを呼び出し)
              child: ElevatedButton(
                  child: Text('出力したファイルを読み込む'), onPressed: loadButton),
            ),
            Padding(
                padding: EdgeInsets.all(10.0),
                //読み込みだファイルの内容を表示
                child: Text(
                  '出力したファイルの内容は「' + _out + '」です！',
                )),
          ],
        ),
      ),
    );
  }
}

//テキストファイルを保存するパスを取得する
Future<File> getFilePath() async {
  final directory = await getTemporaryDirectory();
  return File(directory.path + '/' + _fileName);
}

//テキストファイルの読み込み
Future<String> load() async {
  final file = await getFilePath();
  return file.readAsString();
}
