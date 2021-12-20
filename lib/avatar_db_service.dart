import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'db.dart';

class AvatarDBService {
  Future<Database> getDatabase() async {
    final String dbFilePath = await getDatabasesPath();
    final String path = join(dbFilePath, Constants().dbName);
    return openDatabase(path,
        version: Constants().dbVersion,
        onCreate: (Database db, int version) async {});
  }
}
