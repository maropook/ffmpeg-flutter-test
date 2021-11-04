import 'package:ffmpeg_flutter_test/Avatar/view/ui.dart';
import 'package:ffmpeg_flutter_test/BookManagement/view/ui.dart';
import 'package:ffmpeg_flutter_test/Camera/camera_get_video.dart';
import 'package:ffmpeg_flutter_test/SpeechToText/speech_text.dart';
import 'package:ffmpeg_flutter_test/TextOutput/assets_output.dart';
import 'package:ffmpeg_flutter_test/TextOutput/text_output.dart';
import 'package:ffmpeg_flutter_test/Video/video_app.dart';
import 'package:ffmpeg_flutter_test/Video/video_get.dart';
import 'package:ffmpeg_flutter_test/VoiceRecoder/recorder_home_view.dart';
import 'package:ffmpeg_flutter_test/db.dart';
import 'package:ffmpeg_flutter_test/file_avatar.dart';
import 'package:ffmpeg_flutter_test/main.dart';
import 'package:flutter/material.dart';
import 'Camera/camera_example_home.dart';
import 'package:ffmpeg_flutter_test/ffmpeg/ui.dart';

// class TopPages extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return TopPagesState();
//   }
// }

// class TopPagesState extends State<TopPages> {
//   @override
//   void initState() {
//     _routeAvatar = initialAvatar;
//     args = AvatarListHomeArgs(_routeAvatar);

//     super.initState();
//   }

//   late Avatar _routeAvatar;
//   late AvatarListHomeArgs args;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('一覧'),
//         ),
//         body: Center(
//             child: Column(children: [
//           Text('${_routeAvatar.name}'),
//           ElevatedButton(
//             child: Text('Avatar保存'), //localのdjangoで作ったapiと通信する
//             onPressed: () async {
//               args = AvatarListHomeArgs(_routeAvatar);

//               _routeAvatar = await Navigator.of(context)
//                   .pushNamed('/avatar_list', arguments: args) as Avatar;

//               setState(() {
//                 if (_routeAvatar != null) {
//                   debugPrint('${_routeAvatar.name}!!!!!!!!!!!!!!!!!');
//                 }
//               });
//             },
//           ),
//         ])));
//   }
// }

class Top extends StatelessWidget {
  const Top({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('一覧'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            ElevatedButton(
              child: const Text('ffmpeg'), //localのdjangoで作ったapiと通信する
              onPressed: () {
                Navigator.push<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => MainffmpegPage()));
              },
            ),
            ElevatedButton(
              child: const Text('Avatar'), //localのdjangoで作ったapiと通信する
              onPressed: () {
                Navigator.push<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => AcatarHomeWidget()));
              },
            ),
            ElevatedButton(
              child: const Text('dbTest'), //localのdjangoで作ったapiと通信する
              onPressed: () {
                Navigator.push<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => TopScreen()));
              },
            ),
            ElevatedButton(
              child: const Text('apisample'), //localのdjangoで作ったapiと通信する
              onPressed: () {
                Navigator.push<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => const ApiTop()));
              },
            ),
            const SizedBox(height: 8),
            const SizedBox(height: 8),
            ElevatedButton(
              child:
                  const Text('api 書籍管理 /https,dio'), //localのdjangoで作ったapiと通信する
              onPressed: () {
                Navigator.push<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => TopPage()));
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              child: const Text('ネットにある動画再生するだけ/video_player'),
              onPressed: () {
                Navigator.push<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) =>
                            VideoApp())); //入ってる動画を再生する
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              child: const Text('speechtotext/speech_to_text'),
              onPressed: () {
                Navigator.push<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) =>
                            SpeechToText())); //speechtotextできる．
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              child: const Text('録音・再生/audio_recoder_2'), //録音と再生ができる．
              onPressed: () {
                Navigator.push<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => RecorderHomeView()));
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              child: const Text('textoutput'), //録音と再生ができる．
              onPressed: () {
                Navigator.push<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => TextOutput()));
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              child: const Text('assetsに接続'), //録音と再生ができる．
              onPressed: () {
                Navigator.push<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => FlutterDemo(
                              storage: CounterStorage(),
                            )));
              },
            ),
            const SizedBox(height: 8),
            const Text('以下，実機ビルドのみでしかできないことがある'),
            const SizedBox(height: 8),
            ElevatedButton(
              child: const Text('写真を選択または写真を撮影し，それがみれる'), //録音と再生ができる．
              onPressed: () {
                Navigator.push<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => CameraToVideo()));
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              child: const Text(
                  '動画を選択または動画を撮影し，それがみれる'), //写真も動画も撮れる．実機で動かさないといけない.cameraの公式のただのsample
              onPressed: () {
                Navigator.push<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => MainScreen()));
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              child: const Text(
                  '【公式サンプル】カメラ，動画撮影,/camera,video_player'), //写真も動画も撮れる．実機で動かさないといけない.cameraの公式のただのsample
              onPressed: () {
                Navigator.push<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) =>
                            CameraExampleHome()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
