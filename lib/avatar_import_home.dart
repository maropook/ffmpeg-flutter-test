import 'dart:io';

import 'package:ffmpeg_flutter_test/avatar_save_service.dart';
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
      resetData();
    });
  }

  void resetData() {
    avatarName.text = '';
    activeTime = '';
    stopTime = '';
    activeImageFile = null;
    stopImageFile = null;
  }
}
