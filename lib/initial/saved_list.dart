import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class SavedList extends StatelessWidget {
  SavedList(this.saved);
  Set<WordPair> saved;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('7テキスト'),
      ),
      body: SavedLists(saved),
    );
  }
}

class SavedLists extends StatefulWidget {
  SavedLists(this.saved);

  Set<WordPair> saved;

  @override
  _SavedListState createState() => _SavedListState(saved);
}

class _SavedListState extends State<SavedLists> {
  _SavedListState(this.saved);

  Set<WordPair> saved;
  @override
  Widget build(BuildContext context) {
    final tiles = saved.map(
      (WordPair pair) {
        return ListTile(
          title: Text(
            pair.asPascalCase,
            style: TextStyle(fontSize: 18.0),
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

    return ListView(children: divided);
  }
}
