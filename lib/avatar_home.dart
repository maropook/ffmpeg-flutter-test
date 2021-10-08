import 'dart:async';
import 'dart:io';
import 'package:ffmpeg_flutter_test/avatar.dart';
import 'package:ffmpeg_flutter_test/avatar_save_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AvatarDetailHomeWidgetArgs {
  AvatarDetailHomeWidgetArgs(this.avatar);

  final Avatar avatar;
}

class AvatarImportHomeWidget extends StatefulWidget {
  const AvatarImportHomeWidget({Key? key}) : super(key: key);

  @override
  AvatarImportHomeWidgetState createState() => AvatarImportHomeWidgetState();
}

class AvatarImportHomeWidgetState extends State<AvatarImportHomeWidget> {
  final TextEditingController avatarName = TextEditingController();
  File? stopImageFile;
  File? activeImageFile;
  final ImagePicker picker = ImagePicker();

  String activeTime = '';
  String stopTime = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            if (activeImageFile == null)
              Container()
            else
              Image.memory(
                activeImageFile!.readAsBytesSync(),
                height: 100.0,
                width: 100.0,
              ),
            if (stopImageFile == null)
              Container()
            else
              Image.memory(
                stopImageFile!.readAsBytesSync(),
                height: 100.0,
                width: 100.0,
              ),
            TextField(
              controller: avatarName,
            ),
            ElevatedButton(
                onPressed: () {
                  _getAndSaveActiveImageFromDevice();
                },
                child: const Text('active画像を選択')),
            ElevatedButton(
                onPressed: () {
                  _getAndSaveStopImageFromDevice();
                },
                child: const Text('stop画像を選択')),
            ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context, true);
                },
                child: const Text('avatar一覧へ')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          if (dataIsEmpty()) {
            showDialog<dynamic>(
                context: context,
                builder: (BuildContext context) => const AlertDialog(
                      title: Text('値を入力してください'),
                      content: Text('データベースに保存できません'),
                    ));
            return;
          }
          _saveData();
          showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) => const AlertDialog(
                    title: Text('保存しました'),
                    content: Text('保存できました'),
                  ));
        },
      ),
    );
  }

  Future<void> saveLocalActiveImage(File image) async {
    final String path = await localPath;
    activeTime = '${now()}active.png';
    final String activeImagePath = '$path/$activeTime';
    activeImageFile = File(activeImagePath);
    await activeImageFile!.writeAsBytes(await image.readAsBytes());
  }

  Future<void> saveLocalStopImage(File image) async {
    final String path = await localPath;
    stopTime = '${now()}stop.png';
    final String stopImagePath = '$path/$stopTime';
    stopImageFile = File(stopImagePath);
    await stopImageFile!.writeAsBytes(await image.readAsBytes());
  }

  Future<void> _getAndSaveActiveImageFromDevice() async {
    final XFile? imageFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (imageFile == null) {
      return;
    }
    await saveLocalActiveImage(File(imageFile.path)); //追加

    setState(() {});
  }

  Future<void> _getAndSaveStopImageFromDevice() async {
    final XFile? imageFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (imageFile == null) {
      return;
    }
    await saveLocalStopImage(File(imageFile.path)); //追加
    setState(() {});
  }

  bool dataIsEmpty() {
    if (activeTime == '' || avatarName.text == '' || stopTime == '') {
      debugPrint('値を入力してください');
      return true;
    }
    return false;
  }

  Future<void> _saveData() async {
    /// データベースのパスを取得
    final String name = avatarName.text;
    final String dbFilePath = await getDatabasesPath();
    final String path = join(dbFilePath, Constants().dbName);

    /// SQL文
    final String query =
        'INSERT INTO ${Constants().tableName}(activeImagePath, stopImagePath, name) VALUES("$activeTime", "$stopTime", "$name")';

    final Database db = await openDatabase(path, version: Constants().dbVersion,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS ${Constants().tableName} (id INTEGER PRIMARY KEY, activeImagePath TEXT, stopImagePath TEXT, name TEXT)');
    });

    await db.transaction((Transaction txn) async {
      final int id = await txn.rawInsert(query);
      debugPrint('保存成功 id: $id');
    });

    setState(() {
      avatarName.text = '';
      activeTime = '';
      stopTime = '';
      activeImageFile = null;
      stopImageFile = null;
    });
  }
}

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
                      File('$localFilePath/${avatarList[index].stopImagePath}')
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
    /// データベースのパスを取得
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
