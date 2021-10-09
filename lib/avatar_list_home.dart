import 'dart:async';
import 'dart:io';
import 'dart:ui';
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

    List<Map<String, Object?>> result =
        await db.rawQuery('SELECT * FROM ${Constants().tableName}');

    avatarList.clear();

    if (result.isEmpty) {
      final String query =
          'INSERT INTO ${Constants().tableName}(activeImagePath, stopImagePath, name) VALUES("${initialAvatar.activeImagePath}", "${initialAvatar.stopImagePath}", "${initialAvatar.name}")';

      await db.transaction((Transaction txn) async {
        int id = await txn.rawInsert(query);
        debugPrint('初期データ保存成功 id: $id');
      });
      result = await db.rawQuery('SELECT * FROM ${Constants().tableName}');
      getItems();
    }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
              delegate: SliverChildListDelegate(<Widget>[
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: const Padding(
                padding: EdgeInsets.all(13.0),
                child: Text(
                  'アバターを選ぶ',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ),
            Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                height: 10)
          ])),
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200.0,
              mainAxisExtent: 187,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if (index == avatarList.length) {
                  return InkWell(
                      onTap: () async {
                        showGeneralDialog(
                          barrierColor: Colors.black.withOpacity(0.3),
                          context: context,
                          pageBuilder: (context, animation1, animation2) {
                            return Material(
                              color: Colors.black.withOpacity(0.3),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Image.asset(
                                      'assets/make.png',
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.7,
                                    ),
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('または',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 30)),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            await Navigator.of(context)
                                                .pushNamed('/avatar_import');
                                            getItems();
                                          },
                                          child: Image.asset(
                                            'assets/import.png',
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.30,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.30,
                                          ),
                                        ),
                                      ]),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Icon(Icons.add,
                                  color: Colors.black, size: 40))));
                }
                return InkWell(
                    onTap: () async {
                      selectedAvatar = avatarList[index];
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Stack(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Image.memory(
                              File('$localFilePath/${avatarList[index].activeImagePath}')
                                  .readAsBytesSync(),
                            ),
                          ),
                          if (selectedAvatar.id == avatarList[index].id)
                            const Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(right: 10.0, top: 10),
                                  child: Icon(Icons.star,
                                      color: Colors.yellow, size: 30),
                                ))
                          else
                            Container(),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: InkWell(
                              onTap: () async {
                                final AvatarDetailHomeArgs args =
                                    AvatarDetailHomeArgs(avatarList[index]);
                                await Navigator.of(context).pushNamed(
                                    '/avatar_detail',
                                    arguments: args);
                                await getItems();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 15, right: 5.0),
                                child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: Image.asset(
                                      'assets/avatar_edit.png',
                                      fit: BoxFit.contain,
                                    )),
                              ),
                            ),
                          )
                        ],
                      ),
                    ));
              },
              childCount: avatarList.length + 1,
            ),
          ),
        ],
      ),
    );
  }
}
