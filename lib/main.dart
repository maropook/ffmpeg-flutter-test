import 'dart:io';
import 'package:camera/camera.dart';
import 'package:ffmpeg_flutter_test/BookManagement/view/ui.dart';
import 'package:ffmpeg_flutter_test/Camera/camera_get_video.dart';
import 'package:ffmpeg_flutter_test/SpeechToText/speech_app.dart';
import 'package:ffmpeg_flutter_test/SpeechToText/speech_text.dart';
import 'package:ffmpeg_flutter_test/TextOutput/assets_output.dart';
import 'package:ffmpeg_flutter_test/TextOutput/text_output.dart';
import 'package:ffmpeg_flutter_test/Video/video_app.dart';
import 'package:ffmpeg_flutter_test/Video/video_get.dart';
import 'package:ffmpeg_flutter_test/VoiceRecoder/recorder_home_view.dart';
import 'package:ffmpeg_flutter_test/ffmpeg/video_tab.dart';
import 'package:ffmpeg_flutter_test/ffmpeg/video_util.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'Camera/camera_example_home.dart';
import 'ffmpeg/ui.dart';

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

Future<void> main() async {
  // Fetch the available cameras before initializing the app.
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
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
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Top(),
    );
  }
}

class Top extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('一覧'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 8),
            ElevatedButton(
              child:
                  Text('【公式サンプル】ffmpeg/flutter_ffmpeg'), //chromeでbuildしても動かない
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MainffmpegPage()));
              },
            ),
            SizedBox(height: 8),
            ElevatedButton(
              child: Text('api 書籍管理 /https,dio'), //localのdjangoで作ったapiと通信する
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TopPage()));
              },
            ),
            SizedBox(height: 8),
            ElevatedButton(
              child: Text('ネットにある動画再生するだけ/video_player'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VideoApp())); //入ってる動画を再生する
              },
            ),
            SizedBox(height: 8),
            ElevatedButton(
              child: Text('speechtotext/speech_to_text'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SpeechToText())); //speechtotextできる．
              },
            ),
            SizedBox(height: 8),
            ElevatedButton(
              child: Text('録音・再生/audio_recoder_2'), //録音と再生ができる．
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RecorderHomeView()));
              },
            ),
            SizedBox(height: 8),
            ElevatedButton(
              child: Text('textoutput'), //録音と再生ができる．
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TextOutput()));
              },
            ),
            SizedBox(height: 8),
            ElevatedButton(
              child: Text('assetsに接続'), //録音と再生ができる．
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FlutterDemo(
                              storage: CounterStorage(),
                            )));
              },
            ),
            SizedBox(height: 8),
            Text('以下，実機ビルドのみでしかできないことがある'),
            SizedBox(height: 8),
            ElevatedButton(
              child: Text('写真を選択または写真を撮影し，それがみれる'), //録音と再生ができる．
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CameraToVideo()));
              },
            ),
            SizedBox(height: 8),
            ElevatedButton(
              child: Text(
                  '動画を選択または動画を撮影し，それがみれる'), //写真も動画も撮れる．実機で動かさないといけない.cameraの公式のただのsample
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MainScreen()));
              },
            ),
            SizedBox(height: 8),
            ElevatedButton(
              child: Text(
                  '【公式サンプル】カメラ，動画撮影,/camera,video_player'), //写真も動画も撮れる．実機で動かさないといけない.cameraの公式のただのsample
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CameraExampleHome()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
