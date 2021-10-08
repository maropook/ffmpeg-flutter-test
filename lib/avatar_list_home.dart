import 'dart:async';
import 'dart:io';
import 'package:ffmpeg_flutter_test/avatar.dart';
import 'package:ffmpeg_flutter_test/avatar_detail_home.dart';
import 'package:ffmpeg_flutter_test/avatar_import_home.dart';
import 'package:ffmpeg_flutter_test/avatar_save_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AvatarListHomeWidget extends StatefulWidget {
  const AvatarListHomeWidget({Key? key}) : super(key: key);

  @override
  AvatarListHomeWidgetState createState() => AvatarListHomeWidgetState();
}

class AvatarListHomeWidgetState extends State<AvatarListHomeWidget> {
  final List<Avatar> avatarList = <Avatar>[];
  late String localFilePath;

  @override
  void initState() {
    super.initState();
    getItems();
  }

  /// 保存したデータを取り出す
  Future<void> getItems() async {
    localFilePath = await localPath;
    final String dbFilePath = await getDatabasesPath();
    final String path = join(dbFilePath, Constants().dbName);

    /// テーブルがなければ作成する
    final Database db = await openDatabase(path, version: Constants().dbVersion,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS ${Constants().tableName} (id INTEGER PRIMARY KEY, activeImagePath TEXT, stopImagePath TEXT, name TEXT)');
    });
    final List<Map<String, Object?>> result =
        await db.rawQuery('SELECT * FROM ${Constants().tableName}');

    /// データの取り出し
    avatarList.clear();
    for (final Map<String, Object?> item in result) {
      debugPrint('${result.length}');
      debugPrint('$item');
      final Avatar _avatar = Avatar(
          activeImagePath: item['activeImagePath']! as String,
          id: item['id']! as int,
          stopImagePath: item['stopImagePath']! as String,
          name: item['name']! as String);
      avatarList.add(_avatar);
    }

    /// ウィジェットの更新
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
              delegate: SliverChildListDelegate([
            Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      getItems();
                    },
                    child: Text('更新')),
                const Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Text('アバターを選ぶ', textAlign: TextAlign.center),
                ),
              ],
            ),
          ])),
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200.0,
              mainAxisExtent: 200,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if (index == avatarList.length) {
                  return InkWell(
                      onTap: () async {
                        await Navigator.push<bool>(
                            context,
                            MaterialPageRoute<bool>(
                                builder: (BuildContext context) =>
                                    AvatarImportHomeWidget()));

                        getItems();
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Image.asset(
                            'assets/import_rect.png',
                            fit: BoxFit.contain,
                            height: 100.0,
                            width: 100.0,
                          )));
                }

                return InkWell(
                  onTap: () async {
                    await Navigator.push<bool>(
                        context,
                        MaterialPageRoute<bool>(
                            builder: (BuildContext context) =>
                                AvatarDetailHomeWidget(
                                    avatar: avatarList[index])));

                    getItems();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image.memory(
                      File('$localFilePath/${avatarList[index].activeImagePath}')
                          .readAsBytesSync(),
                      height: 100.0,
                      width: 100.0,
                    ),
                  ),
                );
              },
              childCount: avatarList.length + 1,
            ),
          ),
        ],
      ),
    );
  }
}
