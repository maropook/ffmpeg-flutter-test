import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("video play demo"),
      ),
      body: Center(),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              //galleryをcameraに変更すれば、撮影した動画を再生できる。
              getVideo(context, ImageSource.gallery);
            },
            heroTag: "gallery",
            child: Icon(Icons.photo),
          ),
          FloatingActionButton(
            onPressed: () {
              //galleryをcameraに変更すれば、撮影した動画を再生できる。
              getVideoNow(context, ImageSource.camera);
            },
            heroTag: "galleryNow",
            child: Icon(Icons.video_call_rounded),
          ),
        ],
      ),
    );
  }

  Future getVideo(context, source) async {
    //image pickerを用いて動画を選択する。
    final picker = ImagePicker();
    final pickVideo = await picker.pickVideo(source: source);
    if (pickVideo == null) return;

    //データの型をPickedFileからFileに変更する。
    final pickFile = File(pickVideo.path);

    //localPathを呼び出して、アプリ内のストレージ領域を確保。
    final path = await localPath;

    //拡張子を取得
    final String fileName = basename(pickVideo.path);

    //pickした動画をコピーする場所を作成。
    final videoPath = '$path/$fileName';

    //pickした動画をvideoPathにコピー。※ .copyはデータの型がFileの必要あり。
    final File saveVideo = await pickFile.copy('$videoPath');

    //saveVideoを引数に、VideoItemページに移動。
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VideoItem(saveVideo),
      ),
    );
  }

  Future getVideoNow(context, source) async {
    //image pickerを用いて動画を選択する。
    final picker = ImagePicker();
    final pickVideo = await picker.pickVideo(source: source);
    if (pickVideo == null) return;

    //データの型をPickedFileからFileに変更する。
    final pickFile = File(pickVideo.path);

    //localPathを呼び出して、アプリ内のストレージ領域を確保。
    final path = await localPath;

    //拡張子を取得
    final String fileName = basename(pickVideo.path);

    //pickした動画をコピーする場所を作成。
    final videoPath = '$path/$fileName';

    //pickした動画をvideoPathにコピー。※ .copyはデータの型がFileの必要あり。
    final File saveVideo = await pickFile.copy('$videoPath');

    //saveVideoを引数に、VideoItemページに移動。
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VideoItem(saveVideo),
      ),
    );
  }

  //path_providerでアプリ内のストレージ領域を確保。
  static Future get localPath async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String path = appDocDir.path;
    return path;
  }
}

class VideoItem extends StatefulWidget {
  //VideoItemを実行した時の引数を取得するのに必要。
  final File saveVideo;
  VideoItem(this.saveVideo);

  @override
  _VideoItemState createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  ChewieController? _chewieController;
  VideoPlayerController? _videoPlayerController;

  //ただの箱。
  late Future<void> _future;

  Future<void> initVideoPlayer() async {
    //初期化。
    await _videoPlayerController!.initialize();
    setState(() {
      //Chewieで動画を再生するための準備。
      _chewieController = ChewieController(
        //動画のパスを教えてあげる
        videoPlayerController: _videoPlayerController!,
        //動画表示画面の比率
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        //自動再生
        autoPlay: true,
        //自動ループ再生
        looping: true,
        //もし、Chewieでエラーが出ていたら表示。
        //The requested URL was not found on this server.と出てきたら動画のパスの型（File型、String型）に注意。
        errorBuilder: (context, errorMessage) {
          print(errorMessage);
          return Center(
            child: Text(errorMessage),
          );
        },
      );
    });
  }

  @override
  void initState() {
    super.initState();
    //_videoPlayerControllerに動画のパスを示す。widget.’変数’で引数を用いれる。
    _videoPlayerController = VideoPlayerController.file(widget.saveVideo);
    _future = initVideoPlayer();
  }

  //このページを離れる時にコントローラーを破棄してくれる。
  //必要らしい
  @override
  void dispose() {
    super.dispose();
    _videoPlayerController!.dispose();
    _chewieController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("video play demo"),
      ),
      body: SafeArea(
        child: FutureBuilder(
          //_future = initVideoPlayer()
          future: _future,
          builder: (context, snapshot) {
            return Center(
              //initializedされていたらtrueになって、動画が再生される。
              child: _videoPlayerController!.value.isInitialized
                  //動画再生表示画面の比率をオリジナルのまま表示してくれる
                  ? AspectRatio(
                      aspectRatio: _videoPlayerController!.value.aspectRatio,
                      //数行で動画再生してくれる。
                      child: Chewie(
                        controller: _chewieController!,
                      ),
                    )
                  : CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
