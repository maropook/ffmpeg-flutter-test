import 'package:flutter_ffmpeg/completed_ffmpeg_execution.dart';
import 'package:flutter_ffmpeg/statistics.dart';
import 'package:ffmpeg_flutter_test/ffmpeg/abstract.dart'; //
import 'package:ffmpeg_flutter_test/ffmpeg/flutter_ffmpeg_api_wrapper.dart'; //
import 'package:ffmpeg_flutter_test/ffmpeg/player.dart';

import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'util.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VideoUtilkun {
  static Future<Directory> get tempDirectory async {
    return await getTemporaryDirectory();
  }

  static const String ASSET_1 = "pyramid.jpg";
  static const String ASSET_2 = "colosseum.jpg";
  static const String ASSET_3 = "tajmahal.jpg";
  static const String SUBTITLE_ASSET = "subtitle.srt";
  static const String FONT_ASSET_1 = "doppioone_regular.ttf";
  static const String FONT_ASSET_2 = "truenorg.otf";

  static void prepareAssets() async {
    await VideoUtilkun.assetToFile(ASSET_1);
    await VideoUtilkun.assetToFile(ASSET_2);
    await VideoUtilkun.assetToFile(ASSET_3);
    await VideoUtilkun.assetToFile(SUBTITLE_ASSET);
    await VideoUtilkun.assetToFile(FONT_ASSET_1);
    await VideoUtilkun.assetToFile(FONT_ASSET_2);
  }

  static Future<String> assetPath(String assetName) async {
    return join((await tempDirectory).path, assetName);
  }

  static Future<Directory> get documentsDirectory async {
    return await getApplicationDocumentsDirectory();
  }

  static Future<File> assetToFile(String assetName) async {
    final ByteData assetByteData = await rootBundle.load('assets/$assetName');

    final List<int> byteList = assetByteData.buffer
        .asUint8List(assetByteData.offsetInBytes, assetByteData.lengthInBytes);

    final String fullTemporaryPath =
        join((await tempDirectory).path, assetName);

    Future<File> fileFuture = new File(fullTemporaryPath)
        .writeAsBytes(byteList, mode: FileMode.writeOnly, flush: true);

    ffprint('assets/$assetName saved to file at $fullTemporaryPath.');

    return fileFuture;
  }
}

void showPopup(String text) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.white70,
      textColor: Colors.black87,
      fontSize: 16.0);
}

enum _State { IDLE, CREATING, BURNING }

class SubtitleTab implements PlayerTab {
  VideoPlayerController? _videoPlayerController;
  late RefreshablePlayerDialogFactory _refreshablePlayerDialogFactory;
  late Statistics? _statistics;
  late _State _state;
  late int _executionId;

  void init(RefreshablePlayerDialogFactory refreshablePlayerDialogFactory) {
    _refreshablePlayerDialogFactory = refreshablePlayerDialogFactory;
    _statistics = null;
    _state = _State.IDLE;
    _executionId = 0;
  }

  void setActive() {
    print("Subtitle Tab Activated");

    enableStatisticsCallback(statisticsCallback);
  }

  void statisticsCallback(Statistics statistics) {
    this._statistics = statistics;
    updateProgressDialog();
  }

  void burnSubtitles() {
    VideoUtilkun.assetPath(VideoUtilkun.SUBTITLE_ASSET).then((subtitlePath) {
      getVideoFile().then((videoFile) {
        getVideoWithSubtitlesFile().then((videoWithSubtitlesFile) {
          // IF VIDEO IS PLAYING STOP PLAYBACK
          pause();

          try {
            videoFile.delete().catchError((_) {});
          } on Exception catch (_) {}

          try {
            videoWithSubtitlesFile.delete().catchError((_) {});
          } on Exception catch (_) {}

          ffprint("Testing SUBTITLE burning");

          _state = _State.CREATING;

          ffprint("Create completed successfully; burning subtitles.");
//subtitle
          String burnSubtitlesCommand =
              "-y -i ${"/Users/hasegawaitsuki/ghq/github.com/maropook/ffmpeg_flutter_test/assets/a.mp4"} -vf subtitles=$subtitlePath:force_style='Fontname=Trueno' -c:v mpeg4 ${videoWithSubtitlesFile.path}";
          // どのvideoと合成するか．
          //  "-y -i ${videoFile.path} -vf subtitles=$subtitlePath:force_style='Fontname=Trueno' -c:v mpeg4 ${videoWithSubtitlesFile.path}";

          showBurnProgressDialog();

          ffprint(
              "FFmpeg process started with arguments\n\'$burnSubtitlesCommand\'.");

          _state = _State.BURNING;

          executeAsyncFFmpeg(burnSubtitlesCommand,
              (CompletedFFmpegExecution secondExecution) {
            ffprint(
                "FFmpeg process exited with rc ${secondExecution.returnCode}.");
            hideProgressDialog();

            if (secondExecution.returnCode == 0) {
              ffprint("Burn subtitles completed successfully; playing video.");
              playVideo();
            } else if (secondExecution.returnCode == 255) {
              showPopup("Burn subtitles operation cancelled.");
              ffprint("Burn subtitles operation cancelled");
            } else {
              showPopup(
                  "Burn subtitles failed. Please check log for the details.");
              ffprint(
                  "Burn subtitles failed with rc=${secondExecution.returnCode}.");
            }
          }).then((executionId) {
            _executionId = executionId;
            ffprint(
                "Async FFmpeg process started with arguments '$burnSubtitlesCommand' and executionId $executionId.");
          });
        });
      });
    });
  }

  Future<void> playVideo() async {
    if (_videoPlayerController != null) {
      await _videoPlayerController!.initialize();
      await _videoPlayerController!.play();
    }
    _refreshablePlayerDialogFactory.refresh();
  }

  Future<void> pause() async {
    if (_videoPlayerController != null) {
      await _videoPlayerController!.pause();
    }
    _refreshablePlayerDialogFactory.refresh();
  }

  Future<File> getVideoFile() async {
    final String video = "video.mp4";
    Directory documentsDirectory = await VideoUtilkun.documentsDirectory;
    // 画像から作成した動画の保存場所
    //return new File("${documentsDirectory.path}/$video");
    return File(
        '/Users/hasegawaitsuki/ghq/github.com/maropook/ffmpeg_flutter_test/assets/video.mp4');
  }

  Future<File> getVideoWithSubtitlesFile() async {
    final String video = "video-with-subtitles.mp4";
    Directory documentsDirectory = await VideoUtilkun.documentsDirectory;
    // 動画に字幕をつけた動画の保存場所
    // return new File("${documentsDirectory.path}/$video");
    return File(
        '/Users/hasegawaitsuki/ghq/github.com/maropook/ffmpeg_flutter_test/assets/subtitlevideo.mp4');
  }

  void showCreateProgressDialog() {
    // CLEAN STATISTICS
    _statistics = null;
    resetStatistics();
    _refreshablePlayerDialogFactory.dialogShowCancellable(
        "Creating video", () => cancelExecution(_executionId));
  }

  void showBurnProgressDialog() {
    // CLEAN STATISTICS
    _statistics = null;
    resetStatistics();
    _refreshablePlayerDialogFactory.dialogShowCancellable(
        "Burning subtitles", () => cancelExecution(_executionId));
  }

  void updateProgressDialog() {
    if (_statistics == null) {
      return;
    }

    int timeInMilliseconds = this._statistics!.time;
    if (timeInMilliseconds > 0) {
      int totalVideoDuration = 9000;

      int completePercentage = (timeInMilliseconds * 100) ~/ totalVideoDuration;
      if (_state == _State.BURNING) {
        _refreshablePlayerDialogFactory
            .dialogUpdate("Burning subtitles % $completePercentage");
      }
      _refreshablePlayerDialogFactory.refresh();
    }
  }

  void hideProgressDialog() {
    _refreshablePlayerDialogFactory.dialogHide();
  }

  @override
  void setController(VideoPlayerController controller) {
    _videoPlayerController = controller;
  }
}
