import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<File> getFilePath(String fileName) async {
  final Directory directory = await getTemporaryDirectory();
  final String path = directory.path;

  return File('$path/$fileName');
}

Future<String> load(String fileName) async {
  final File file = await getFilePath(fileName);
  return file.readAsString();
}

Future<String> loadSubtitlePath(String fileName) async {
  final File file = await getFilePath(fileName);
  return file.path;
}

Future<String> get localPath async {
  final Directory directory = await getApplicationDocumentsDirectory();
  return directory.path;
}
