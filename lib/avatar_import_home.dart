import 'dart:io';

import 'package:ffmpeg_flutter_test/avatar.dart';
import 'package:ffmpeg_flutter_test/avatar_save_service.dart';
import 'package:ffmpeg_flutter_test/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AvatarImportHomeWidget extends StatefulWidget {
  const AvatarImportHomeWidget({Key? key}) : super(key: key);

  @override
  AvatarImportHomeWidgetState createState() => AvatarImportHomeWidgetState();
}

class AvatarImportHomeWidgetState extends State<AvatarImportHomeWidget> {
  final TextEditingController avatarName = TextEditingController();
  final ImagePicker picker = ImagePicker();
  String activeImageName = '';
  String stopImageName = '';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            if (activeImageName == '')
              Container()
            else
              Image.memory(
                File('$localFilePath/$activeImageName').readAsBytesSync(),
                height: 100.0,
                width: 100.0,
              ),
            if (stopImageName == '')
              Container()
            else
              Image.memory(
                File('$localFilePath/$stopImageName').readAsBytesSync(),
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
                  Navigator.pop(context);
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
    activeImageName = '${now()}active.png';
    await File('$localFilePath/$activeImageName')
        .writeAsBytes(await image.readAsBytes());
  }

  Future<void> saveLocalStopImage(File image) async {
    stopImageName = '${now()}stop.png';
    await File('$localFilePath/$stopImageName')
        .writeAsBytes(await image.readAsBytes());
  }

  Future<void> _getAndSaveActiveImageFromDevice() async {
    final XFile? imageFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (imageFile == null) {
      return;
    }
    await saveLocalActiveImage(File(imageFile.path));
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
    if (activeImageName == '' || avatarName.text == '' || stopImageName == '') {
      debugPrint('値を入力してください');
      return true;
    }
    return false;
  }

  Future<void> _saveData() async {
    final String name = avatarName.text;
    final String dbFilePath = await getDatabasesPath();
    final String path = join(dbFilePath, Constants().dbName);
    final String query =
        'INSERT INTO ${Constants().tableName}(activeImagePath, stopImagePath, name) VALUES("$activeImageName", "$stopImageName", "$name")';

    final Database db = await openDatabase(path, version: Constants().dbVersion,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS ${Constants().tableName} (id INTEGER PRIMARY KEY, activeImagePath TEXT, stopImagePath TEXT, name TEXT)');
    });

    late int id;

    await db.transaction((Transaction txn) async {
      id = await txn.rawInsert(query);
      debugPrint('保存成功 id: $id');
    });

    List<Object?>? result =
        await db.query('avatar', where: 'id = ?', whereArgs: [id]);

    Map<String, dynamic> item = result[0] as Map<String, dynamic>;

    selectedAvatar = Avatar(
        activeImagePath: item['activeImagePath']! as String,
        id: item['id']! as int,
        stopImagePath: item['stopImagePath']! as String,
        name: item['name']! as String);

    setState(() {
      resetData();
    });
  }

  void resetData() {
    avatarName.text = '';
    activeImageName = '';
    stopImageName = '';
  }
}
