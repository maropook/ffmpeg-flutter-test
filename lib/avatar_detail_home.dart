import 'dart:io';

import 'package:ffmpeg_flutter_test/avatar.dart';
import 'package:ffmpeg_flutter_test/avatar_db_service.dart';
import 'package:ffmpeg_flutter_test/avatar_save_service.dart';
import 'package:ffmpeg_flutter_test/main.dart';
import 'package:ffmpeg_flutter_test/route_args.dart';
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
  late AvatarDBService _avatarDBService;

  @override
  initState() {
    avatarName.text = widget.avatar.name;
    _avatar = widget.avatar;
    _avatarDBService = AvatarDBService();
    super.initState();
    getlocalFilePath();
  }

  Future<void> getlocalFilePath() async {
    localFilePath = await localPath;
    setState(() {});
  }

  Future<void> _updateData() async {
    final String name = avatarName.text;
    final String query =
        'UPDATE ${Constants().tableName} SET name = "$name" WHERE id = ${_avatar.id}';
    final Database db = await _avatarDBService.getDatabase();

    await db.transaction((Transaction txn) async {
      final int id = await txn.rawInsert(query);
      debugPrint('更新成功 id: ${_avatar.id}');
    });

    List<Object?>? result =
        await db.query('avatar', where: 'id = ?', whereArgs: [_avatar.id]);

    Map<String, dynamic> item = result[0] as Map<String, dynamic>;

    _avatar = Avatar(
        activeImagePath: item['activeImagePath']! as String,
        id: item['id']! as int,
        stopImagePath: item['stopImagePath']! as String,
        name: item['name']! as String);

    selectedAvatar = _avatar;

    debugPrint('${result[0]}');
  }

  Future<void> _deleteData(int id) async {
    final Database db = await _avatarDBService.getDatabase();

    await db.delete(
      Constants().tableName,
      where: 'id = ?',
      whereArgs: <int>[id],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height / 13,
            child: Row(
              children: [
                IconButton(
                    onPressed: () async {
                      if (_avatar.id != 0) {
                        await _updateData();
                      }

                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    icon: Icon(Icons.backspace)),
                const Text(
                  'アバターを選択',
                  style: TextStyle(fontSize: 30),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              await _deleteData(_avatar.id);
              Navigator.pop(context);
            },
            icon: Icon(Icons.delete),
          ),
          if (localFilePath == null)
            Container()
          else
            Image.memory(
              File('$localFilePath/${_avatar.activeImagePath}')
                  .readAsBytesSync(),
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
            ),
          TextField(
            controller: avatarName,
          ),
        ],
      ),
    ));
  }
}
