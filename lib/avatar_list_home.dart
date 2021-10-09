import 'dart:async';
import 'dart:io';
import 'package:ffmpeg_flutter_test/avatar.dart';
import 'package:ffmpeg_flutter_test/avatar_save_service.dart';
import 'package:ffmpeg_flutter_test/main.dart';
import 'package:ffmpeg_flutter_test/route_args.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
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

  Future<void> getItems() async {
    localFilePath = await localPath;
    final String dbFilePath = await getDatabasesPath();
    final String path = join(dbFilePath, Constants().dbName);
    final Database db = await openDatabase(path, version: Constants().dbVersion,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS ${Constants().tableName} (id INTEGER PRIMARY KEY, activeImagePath TEXT, stopImagePath TEXT, name TEXT)');
    });

    final List<Map<String, Object?>> result =
        await db.rawQuery('SELECT * FROM ${Constants().tableName}');
    avatarList.clear();
    for (final Map<String, Object?> item in result) {
      debugPrint('$item');
      final Avatar _avatar = Avatar(
          activeImagePath: item['activeImagePath']! as String,
          id: item['id']! as int,
          stopImagePath: item['stopImagePath']! as String,
          name: item['name']! as String);
      avatarList.add(_avatar);
    }
    setState(() {});
  }

  Avatar selectedAvatar = initialAvatar;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
              delegate: SliverChildListDelegate(<Widget>[
            Column(
              children: <Widget>[
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('戻る')),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Text('${initialAvatar.name}',
                      textAlign: TextAlign.center),
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
                        await Navigator.of(context).pushNamed('/avatar_import');

                        getItems();
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Image.asset(
                            'assets/import_rect.png',
                            fit: BoxFit.contain,
                          )));
                }
                return InkWell(
                  onTap: () async {
                    final AvatarDetailHomeArgs args =
                        AvatarDetailHomeArgs(avatarList[index]);
                    initialAvatar = await Navigator.of(context)
                        .pushNamed('/avatar_detail', arguments: args) as Avatar;

                    await getItems();
                    debugPrint('${initialAvatar.name}!!');
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
