import 'package:ffmpeg_flutter_test/Avatar/view/ui.dart';
import 'package:ffmpeg_flutter_test/BookManagement/view/ui.dart';
import 'package:ffmpeg_flutter_test/Camera/camera_get_video.dart';
import 'package:ffmpeg_flutter_test/SpeechToText/speech_app.dart';
import 'package:ffmpeg_flutter_test/SpeechToText/speech_text.dart';
import 'package:ffmpeg_flutter_test/TextOutput/assets_output.dart';
import 'package:ffmpeg_flutter_test/TextOutput/text_output.dart';
import 'package:ffmpeg_flutter_test/Video/video_app.dart';
import 'package:ffmpeg_flutter_test/Video/video_get.dart';
import 'package:ffmpeg_flutter_test/VoiceRecoder/recorder_home_view.dart';
import 'package:ffmpeg_flutter_test/avatar.dart';
import 'package:ffmpeg_flutter_test/file_avatar.dart';
import 'package:ffmpeg_flutter_test/avatar_list_home.dart';
import 'package:ffmpeg_flutter_test/db.dart';
import 'package:ffmpeg_flutter_test/ffmpeg/video_tab.dart';
import 'package:ffmpeg_flutter_test/ffmpeg/video_util.dart';
import 'package:ffmpeg_flutter_test/file_service.dart';
import 'package:ffmpeg_flutter_test/main.dart';
import 'package:ffmpeg_flutter_test/route_args.dart';
import 'package:ffmpeg_flutter_test/top.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'Camera/camera_example_home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopPages extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TopPagesState();
  }
}

class TopPagesState extends State<TopPages> {
  @override
  void initState() {
    _routeAvatar = initialAvatar;
    args = AvatarListHomeArgs(_routeAvatar);

    super.initState();
  }

  late Avatar _routeAvatar;
  late AvatarListHomeArgs args;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('一覧'),
        ),
        body: Center(
            child: Column(children: [
          Text('${_routeAvatar.name}'),
          ElevatedButton(
            child: Text('Avatar保存'), //localのdjangoで作ったapiと通信する
            onPressed: () async {
              args = AvatarListHomeArgs(_routeAvatar);

              _routeAvatar = await Navigator.of(context)
                  .pushNamed('/avatar_list', arguments: args) as Avatar;

              setState(() {
                if (_routeAvatar != null) {
                  debugPrint('${_routeAvatar.name}!!!!!!!!!!!!!!!!!');
                }
              });
            },
          ),
        ])));
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
            // ElevatedButton(
            //   child: Text('Avatar保存'), //localのdjangoで作ったapiと通信する
            //   onPressed: () {
            //     Navigator.push<dynamic>(
            //         context,
            //         MaterialPageRoute<dynamic>(
            //             builder: (context) => const AvatarListHomeWidget()));
            //   },
            // ),

            // ElevatedButton(
            //   child: Text('Avatar'), //localのdjangoで作ったapiと通信する
            //   onPressed: () {
            //     Navigator.push<dynamic>(
            //         context,
            //         MaterialPageRoute<dynamic>(
            //             builder: (context) => AcatarHomeWidget()));
            //   },
            // ),
            // ElevatedButton(
            //   child: Text('dbTest'), //localのdjangoで作ったapiと通信する
            //   onPressed: () {
            //     Navigator.push<dynamic>(
            //         context,
            //         MaterialPageRoute<dynamic>(
            //             builder: (context) => TopScreen()));
            //   },
            // ),
            // ElevatedButton(
            //   child: Text('画像'), //localのdjangoで作ったapiと通信する
            //   onPressed: () {
            //     Navigator.push<dynamic>(
            //         context,
            //         MaterialPageRoute<dynamic>(
            //             builder: (context) => ImagePickerView()));
            //   },
            // ),
            // ElevatedButton(
            //   child: Text('apisample'), //localのdjangoで作ったapiと通信する
            //   onPressed: () {
            //     Navigator.push<dynamic>(context,
            //         MaterialPageRoute<dynamic>(builder: (context) => ApiTop()));
            //   },
            // ),
            // SizedBox(height: 8),
            // ElevatedButton(
            //   child:
            //       Text('【公式サンプル】ffmpeg/flutter_ffmpeg'), //chromeでbuildしても動かない
            //   onPressed: () {
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => MainffmpegPage()));
            //   },
            // ),
            // SizedBox(height: 8),
            // ElevatedButton(
            //   child: Text('api 書籍管理 /https,dio'), //localのdjangoで作ったapiと通信する
            //   onPressed: () {
            //     Navigator.push<dynamic>(
            //         context,
            //         MaterialPageRoute<dynamic>(
            //             builder: (context) => TopPage()));
            //   },
            // ),
            // SizedBox(height: 8),
            // ElevatedButton(
            //   child: Text('ネットにある動画再生するだけ/video_player'),
            //   onPressed: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => VideoApp())); //入ってる動画を再生する
            //   },
            // ),
            // SizedBox(height: 8),
            // ElevatedButton(
            //   child: Text('speechtotext/speech_to_text'),
            //   onPressed: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) =>
            //                 SpeechToText())); //speechtotextできる．
            //   },
            // ),
            // SizedBox(height: 8),
            // ElevatedButton(
            //   child: Text('録音・再生/audio_recoder_2'), //録音と再生ができる．
            //   onPressed: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => RecorderHomeView()));
            //   },
            // ),
            // SizedBox(height: 8),
            // ElevatedButton(
            //   child: Text('textoutput'), //録音と再生ができる．
            //   onPressed: () {
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => TextOutput()));
            //   },
            // ),
            // SizedBox(height: 8),
            // ElevatedButton(
            //   child: Text('assetsに接続'), //録音と再生ができる．
            //   onPressed: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => FlutterDemo(
            //                   storage: CounterStorage(),
            //                 )));
            //   },
            // ),
            // SizedBox(height: 8),
            // Text('以下，実機ビルドのみでしかできないことがある'),
            // SizedBox(height: 8),
            // ElevatedButton(
            //   child: Text('写真を選択または写真を撮影し，それがみれる'), //録音と再生ができる．
            //   onPressed: () {
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => CameraToVideo()));
            //   },
            // ),
            // SizedBox(height: 8),
            // ElevatedButton(
            //   child: Text(
            //       '動画を選択または動画を撮影し，それがみれる'), //写真も動画も撮れる．実機で動かさないといけない.cameraの公式のただのsample
            //   onPressed: () {
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => MainScreen()));
            //   },
            // ),
            // SizedBox(height: 8),
            // ElevatedButton(
            //   child: Text(
            //       '【公式サンプル】カメラ，動画撮影,/camera,video_player'), //写真も動画も撮れる．実機で動かさないといけない.cameraの公式のただのsample
            //   onPressed: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => CameraExampleHome()));
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
