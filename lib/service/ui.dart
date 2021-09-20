/*
 * Copyright (c) 2020 Taner Sener
 *
 * This file is part of FlutterFFmpeg.
 *
 * FlutterFFmpeg is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * FlutterFFmpeg is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with FlutterFFmpeg.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_ffmpeg/completed_ffmpeg_execution.dart';
import 'package:flutter_ffmpeg/statistics.dart';
import 'package:flutter_ffmpeg/log_level.dart';

import 'package:ffmpeg_flutter_test/service/progress_modal.dart';
import 'package:ffmpeg_flutter_test/service/flutter_ffmpeg_api_wrapper.dart'; //

class Refreshable {
  void refresh() {}
}

class DialogFactory {
  void dialogShow(String message) {}

  void dialogShowCancellable(String message, Function cancelFunction) {}

  void dialogUpdate(String message) {}

  void dialogHide() {}
}

class RefreshablePlayerDialogFactory implements Refreshable, DialogFactory {
  @override
  void dialogHide() {}

  @override
  void dialogUpdate(String message) {}

  @override
  void refresh() {}

  @override
  void dialogShow(String message) {}

  @override
  void dialogShowCancellable(String message, Function cancelFunction) {}
}

class PlayerTab {
  void setController(VideoPlayerController controller) {}
}

class EmbeddedPlayer extends StatefulWidget {
  final String _filePath;
  final PlayerTab _playerTab;

  EmbeddedPlayer(this._filePath, this._playerTab);

  @override
  _EmbeddedPlayerState createState() =>
      _EmbeddedPlayerState(new File(_filePath), _playerTab);
}

class _EmbeddedPlayerState extends State<EmbeddedPlayer> {
  final PlayerTab _playerTab;
  final File _file;
  VideoPlayerController? _videoPlayerController;
  bool startedPlaying = false;

  _EmbeddedPlayerState(this._file, this._playerTab);

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.file(_file);
    _playerTab.setController(_videoPlayerController!);
  }

  @override
  void dispose() {
    _videoPlayerController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 0,
        child: Center(
          child: FutureBuilder<bool>(
            future: Future.value(_videoPlayerController!.value.isInitialized),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.data == true) {
                return Container(
                  alignment: Alignment(0.0, 0.0),
                  child: VideoPlayer(_videoPlayerController!),
                );
              } else {
                return Container(
                  alignment: Alignment(0.0, 0.0),
                );
              }
            },
          ),
        ));
  }
}

String today() {
  var now = new DateTime.now();
  return "${now.year}-${now.month}-${now.day}";
}

String now() {
  var now = new DateTime.now();
  return "${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}.${now.millisecond}";
}

void ffprint(String text) {
  final pattern = new RegExp('.{1,900}');
  var nowString = now();
  pattern
      .allMatches(text)
      .forEach((match) => print("$nowString - " + match.group(0)!));
}

GlobalKey _globalKey = GlobalKey();

class MainffmpegPage extends StatefulWidget {
  MainffmpegPage(this.videoPath, this.strPath);
  String videoPath;
  String strPath;
  @override
  FlutterFFmpegExampleAppState createState() =>
      FlutterFFmpegExampleAppState(videoPath, strPath);
}

class FlutterFFmpegExampleAppState extends State<MainffmpegPage>
    with TickerProviderStateMixin
    implements RefreshablePlayerDialogFactory {
  FlutterFFmpegExampleAppState(this.videoPath, this.strPath);
  String videoPath;
  String strPath;

  // COMMON COMPONENTS
  ProgressModal? progressModal;

  // SUBTITLE TAB COMPONENTS
  late SubtitleTab subtitleTab = SubtitleTab(videoPath, strPath);
  // CONCURRENT EXECUTION TAB COMPONENTS

  void refresh() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    subtitleTab.init(this);
    subtitleTab.setActive();
    VideoUtil.prepareAssets();
    VideoUtil.registerAppFont();
    setLogLevel(LogLevel.AV_LOG_INFO);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text('FlutterFFmpegTest'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 0, bottom: 0),
            child: InkWell(
              onTap: () async {
                subtitleTab.burnSubtitles();
              },
              child: Container(
                width: 180,
                height: 38,
                child: Center(
                  child: Text(
                    'BURN SUBTITLES', //字幕  動画を作成
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(4.0),
              child: FutureBuilder(
                future: subtitleTab.getVideoWithSubtitlesFile(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    File file = snapshot.data as File;
                    return Container(
                        alignment: Alignment(0.0, 0.0),
                        child: EmbeddedPlayer("${file.path}", subtitleTab));
                  } else {
                    return Container(
                      alignment: Alignment(0.0, 0.0),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dialogHide() {
    if (progressModal != null) {
      progressModal?.hide();
    }
  }

  @override
  void dialogShowCancellable(String message, Function cancelFunction) {
    progressModal = ProgressModal(_globalKey.currentContext!);
    progressModal?.show(message, cancelFunction: cancelFunction);
  }

  @override
  void dialogShow(String message) {
    progressModal = ProgressModal(_globalKey.currentContext!);
    progressModal?.show(message);
  }

  @override
  void dialogUpdate(String message) {
    progressModal?.update(message: message);
  }
}

class VideoUtil {
  static Future<Directory> get tempDirectory async {
    return await getTemporaryDirectory();
  }

  static void registerAppFont() {
    var fontNameMapping = Map<String, String>();
    fontNameMapping["MyFontName"] = "Doppio One";
    VideoUtil.tempDirectory.then((tempDirectory) {
      setFontDirectory(tempDirectory.path, fontNameMapping);
      setEnvironmentVariable(
          "FFREPORT",
          "file=" +
              new File(tempDirectory.path + "/" + today() + "-ffreport.txt")
                  .path);
    });
  }

  static const String ASSET_1 = "pyramid.jpg";
  static const String ASSET_2 = "colosseum.jpg";
  static const String FONT_ASSET_1 = "doppioone_regular.ttf";
  static const String FONT_ASSET_2 = "truenorg.otf";

  static void prepareAssets() async {
    await VideoUtil.assetToFile(ASSET_1);
    await VideoUtil.assetToFile(ASSET_2);
    await VideoUtil.assetToFile(FONT_ASSET_1);
    await VideoUtil.assetToFile(FONT_ASSET_2);
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
  SubtitleTab(this.videoPath, this.strPath);
  String videoPath;
  String strPath;
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
    VideoUtil.assetPath(VideoUtil.ASSET_1).then((img1Path) {
      VideoUtil.assetPath(VideoUtil.ASSET_2).then((img2Path) {
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

            showCreateProgressDialog();

            String ffmpegCommand =
                "-y -i ${videoPath} -i ${img1Path} -filter_complex overlay=W-w:H-h -c:v mpeg4 ${videoFile.path}";

            _state = _State.CREATING;

            executeAsyncFFmpeg(ffmpegCommand,
                (CompletedFFmpegExecution execution) {
              ffprint("FFmpeg process exited with rc ${execution.returnCode}.");

              hideProgressDialog();

              if (execution.returnCode == 0) {
                ffprint("Create completed successfully; burning subtitles.");

                String burnSubtitlesCommand =
                    "-y -i ${videoFile.path} -vf subtitles=$strPath:force_style='Fontname=Trueno' -c:v mpeg4 ${videoWithSubtitlesFile.path}";
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
                    ffprint(
                        "Burn subtitles completed successfully; playing video.");
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
              }
            }).then((executionId) {
              _executionId = executionId;
              ffprint(
                  "Async FFmpeg process started with arguments '$ffmpegCommand' and executionId $executionId.");
            });
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
    Directory documentsDirectory = await VideoUtil.documentsDirectory;
    // 画像から作成した動画の保存場所
    return new File("${documentsDirectory.path}/$video");
  }

  Future<File> getVideoWithSubtitlesFile() async {
    final String video = "video-with-subtitles.mp4";
    Directory documentsDirectory = await VideoUtil.documentsDirectory;
    // 動画に字幕をつけた動画の保存場所
    return new File("${documentsDirectory.path}/$video");
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
