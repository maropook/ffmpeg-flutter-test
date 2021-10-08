import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> get localPath async {
  final Directory directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

class Constants {
  final String dbName = 'sqflite.db';
  final int dbVersion = 1;
  final String tableName = 'avatar';
}

String now() {
  final DateTime now = DateTime.now();
  return '${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}${now.millisecond}';
}
