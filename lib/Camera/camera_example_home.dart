import 'dart:async';
import 'dart:io';
import 'package:ffmpeg_flutter_test/ffmpeg/flutter_ffmpeg_api_wrapper.dart';
import 'package:ffmpeg_flutter_test/ffmpeg/ui.dart';
import 'package:flutter_ffmpeg/completed_ffmpeg_execution.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:video_player/video_player.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;
//非同期処理用ライブラリ
import 'dart:async';
//アプリがファイルを保存可能な場所を取得するライブラリ
import 'package:path_provider/path_provider.dart';

//出力するテキストファイル名
final _fileName = 'editTextField.txt';

class CameraExampleHome extends StatefulWidget {
  @override
  _CameraExampleHomeState createState() {
    return _CameraExampleHomeState();
  }
}

/// Returns a suitable camera icon for [direction].
IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
    default:
      throw ArgumentError('Unknown lens direction');
  }
}

void logError(String code, String? message) {
  if (message != null) {
    print('Error: $code\nError Message: $message');
  } else {
    print('Error: $code');
  }
}

class _CameraExampleHomeState extends State<CameraExampleHome>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController? controller;
  XFile? imageFile;
  XFile? videoFile;
  VideoPlayerController? videoController;
  VoidCallback? videoPlayerListener;
  bool enableAudio = true;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _currentExposureOffset = 0.0;
  late AnimationController _flashModeControlRowAnimationController;
  late Animation<double> _flashModeControlRowAnimation;
  late AnimationController _exposureModeControlRowAnimationController;
  late Animation<double> _exposureModeControlRowAnimation;
  late AnimationController _focusModeControlRowAnimationController;
  late Animation<double> _focusModeControlRowAnimation;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentScale = 1.0;
  double _baseScale = 1.0;

  // Counting pointers (number of user fingers on screen)
  int _pointers = 0;

  String _out = '';
  String strPath = '';
  String lastWords = "　";
  String lastError = '';
  String lastStatus = '';
  stt.SpeechToText speech = stt.SpeechToText();

  bool flug = false;
  late Timer _timer;
  late int _currentSeconds;

  int strcount = 0;

  Timer countTimer() {
    return Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (!flug) {
          timer.cancel();
        } else {
          setState(() {
            _currentSeconds = _currentSeconds + 1;
            strcount = strcount + 1;

            getFilePath().then((File file) {
              file.writeAsString(
                '${strcount}\n${timerString(_currentSeconds)} --> ${timerString(_currentSeconds + 1)}\n${lastWords}\n\n',
                mode: FileMode.append,
              );
            });
          });
        }
      },
    );
  }

  Future<void> _speak() async {
    getFilePath().then((File file) {
      file.writeAsString("");
      //ファイルの初期化
    });

    bool available = await speech.initialize(
        onError: errorListener, onStatus: statusListener);
    if (available) {
      flug = true;
      if (!_timer.isActive) {
        setState(() {
          _timer = countTimer();
        });
      }

      speech.listen(
        onResult: resultListener,
        localeId: "Japanese",
      );
    } else {
      print("The user has denied the use of speech recognition.");
    }
  }

  //ファイルの出力処理

  //ファイルの読み込みと変数への格納処理
  void loadButton() async {
    setState(() {
      load().then((String value) {
        setState(() {
          _out = value;
          print(_out);
        });
      });
    });
  }

  void loadButtonStr() async {
    setState(() {
      loadStr().then((String value) {
        setState(() {
          strPath = value;
        });
      });
    });
  }

  Future<void> _stop() async {
    loadButton();
    loadButtonStr();

    //タイマーを止める
    if (_timer.isActive) {
      _timer.cancel();
    }

    speech.stop();
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      lastWords = '${result.recognizedWords}';
    });
  }

  void errorListener(SpeechRecognitionError error) {
    setState(() {
      lastError = '${error.errorMsg} - ${error.permanent}';
    });
  }

  void statusListener(String status) {
    setState(() {
      lastStatus = '$status';
      print(lastStatus);
    });
  }

  Widget _timeStr() {
    return Text(
      timerString(_currentSeconds),
      // style: TextStyle(fontSize: 32, color: Colors.black),
    );
  }

  String timerString(int leftSeconds) {
    // 00:00:06,000
    final minutes = (leftSeconds / 60).floor().toString().padLeft(2, '0');
    final seconds = (leftSeconds % 60).floor().toString().padLeft(2, '0');
    return '00:$minutes:${seconds},000';
  }

  @override
  void initState() {
    super.initState();
    final workMinuts = 0;
    _currentSeconds = workMinuts * 60;

    _timer = countTimer();

    _ambiguate(WidgetsBinding.instance)?.addObserver(this);

    _flashModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _flashModeControlRowAnimation = CurvedAnimation(
      parent: _flashModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
    _exposureModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _exposureModeControlRowAnimation = CurvedAnimation(
      parent: _exposureModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
    _focusModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _focusModeControlRowAnimation = CurvedAnimation(
      parent: _focusModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
  }

  @override
  void dispose() {
    _ambiguate(WidgetsBinding.instance)?.removeObserver(this);
    _flashModeControlRowAnimationController.dispose();
    _exposureModeControlRowAnimationController.dispose();
    super.dispose();
    _timer.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Camera example'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    Center(
                      child: _cameraPreviewWidget(),
                    ),
                    Image.asset('assets/pyramid.jpg'),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color:
                      controller != null && controller!.value.isRecordingVideo
                          ? Colors.redAccent
                          : Colors.grey,
                  width: 3.0,
                ),
              ),
            ),
          ),
          _captureControlRowWidget(),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _cameraTogglesRowWidget(),
                _thumbnailWidget(),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  IconButton(icon: Icon(Icons.add), onPressed: loadButton),
                  _timeStr(),
                  Text(
                    ' ステータス : ${lastStatus}',
                  ),
                ],
              ),
              Text(
                ' 変換文字:${lastWords}',
              ),
            ],
          ),
        ],
      ),
      floatingActionButton:
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton(
            onPressed: () {
              onVideoRecordButtonPressed();
              _speak();
            },
            child: Icon(Icons.play_arrow)),
        FloatingActionButton(
            onPressed: () {
              _stop();
              onStopButtonPressed();
            },
            child: Icon(Icons.stop)),
        FloatingActionButton(onPressed: () {
          print(videoFile!.path);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MainffmpegPage(videoFile!.path, strPath)));
        }),
      ]),
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      if (cameras.isEmpty) {
        return const Text('No camera found');
      } else {
        onNewCameraSelected(cameras.first);
        return Listener(
          onPointerDown: (_) => _pointers++,
          onPointerUp: (_) => _pointers--,
          child: CameraPreview(
            controller!,
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onScaleStart: _handleScaleStart,
                onScaleUpdate: _handleScaleUpdate,
                onTapDown: (details) => onViewFinderTap(details, constraints),
              );
            }),
          ),
        );
      }
    } else {
      return Listener(
        onPointerDown: (_) => _pointers++,
        onPointerUp: (_) => _pointers--,
        child: CameraPreview(
          controller!,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onScaleStart: _handleScaleStart,
              onScaleUpdate: _handleScaleUpdate,
              onTapDown: (details) => onViewFinderTap(details, constraints),
            );
          }),
        ),
      );
    }
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (controller == null || _pointers != 2) {
      return;
    }

    _currentScale = (_baseScale * details.scale)
        .clamp(_minAvailableZoom, _maxAvailableZoom);

    await controller!.setZoomLevel(_currentScale);
  }

  /// Display the thumbnail of the captured image or video.
  Widget _thumbnailWidget() {
    final VideoPlayerController? localVideoController = videoController;

    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            localVideoController == null && imageFile == null
                ? Container()
                : SizedBox(
                    child: (localVideoController == null)
                        ? Image.file(File(imageFile!.path))
                        : Container(
                            child: Center(
                              child: AspectRatio(
                                  aspectRatio:
                                      localVideoController.value.size != null
                                          ? localVideoController
                                              .value.aspectRatio
                                          : 1.0,
                                  child: VideoPlayer(localVideoController)),
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.pink)),
                          ),
                    width: 64.0,
                    height: 64.0,
                  ),
          ],
        ),
      ),
    );
  }

  //
  /// Display the control bar with buttons to take pictures and record videos.
  Widget _captureControlRowWidget() {
    final CameraController? cameraController = controller;

    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (cameraController != null &&
                cameraController.value.isInitialized &&
                !cameraController.value.isRecordingVideo) {
              onVideoRecordButtonPressed();
            } else {
              onStopButtonPressed();
            }
          },
          child: Icon(
            Icons.circle_outlined,
            size: 80,
            color: cameraController != null &&
                    cameraController.value.isInitialized &&
                    !cameraController.value.isRecordingVideo
                ? Colors.grey
                : Colors.grey,
          ),
        ),
        GestureDetector(
          onTap: () {
            if (cameraController != null &&
                cameraController.value.isInitialized &&
                !cameraController.value.isRecordingVideo) {
              onVideoRecordButtonPressed();
            } else {
              onStopButtonPressed();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Icon(
              Icons.circle,
              size: 70,
              color: cameraController != null &&
                      cameraController.value.isInitialized &&
                      !cameraController.value.isRecordingVideo
                  ? Colors.black
                  : Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).
  Widget _cameraTogglesRowWidget() {
    final List<Widget> toggles = <Widget>[];

    final onChanged = (CameraDescription? description) {
      if (description == null) {
        return;
      }
      onNewCameraSelected(description);
    };

    if (cameras.isEmpty) {
      return const Text('No camera found');
    } else {
      for (CameraDescription cameraDescription in cameras) {
        toggles.add(
          SizedBox(
            width: 90.0,
            child: RadioListTile<CameraDescription>(
              title: Icon(getCameraLensIcon(cameraDescription.lensDirection)),
              groupValue: controller?.description,
              value: cameraDescription,
              onChanged:
                  controller != null && controller!.value.isRecordingVideo
                      ? null
                      : onChanged,
            ),
          ),
        );
      }
    }
    return Row(children: toggles);
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    // ignore: deprecated_member_use
    _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(message)));
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }

    final CameraController cameraController = controller!;

    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller!.dispose();
    }

    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: enableAudio,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) setState(() {});
      if (cameraController.value.hasError) {
        showInSnackBar(
            'Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
      await Future.wait([
        cameraController
            .getMinExposureOffset()
            .then((value) => _minAvailableExposureOffset = value),
        cameraController
            .getMaxExposureOffset()
            .then((value) => _maxAvailableExposureOffset = value),
        cameraController
            .getMaxZoomLevel()
            .then((value) => _maxAvailableZoom = value),
        cameraController
            .getMinZoomLevel()
            .then((value) => _minAvailableZoom = value),
      ]);
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onVideoRecordButtonPressed() {
    //start video record

    _speak().then((_) {
      _speak().then((_) {
        if (mounted) setState(() {});
      });
    });

    startVideoRecording().then((_) {
      if (mounted) setState(() {});
    });
  }

  void onStopButtonPressed() {
    _stop().then((_) {
      if (mounted) setState(() {});
    });
    //stop video record
    stopVideoRecording().then((file) {
      if (mounted) setState(() {});
      if (file != null) {
        showInSnackBar('saved Video recorded to ${file.path}');
        videoFile = file;
        _startVideoPlayer();
      }
    });
  }

  Future<void> startVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return;
    }

    if (cameraController.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return;
    }

    try {
      await cameraController.startVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return;
    }
  }

  Future<XFile?> stopVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      return cameraController.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  Future<void> _startVideoPlayer() async {
    if (videoFile == null) {
      return;
    }

    final VideoPlayerController vController =
        VideoPlayerController.file(File(videoFile!.path));

    print(videoFile!.path);

    videoPlayerListener = () {
      if (videoController != null && videoController!.value.size != null) {
        // Refreshing the state to update video player with the correct ratio.
        if (mounted) setState(() {});
        videoController!.removeListener(videoPlayerListener!);
      }
    };
    vController.addListener(videoPlayerListener!);
    await vController.setLooping(false);
    await vController.initialize();
    await videoController?.dispose();
    if (mounted) {
      setState(() {
        imageFile = null;
        videoController = vController;
      });
    }
    await vController.play();
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }
}

class CameraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CameraExampleHome(),
    );
  }
}

List<CameraDescription> cameras = [];

Future<void> main() async {
  // Fetch the available cameras before initializing the app.
  try {
    WidgetsFlutterBinding.ensureInitialized();
    print('tryカメラ');
    cameras = await availableCameras();
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }
  runApp(CameraApp());
}

/// This allows a value of type T or T? to be treated as a value of type T?.
///
/// We use this so that APIs that have become non-nullable can still be used
/// with `!` and `?` on the stable branch.
// TODO(ianh): Remove this once we roll stable in late 2021.
T? _ambiguate<T>(T? value) => value;

Future<File> getFilePath() async {
  final directory = await getTemporaryDirectory();

  return File(directory.path + '/' + _fileName);
  // return File(
  //     '/Users/hasegawaitsuki/ghq/github.com/maropook/ffmpeg_flutter_test/assets/subtitle.srt');
}

//テキストファイルの読み込み
Future<String> load() async {
  final file = await getFilePath();
  return file.readAsString();
}

Future<String> loadStr() async {
  final file = await getFilePath();
  return file.path;
}
