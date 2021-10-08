import 'dart:io';

import 'package:ffmpeg_flutter_test/avatar.dart';
import 'package:ffmpeg_flutter_test/avatar_save_service.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AvatarDetailHomeWidget extends StatefulWidget {
  AvatarDetailHomeWidget({Key? key, required Avatar avatar}) {
    this.avatar = avatar;
  }

  late Avatar avatar;

  @override
  AvatarDetailHomeWidgetState createState() =>
      AvatarDetailHomeWidgetState(avatar);
}

class AvatarDetailHomeWidgetState extends State<AvatarDetailHomeWidget> {
  AvatarDetailHomeWidgetState(Avatar avatar) {
    this.avatar = avatar;
  }
  late Avatar avatar;
  final TextEditingController avatarName = TextEditingController();

  String? localFilePath;

  @override
  initState() {
    super.initState();
    getlocalFilePath();
  }

  Future<void> getlocalFilePath() async {
    localFilePath = await localPath;
    setState(() {});
  }

  Future<void> _updateData() async {
    /// データベースのパスを取得
    final String name = avatarName.text;
    final String dbFilePath = await getDatabasesPath();
    final String path = join(dbFilePath, Constants().dbName);

    /// SQL文
    final String query =
        'UPDATE ${Constants().tableName} SET name = "$name" WHERE id = ${avatar.id}';

    final Database db = await openDatabase(path, version: Constants().dbVersion,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS ${Constants().tableName} (id INTEGER PRIMARY KEY, activeImagePath TEXT, stopImagePath TEXT, name TEXT)');
    });

    await db.transaction((Transaction txn) async {
      final int id = await txn.rawInsert(query);
      debugPrint('更新成功 id: $id');
    });

    setState(() {});
  }

  Future<void> _deleteData(int id) async {
    final String dbFilePath = await getDatabasesPath();
    final String path = join(dbFilePath, Constants().dbName);

    final Database db = await openDatabase(path, version: Constants().dbVersion,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS ${Constants().tableName} (id INTEGER PRIMARY KEY, activeImagePath TEXT, stopImagePath TEXT, name TEXT)');
    });

    await db.delete(
      '${Constants().tableName}',
      where: "id = ?",
      whereArgs: [id],
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        if (localFilePath == null)
          Container()
        else
          Image.memory(
            File('${localFilePath}/${avatar.activeImagePath}')
                .readAsBytesSync(),
            height: 100.0,
            width: 100.0,
          ),
        Text('${avatar.name}'),
        TextField(
          controller: avatarName,
        ),
        ElevatedButton(
          onPressed: () async {
            await _updateData();
            Navigator.pop(context, true);
          },
          child: Text('更新'),
        ),
        ElevatedButton(
          onPressed: () async {
            await _deleteData(avatar.id);
            Navigator.pop(context, true);
          },
          child: Text('削除'),
        )
      ],
    ));
  }
}
