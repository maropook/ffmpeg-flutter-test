import 'package:ffmpeg_flutter_test/initial/saved_list.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = TextStyle(fontSize: 18.0);

  void _pushSavedList() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SavedList(_saved),
        ));
  }

  void _pushSaved() {
    // Navigatorスタックに新しいROUteをプッシュする
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      // MaterialPageRouteからRouteを作成する,builderプロパティで作る
      // _saved変数の中身それぞれでListTileを生成する
      final tiles = _saved.map(
        (WordPair pair) {
          return ListTile(
            title: Text(
              pair.asPascalCase,
              style: _biggerFont,
            ),
          );
        },
      );
      //上で生成したtilesにListTile .divideTilesを利用して，
      //水平方向の間を追加し，一覧かした状態でdivided定数に代入
      final divided = ListTile.divideTiles(
        tiles: tiles,
        context: context,
      ).toList();

      return Scaffold(
        appBar: AppBar(
          title: Text('saved suggestions'),
        ),
        body: ListView(children: divided),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('増える'),
        // 一覧アイコンを追加する．押したらお気に入りページへ
        actions: [
          IconButton(onPressed: _pushSaved, icon: Icon(Icons.list)),
          IconButton(
              onPressed: _pushSavedList, icon: Icon(Icons.downhill_skiing)),
        ],
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemBuilder: (context, i) {
            if (i.isOdd) return Divider();
            final index = i ~/ 2;
            if (index >= _suggestions.length) {
              _suggestions.addAll(generateWordPairs().take(10));
            }
            final alreadySaved = _saved.contains(_suggestions[index]);

            return ListTile(
                title: Text(
                  _suggestions[index].asPascalCase,
                  style: _biggerFont,
                ),
                trailing: Icon(
                  alreadySaved ? Icons.favorite : Icons.favorite_border,
                  color: alreadySaved ? Colors.red : null,
                ),
                onTap: () {
                  setState(() {
                    if (alreadySaved) {
                      _saved.remove(_suggestions[index]);
                    } else {
                      _saved.add(_suggestions[index]);
                    }
                  });
                });
          }),
    );
  }
}
