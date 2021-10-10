import 'dart:io';
import 'package:camera/camera.dart';
import 'package:ffmpeg_flutter_test/avatar.dart';
import 'package:ffmpeg_flutter_test/avatar_list_home.dart';
import 'package:ffmpeg_flutter_test/avatar_save_service.dart';
import 'package:ffmpeg_flutter_test/generate_route.dart';
import 'package:ffmpeg_flutter_test/top.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'Camera/camera_example_home.dart';

late Avatar initialAvatar;
late Avatar selectedAvatar;
Future<void> main() async {
  // Fetch the available cameras before initializing the app.
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
    initialAvatar = await selectedAvatarCreate();
    selectedAvatar = await selectedAvatarCreate();
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '色々',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => TopPages(),
      },
      onGenerateRoute: generateRoute,
    );
  }
}

GlobalKey _globalKey = GlobalKey();

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<String> get _localPathtest async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File(
        '/Users/hasegawaitsuki/ghq/github.com/maropook/ffmpeg_flutter_test/assets/counter.txt');
    //return File('$path/counter.txt');
    // =/Users/hasegawaitsuki/Library/Developer/CoreSimulator/Devices/661DC9A5-9224-4BC9-A812-223BA1DD0FD9/data/Containers/Data/Application/C0C0BB6D-8894-403D-A200-24932A938ADD/Documents/counter.txt'
  }

  Future<File> get _localFiletest async {
    final path = await _localPath;
    return File(
        '/Users/hasegawaitsuki/ghq/github.com/maropook/ffmpeg_flutter_test/assets/test.txt');
    //return File('$path/counter.txt');
    // =/Users/hasegawaitsuki/Library/Developer/CoreSimulator/Devices/661DC9A5-9224-4BC9-A812-223BA1DD0FD9/data/Containers/Data/Application/C0C0BB6D-8894-403D-A200-24932A938ADD/Documents/counter.txt'
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;
    final filetest = await _localFiletest;

    filetest.writeAsString('$counter\n\n', mode: FileMode.append, flush: true);

    // Write the file
    return file.writeAsString('$counter');
  }
}
