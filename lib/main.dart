import 'dart:io';
import 'package:camera/camera.dart';
import 'package:ffmpeg_flutter_test/BookManagement/view/ui.dart';
import 'package:ffmpeg_flutter_test/Camera/camera_app.dart';
import 'package:ffmpeg_flutter_test/SpeechToText/speech_app.dart';
import 'package:ffmpeg_flutter_test/Video/video_app.dart';
import 'package:ffmpeg_flutter_test/VoiceRecoder/recorder_home_view.dart';
import 'package:ffmpeg_flutter_test/ffmpeg/video_tab.dart';
import 'package:ffmpeg_flutter_test/ffmpeg/video_util.dart';
import 'package:flutter/material.dart';
import 'Camera/camera_example_home.dart';
import 'ffmpeg/ui.dart';

GlobalKey _globalKey = GlobalKey();

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
        title: Text('色々'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 8),
            ElevatedButton(
              child: Text('ffmpeg 公式サンプル/flutter_ffmpeg'), //chromeでbuildしても動かない
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
              child: Text('動画再生するだけ/video_player'),
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
                            SpeechScreen())); //speechtotextできる．
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
            Divider(),
            Text('以下実機ビルド必須'),
            SizedBox(height: 8),
            ElevatedButton(
              child: Text('カメラ(写真が撮れるだけ)/camera'), //写真が撮れる．実機で動かさないといけない
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CameraAppSmall()));
              },
            ),
            SizedBox(height: 8),
            ElevatedButton(
              child: Text(
                  '公式カメラ，動画撮影,/camera,video_player'), //写真も動画も撮れる．実機で動かさないといけない.cameraの公式のただのsample
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
