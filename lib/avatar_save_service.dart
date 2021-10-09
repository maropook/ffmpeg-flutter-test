import 'dart:io';

import 'package:ffmpeg_flutter_test/avatar.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
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

class AvatarInitial {
  static const String initialActiveAvatar = "avatar.png";
  static const String initialStopAvatar = "avatar0.png";
  String FONT_ASSET_2 = "truenorg.otf";

  static Future<String> assetToFile(String assetName) async {
    final ByteData assetByteData = await rootBundle.load('assets/$assetName');

    final List<int> byteList = assetByteData.buffer
        .asUint8List(assetByteData.offsetInBytes, assetByteData.lengthInBytes);

    await File(join(await localPath, assetName))
        .writeAsBytes(byteList, mode: FileMode.writeOnly, flush: true);

    return assetName;
  }
}

Future<Avatar> selectedAvatarCreate() async {
  String activeImagePath =
      await AvatarInitial.assetToFile(AvatarInitial.initialActiveAvatar);
  String stopImagePath =
      await AvatarInitial.assetToFile(AvatarInitial.initialStopAvatar);
  Avatar avatar = Avatar(
      activeImagePath: AvatarInitial.initialActiveAvatar,
      stopImagePath: AvatarInitial.initialStopAvatar,
      name: '初期アバター',
      id: 1);

  return avatar;
}
