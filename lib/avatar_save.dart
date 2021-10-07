import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class Constants {
  final String dbName = 'sqflite.db';
  final int dbVersion = 1;
  final String tableName = 'avatar';
}

class AvatarSave extends StatelessWidget {
  const AvatarSave({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BottomNavigationBar App',
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => const AvatarFirst(),
        '/list': (BuildContext context) => const AvatarSecond(),
      },
    );
  }
}

class AvatarFirst extends StatefulWidget {
  const AvatarFirst({Key? key}) : super(key: key);

  @override
  FirstScreenState createState() => FirstScreenState();
}

class FirstScreenState extends State<AvatarFirst> {
  final TextEditingController activeImgPath = TextEditingController();
  final TextEditingController stopImgPath = TextEditingController();
  final TextEditingController avatarName = TextEditingController();

  final TextStyle style1 = const TextStyle(fontSize: 30.0, color: Colors.black);
  final TextStyle style2 = const TextStyle(fontSize: 30.0, color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            if (stopImageFile == null)
              Container()
            else
              Image.memory(
                //変更
                stopImageFile!.readAsBytesSync(), //変更
                height: 100.0,
                width: 100.0,
              ),
            if (activeImageFile == null)
              Container()
            else
              Image.memory(
                //変更
                activeImageFile!.readAsBytesSync(),
                height: 100.0,
                width: 100.0,
              ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '画像のパス',
                style: style2,
              ),
            ),
            TextField(
              controller: activeImgPath,
              style: style1,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '画像のパス2',
                style: style2,
              ),
            ),
            TextField(
              controller: stopImgPath,
              style: style1,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '名前',
                style: style2,
              ),
            ),
            TextField(
              controller: avatarName,
              style: style1,
            ),
            ElevatedButton(
                onPressed: () {
                  if (avatarName.text == '') {
                    return;
                  }
                  _getAndSaveActiveImageFromDevice();
                },
                child: const Text('active画像を選択')),
            ElevatedButton(
                onPressed: () {
                  if (avatarName.text == '') {
                    return;
                  }
                  _getAndSaveStopImageFromDevice();
                },
                child: const Text('stop画像を選択')),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: '追加',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(label: '一覧', icon: Icon(Icons.list)),
        ],
        onTap: (int index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/list');
          }
        },
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
                    content: Text('データベースに保存できました'),
                  ));
        },
      ),
    );
  }

  File? stopImageFile;
  File? activeImageFile;

  static Future<String> get localPath async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  String now() {
    final DateTime now = DateTime.now();
    return '${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}.${now.millisecond}';
  }

  String pass = 'aa';
  // 引数にはカメラ撮影時にreturnされるFileオブジェクトを持たせる。
  Future<void> saveLocalActiveImage(File image) async {
    final String path = await localPath;
    final String activeImagePath = '$path/${now()}active.png';
    activeImageFile = File(activeImagePath);
    await activeImageFile!.writeAsBytes(await image.readAsBytes());
    activeImgPath.text = activeImagePath;
    setState(() {});
  }

  Future<void> saveLocalStopImage(File image) async {
    final String path = await localPath;
    final String stopImagePath = '$path/${now()}stop.png';
    stopImageFile = File(stopImagePath);
    await stopImageFile!.writeAsBytes(await image.readAsBytes());
    stopImgPath.text = stopImagePath;
    setState(() {});
  }

  static Future<File> loadLocalImage() async {
    final String path = await localPath;
    final String imagePath = '$path/image.png';
    return File(imagePath);
  }

  final ImagePicker picker = ImagePicker();
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
    if (activeImgPath.text == '' ||
        avatarName.text == '' ||
        stopImgPath.text == '') {
      debugPrint('値を入力してください');

      return true;
    }
    return false;
  }

  /// データを保存する
  Future<void> _saveData() async {
    /// データベースのパスを取得
    final String dbFilePath = await getDatabasesPath();
    final String path = join(dbFilePath, Constants().dbName);

    /// 保存するデータの用意
    final String activeImagePath = activeImgPath.text;
    final String email = stopImgPath.text;
    final String phone = avatarName.text;

    /// SQL文
    final String query =
        'INSERT INTO ${Constants().tableName}(activeImagePath, stopImagePath, name) VALUES("$activeImagePath", "$email", "$phone")';

    final Database db = await openDatabase(path, version: Constants().dbVersion,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS ${Constants().tableName} (id INTEGER PRIMARY KEY, activeImagePath TEXT, stopImagePath TEXT, name TEXT)');
    });

    /// SQL 実行
    await db.transaction((Transaction txn) async {
      final int id = await txn.rawInsert(query);
      debugPrint('保存成功 id: $id');
    });

    /// ウィジェットの更新
    setState(() {
      activeImgPath.text = '';
      stopImgPath.text = '';
      avatarName.text = '';
    });
  }
}

class AvatarSecond extends StatefulWidget {
  const AvatarSecond({Key? key}) : super(key: key);

  @override
  SecondScreenState createState() => SecondScreenState();
}

class SecondScreenState extends State<AvatarSecond> {
  final List<String> _urls = <String>[];

  @override
  void initState() {
    super.initState();
    getItems();
  }

  File? resultsFile;

  /// 保存したデータを取り出す
  Future<void> getItems() async {
    /// データベースのパスを取得
    final String dbFilePath = await getDatabasesPath();
    final String path = join(dbFilePath, Constants().dbName);

    /// テーブルがなければ作成する
    final Database db = await openDatabase(path, version: Constants().dbVersion,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS ${Constants().tableName} (id INTEGER PRIMARY KEY, activeImagePath TEXT, stopImagePath TEXT, name TEXT)');
    });

    /// SQLの実行
    final List<Map<String, Object?>> result =
        await db.rawQuery('SELECT * FROM ${Constants().tableName}');

    /// データの取り出し
    for (final Map<String, Object?> item in result) {
      final String resultsFilePath = item['activeImagePath']! as String;
      resultsFile = File(resultsFilePath);
      _urls.add(item['activeImagePath']! as String);

      // list.add(ListTile(
      //   title: Text(item['activeImagePath']! as String),
      //   subtitle: Text(item['stopImagePath']!  + item['name'] + '$sum' as String),
      // ));
    }

    /// ウィジェットの更新
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('一覧'),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Image.memory(
                File(_urls[index]).readAsBytesSync(),
                height: 100.0,
                width: 100.0,
              );
            },
            childCount: _urls.length,
          ))
          // ListView(
          //   children: ,
          // ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
              label: '追加', icon: const Icon(Icons.home)),
          const BottomNavigationBarItem(label: '一覧', icon: Icon(Icons.list))
        ],
        onTap: (int index) {
          if (index == 0) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
