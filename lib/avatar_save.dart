import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

Future<String> get localPath async {
  final Directory directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

class Constants {
  final String dbName = 'sqflite.db';
  final int dbVersion = 1;
  final String tableName = 'avatar';
}

class Avatar {
  Avatar({
    required int id,
    required String name,
    required String activeImagePath,
    required String stopImagePath,
  }) {
    _id = id;
    _activeImagePath = activeImagePath;
    _stopImagePath = stopImagePath;
    _name = name;
  }
  late int _id;
  late String _name;
  late String _activeImagePath;
  late String _stopImagePath;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': _id,
      'name': _name,
      'activeImagePath': _activeImagePath,
      'stopImagePath': _stopImagePath,
    };
  }
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
  late String localGetPath;
  @override
  void initState() {
    super.initState();
    localPathgetter();
  }

  Future<void> localPathgetter() async {
    localGetPath = await localPath;
  }

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
            if (activeImageFile == null)
              Container()
            else
              Image.memory(
                //変更
                activeImageFile!.readAsBytesSync(),
                height: 100.0,
                width: 100.0,
              ),
            if (stopImageFile == null)
              Container()
            else
              Image.memory(
                //変更
                stopImageFile!.readAsBytesSync(), //変更
                height: 100.0,
                width: 100.0,
              ),

            // Align(
            //   alignment: Alignment.centerLeft,
            //   child: Text(
            //     '画像のパス',
            //     style: style2,
            //   ),
            // ),
            // TextField(
            //   controller: activeImgPath,
            //   style: style1,
            // ),
            // Align(
            //   alignment: Alignment.centerLeft,
            //   child: Text(
            //     '画像のパス2',
            //     style: style2,
            //   ),
            // ),
            // TextField(
            //   controller: stopImgPath,
            //   style: style1,
            // ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '名前',
              ),
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

  String now() {
    final DateTime now = DateTime.now();
    return '${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}${now.millisecond}';
  }

  String pass = 'aa';
  // 引数にはカメラ撮影時にreturnされるFileオブジェクトを持たせる。
  Future<void> saveLocalActiveImage(File image) async {
    final String path = await localPath;
    final String activeTime = '${now()}active.png';
    final String activeImagePath = '$path/$activeTime';
    activeImageFile = File(activeImagePath);
    await activeImageFile!.writeAsBytes(await image.readAsBytes());
    activeImgPath.text = activeTime;
    setState(() {});
  }

  Future<void> saveLocalStopImage(File image) async {
    final String path = await localPath;
    final String stopTime = '${now()}stop.png';
    final String stopImagePath = '$path/$stopTime';
    stopImageFile = File(stopImagePath);
    await stopImageFile!.writeAsBytes(await image.readAsBytes());
    stopImgPath.text = stopTime;
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
    final String stopImagePath = stopImgPath.text;
    final String name = avatarName.text;

    /// SQL文
    final String query =
        'INSERT INTO ${Constants().tableName}(activeImagePath, stopImagePath, name) VALUES("$activeImagePath", "$stopImagePath", "$name")';

    final Database db = await openDatabase(path, version: Constants().dbVersion,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS ${Constants().tableName} (id INTEGER PRIMARY KEY, activeImagePath TEXT, stopImagePath TEXT, name TEXT)');
    });

    final Avatar avatar1 = Avatar(
      id: 0,
      activeImagePath: activeImgPath.text,
      stopImagePath: stopImgPath.text,
      name: avatarName.text,
    );

    await db.insert(
      'avatar',
      avatar1.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // /// SQL 実行
    // await db.transaction((Transaction txn) async {
    //   await db.insert(
    //     'avatar',
    //     avatar1.toMap(),
    //     conflictAlgorithm: ConflictAlgorithm.replace,
    //   );
    //   // final int id = await txn.rawInsert(query);
    //   // debugPrint('保存成功 id: $id');
    //   debugPrint('保存成功 ');
    // });

    /// ウィジェットの更新
    setState(() {
      activeImgPath.text = '';
      stopImgPath.text = '';
      avatarName.text = '';
      activeImageFile = null;
      stopImageFile = null;
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
  final List<Avatar> avatarList = <Avatar>[];

  late String localGetPath;

  Future<void> localPathgetter() async {
    localGetPath = await localPath;
  }

  @override
  void initState() {
    super.initState();
    localPathgetter();
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
      print('$item[id]');
      _urls.add(item['activeImagePath']! as String);
      Avatar _avatar = Avatar(
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
      appBar: AppBar(
        title: const Text('一覧'),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Column(
                children: [
                  Text('active画像'),
                  Image.memory(
                    File('$localGetPath/${avatarList[index]._activeImagePath}')
                        .readAsBytesSync(),
                    height: 100.0,
                    width: 100.0,
                  ),
                  Text('stop画像'),
                  Image.memory(
                    File('$localGetPath/${avatarList[index]._stopImagePath}')
                        .readAsBytesSync(),
                    height: 100.0,
                    width: 100.0,
                  ),
                ],
              );
            },
            childCount: avatarList.length,
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
