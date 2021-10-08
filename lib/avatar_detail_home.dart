import 'dart:io';

import 'package:ffmpeg_flutter_test/avatar.dart';
import 'package:ffmpeg_flutter_test/avatar_save_service.dart';
import 'package:ffmpeg_flutter_test/generate_route.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AvatarDetailHomeWidget extends StatefulWidget {
  AvatarDetailHomeWidget(AvatarDetailHomeArgs args, {Key? key})
      : super(key: key) {
    avatar = args.avatar;
  }

  late final Avatar avatar;

  @override
  AvatarDetailHomeWidgetState createState() => AvatarDetailHomeWidgetState();
}

class AvatarDetailHomeWidgetState extends State<AvatarDetailHomeWidget> {
  AvatarDetailHomeWidgetState();
  late Avatar _avatar;
  final TextEditingController avatarName = TextEditingController();
  String? localFilePath;

  @override
  initState() {
    _avatar = widget.avatar;
    super.initState();
    getlocalFilePath();
  }

  Future<void> getlocalFilePath() async {
    localFilePath = await localPath;
    setState(() {});
  }

  Future<Database> _getDatabase() async {
    final String dbFilePath = await getDatabasesPath();
    final String path = join(dbFilePath, Constants().dbName);
    return openDatabase(path,
        version: Constants().dbVersion,
        onCreate: (Database db, int version) async {});
  }

  Future<void> _updateData() async {
    final String name = avatarName.text;
    final String query =
        'UPDATE ${Constants().tableName} SET name = "$name" WHERE id = ${_avatar.id}';
    final Database db = await _getDatabase();

    await db.transaction((Transaction txn) async {
      final int id = await txn.rawInsert(query);
      debugPrint('更新成功 id: $id');
    });
  }

  Future<void> _deleteData(int id) async {
    final Database db = await _getDatabase();

    await db.delete(
      Constants().tableName,
      where: 'id = ?',
      whereArgs: <int>[id],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 13,
          child: const Text(
            'アバターを選択',
            style: TextStyle(fontSize: 30),
          ),
        ),
        if (localFilePath == null)
          Container()
        else
          Image.memory(
            File('$localFilePath/${_avatar.activeImagePath}').readAsBytesSync(),
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.width,
          ),
        Text(_avatar.name),
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
            await _deleteData(_avatar.id);
            Navigator.pop(context, true);
          },
          child: Text('削除'),
        )
      ],
    ));
  }
}
