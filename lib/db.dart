import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class Constants {
  final String dbName = "sqflite.db";
  final int dbVersion = 1;
  final String tableName = "address";
}

class TopScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BottomNavigationBar App',
      initialRoute: '/',
      routes: {
        '/': (context) => FirstScreen(),
        '/list': (context) => SecondScreen(),
      },
    );
  }
}

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  final TextStyle style1 = TextStyle(fontSize: 30.0, color: Colors.black);
  final TextStyle style2 = TextStyle(fontSize: 30.0, color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '名前:',
                style: style2,
              ),
            ),
            TextField(
              controller: nameController,
              style: style1,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Email:',
                style: style2,
              ),
            ),
            TextField(
              controller: emailController,
              style: style1,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '電話番号:',
                style: style2,
              ),
            ),
            TextField(
              controller: phoneController,
              style: style1,
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            title: Text('追加'),
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(title: Text('一覧'), icon: Icon(Icons.list)),
        ],
        onTap: (int index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/list');
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          _saveData();
          showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    title: Text("保存しました"),
                    content: Text('データベースに保存できました'),
                  ));
        },
      ),
    );
  }

  /// データを保存する
  void _saveData() async {
    /// データベースのパスを取得
    String dbFilePath = await getDatabasesPath();
    String path = join(dbFilePath, Constants().dbName);

    /// 保存するデータの用意
    String name = nameController.text;
    String email = emailController.text;
    String phone = phoneController.text;

    /// SQL文
    String query =
        'INSERT INTO ${Constants().tableName}(name, mail, tel) VALUES("$name", "$email", "$phone")';

    Database db = await openDatabase(path, version: Constants().dbVersion,
        onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE IF NOT EXISTS ${Constants().tableName} (id INTEGER PRIMARY KEY, name TEXT, mail TEXT, tel TEXT)");
    });

    /// SQL 実行
    await db.transaction((txn) async {
      int id = await txn.rawInsert(query);
      print("保存成功 id: $id");
    });

    /// ウィジェットの更新
    setState(() {
      nameController.text = "";
      emailController.text = "";
      phoneController.text = "";
    });
  }
}

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  List<Widget> _items = <Widget>[];

  @override
  void initState() {
    super.initState();
    getItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('一覧'),
      ),
      body: ListView(
        children: _items,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(title: Text("追加"), icon: Icon(Icons.home)),
          BottomNavigationBarItem(title: Text('一覧'), icon: Icon(Icons.list))
        ],
        onTap: (int index) {
          if (index == 0) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  /// 保存したデータを取り出す
  void getItems() async {
    /// データベースのパスを取得
    List<Widget> list = <Widget>[];
    String dbFilePath = await getDatabasesPath();
    String path = join(dbFilePath, Constants().dbName);

    /// テーブルがなければ作成する
    Database db = await openDatabase(path, version: Constants().dbVersion,
        onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE IF NOT EXISTS ${Constants().tableName} (id INTEGER PRIMARY KEY, name TEXT, mail TEXT, tel TEXT)");
    });

    /// SQLの実行
    List<Map> result =
        await db.rawQuery('SELECT * FROM ${Constants().tableName}');

    /// データの取り出し
    for (Map item in result) {
      list.add(ListTile(
        title: Text(item['name'] as String),
        subtitle: Text(item['mail'] + ' ' + item['tel'] as String),
      ));
    }

    /// ウィジェットの更新
    setState(() {
      _items = list;
    });
  }
}
