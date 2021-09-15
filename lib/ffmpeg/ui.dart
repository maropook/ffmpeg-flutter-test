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

import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/log_level.dart';
import 'package:ffmpeg_flutter_test/ffmpeg/abstract.dart';
import 'package:ffmpeg_flutter_test/ffmpeg/audio_tab.dart';
import 'package:ffmpeg_flutter_test/ffmpeg/command_tab.dart';
import 'package:ffmpeg_flutter_test/ffmpeg/concurrent_execution_tab.dart';
import 'package:ffmpeg_flutter_test/ffmpeg/decoration.dart';
import 'package:ffmpeg_flutter_test/ffmpeg/flutter_ffmpeg_api_wrapper.dart';
import 'package:ffmpeg_flutter_test/ffmpeg/https_tab.dart';
import 'package:ffmpeg_flutter_test/ffmpeg/pipe_tab.dart';
import 'package:ffmpeg_flutter_test/ffmpeg/player.dart';
import 'package:ffmpeg_flutter_test/ffmpeg/progress_modal.dart';
import 'package:ffmpeg_flutter_test/ffmpeg/subtitle_tab.dart';
import 'package:ffmpeg_flutter_test/ffmpeg/test_api.dart';
import 'package:ffmpeg_flutter_test/ffmpeg/vid_stab_tab.dart';
import 'package:ffmpeg_flutter_test/ffmpeg/video_tab.dart';
import 'package:ffmpeg_flutter_test/ffmpeg/video_util.dart';

GlobalKey _globalKey = GlobalKey();

class MainffmpegPage extends StatefulWidget {
  @override
  FlutterFFmpegExampleAppState createState() => FlutterFFmpegExampleAppState();
}

class DecoratedTabBar extends StatelessWidget implements PreferredSizeWidget {
  DecoratedTabBar({required this.tabBar, required this.decoration});

  final TabBar tabBar;
  final BoxDecoration decoration;

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Container(decoration: decoration)),
        tabBar,
      ],
    );
  }
}

class FlutterFFmpegExampleAppState extends State<MainffmpegPage>
    with TickerProviderStateMixin
    implements RefreshablePlayerDialogFactory {
  // COMMON COMPONENTS
  late TabController _controller;
  ProgressModal? progressModal;

  // COMMAND TAB COMPONENTS
  CommandTab commandTab = CommandTab();

  // VIDEO TAB COMPONENTS
  VideoTab videoTab = VideoTab();

  // HTTPS TAB COMPONENTS
  HttpsTab httpsTab = HttpsTab();

  // AUDIO TAB COMPONENTS
  AudioTab audioTab = AudioTab();

  // SUBTITLE TAB COMPONENTS
  SubtitleTab subtitleTab = SubtitleTab();

  // VIDSTAB TAB COMPONENTS
  VidStabTab vidStabTab = VidStabTab();

  // PIPE TAB COMPONENTS
  PipeTab pipeTab = PipeTab();

  // CONCURRENT EXECUTION TAB COMPONENTS
  ConcurrentExecutionTab concurrentExecutionTab = ConcurrentExecutionTab();

  void refresh() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    commandTab.init(this);
    videoTab.init(this);
    httpsTab.init(this);
    audioTab.init(this);
    subtitleTab.init(this);
    vidStabTab.init(this);
    pipeTab.init(this);
    concurrentExecutionTab.init(this);

    _controller = TabController(length: 8, vsync: this);
    _controller.addListener(() {
      if (_controller.indexIsChanging) {
        switch (_controller.index) {
          case 0:
            commandTab.setActive();
            break;
          case 1:
            videoTab.setActive();
            break;
          case 2:
            httpsTab.setActive();
            break;
          case 3:
            audioTab.setActive();
            break;
          case 4:
            subtitleTab.setActive();
            break;
          case 5:
            vidStabTab.setActive();
            break;
          case 6:
            pipeTab.setActive();
            break;
          case 7:
            concurrentExecutionTab.setActive();
            break;
        }
      }
    });

    Test.testCommonApiMethods();
    Test.testParseArguments();

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
        bottomNavigationBar: Material(
          child: DecoratedTabBar(
            tabBar: TabBar(
              isScrollable: true,
              tabs: <Tab>[
                Tab(text: "COMMAND"),
                Tab(text: "VIDEO"),
                Tab(text: "HTTPS"),
                Tab(text: "AUDIO"),
                Tab(text: "SUBTITLE"),
                Tab(text: "VID.STAB"),
                Tab(text: "PIPE"),
                Tab(text: "CONCURRENT EXECUTION")
              ],
              controller: _controller,
              labelColor: selectedTabColor,
              unselectedLabelColor: unSelectedTabColor,
            ),
            decoration: tabBarDecoration,
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
                  child: TextField(
                    controller: commandTab.getCommandText(),
                    decoration: inputDecoration('Enter command'),
                    style: textFieldStyle,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: InkWell(
                    onTap: () => commandTab.runFFmpeg(),
                    child: Container(
                      width: 130,
                      height: 38,
                      decoration: buttonDecoration,
                      child: Center(
                        child: Text(
                          'RUN FFMPEG',
                          style: buttonTextStyle,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: InkWell(
                    onTap: () => commandTab.runFFprobe(),
                    child: Container(
                      width: 130,
                      height: 38,
                      decoration: buttonDecoration,
                      child: Center(
                        child: Text(
                          'RUN FFPROBE',
                          style: buttonTextStyle,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                      alignment: Alignment(-1.0, -1.0),
                      margin: EdgeInsets.all(20.0),
                      padding: EdgeInsets.all(4.0),
                      decoration: outputDecoration,
                      child: SingleChildScrollView(
                          reverse: true,
                          child: Text(commandTab.getOutputText()))),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 40),
                    child: Container(
                      width: 200,
                      alignment: Alignment.center,
                      decoration: dropdownButtonDecoration,
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                        style: dropdownButtonTextStyle,
                        value: videoTab.getSelectedCodec(),
                        items: videoTab.getVideoCodecList(),
                        onChanged: videoTab.changedVideoCodec,
                        iconSize: 0,
                        isExpanded: false,
                      )),
                    )),
                Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: InkWell(
                    onTap: () => videoTab.encodeVideo(),
                    child: Container(
                      width: 100,
                      height: 38,
                      decoration: buttonDecoration,
                      child: Center(
                        child: Text(
                          'ENCODE',
                          style: buttonTextStyle,
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
                      future: videoTab.getVideoFile(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          File file = snapshot.data as File;
                          return Container(
                              alignment: Alignment(0.0, 0.0),
                              child: EmbeddedPlayer(
                                  "${file.path.toString()}", videoTab));
                        } else {
                          return Container(
                            alignment: Alignment(0.0, 0.0),
                            decoration: videoPlayerFrameDecoration,
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
                  child: TextField(
                    controller: httpsTab.getUrlText(),
                    decoration: inputDecoration('Enter https url'),
                    style: textFieldStyle,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: InkWell(
                    onTap: () => httpsTab.runGetMediaInformation(),
                    child: Container(
                      width: 130,
                      height: 38,
                      decoration: buttonDecoration,
                      child: Center(
                        child: Text(
                          'GET INFO',
                          style: buttonTextStyle,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                      alignment: Alignment(-1.0, -1.0),
                      margin: EdgeInsets.all(20.0),
                      padding: EdgeInsets.all(4.0),
                      decoration: outputDecoration,
                      child: SingleChildScrollView(
                          reverse: true,
                          child: Text(httpsTab.getOutputText()))),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 40),
                    child: Container(
                      width: 200,
                      alignment: Alignment.center,
                      decoration: dropdownButtonDecoration,
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                        style: dropdownButtonTextStyle,
                        value: audioTab.getSelectedCodec(),
                        items: audioTab.getAudioCodecList(),
                        onChanged: audioTab.changedAudioCodec,
                        iconSize: 0,
                        isExpanded: false,
                      )),
                    )),
                Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: InkWell(
                    onTap: () => audioTab.encodeAudio(),
                    child: Container(
                      width: 100,
                      height: 38,
                      decoration: buttonDecoration,
                      child: Center(
                        child: Text(
                          'ENCODE',
                          style: buttonTextStyle,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                      alignment: Alignment(-1.0, -1.0),
                      margin: EdgeInsets.all(20.0),
                      padding: EdgeInsets.all(4.0),
                      decoration: outputDecoration,
                      child: SingleChildScrollView(
                          reverse: true,
                          child: Text(audioTab.getOutputText()))),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 80, bottom: 60),
                  child: InkWell(
                    onTap: () => subtitleTab.burnSubtitles(),
                    child: Container(
                      width: 180,
                      height: 38,
                      decoration: buttonDecoration,
                      child: Center(
                        child: Text(
                          'BURN SUBTITLES',
                          style: buttonTextStyle,
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
                              child:
                                  EmbeddedPlayer("${file.path}", subtitleTab));
                        } else {
                          return Container(
                            alignment: Alignment(0.0, 0.0),
                            decoration: videoPlayerFrameDecoration,
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    padding: EdgeInsets.all(4.0),
                    child: FutureBuilder(
                      future: vidStabTab.getVideoFile(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          File file = snapshot.data as File;
                          return Container(
                              alignment: Alignment(0.0, 0.0),
                              child: EmbeddedPlayer(
                                  "${file.path}", vidStabTab.videoController));
                        } else {
                          return Container(
                            alignment: Alignment(0.0, 0.0),
                            decoration: videoPlayerFrameDecoration,
                          );
                        }
                      },
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: InkWell(
                    onTap: () => vidStabTab.stabilizeVideo(),
                    child: Container(
                      width: 180,
                      height: 38,
                      decoration: buttonDecoration,
                      child: Center(
                        child: Text(
                          'STABILIZE VIDEO',
                          style: buttonTextStyle,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    padding: EdgeInsets.all(4.0),
                    child: FutureBuilder(
                      future: vidStabTab.getStabilizedVideoFile(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          File file = snapshot.data as File;
                          return Container(
                              alignment: Alignment(0.0, 0.0),
                              child: EmbeddedPlayer("${file.path}",
                                  vidStabTab.stabilizedVideoController));
                        } else {
                          return Container(
                            alignment: Alignment(0.0, 0.0),
                            decoration: videoPlayerFrameDecoration,
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: InkWell(
                    onTap: () => pipeTab.createVideo(),
                    child: Container(
                      width: 180,
                      height: 38,
                      decoration: buttonDecoration,
                      child: Center(
                        child: Text(
                          'CREATE',
                          style: buttonTextStyle,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    padding: EdgeInsets.all(4.0),
                    child: FutureBuilder(
                      future: pipeTab.getVideoFile(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          File file = snapshot.data as File;
                          return Container(
                              alignment: Alignment(0.0, 0.0),
                              child: EmbeddedPlayer("${file.path}", pipeTab));
                        } else {
                          return Container(
                            alignment: Alignment(0.0, 0.0),
                            decoration: videoPlayerFrameDecoration,
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                      child: InkWell(
                        onTap: () => concurrentExecutionTab.encodeVideo(1),
                        child: Container(
                          width: 64,
                          height: 38,
                          decoration: buttonDecoration,
                          child: Center(
                            child: Text(
                              'ENCODE 1',
                              style: buttonSmallTextStyle,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                      child: InkWell(
                        onTap: () => concurrentExecutionTab.encodeVideo(2),
                        child: Container(
                          width: 64,
                          height: 38,
                          decoration: buttonDecoration,
                          child: Center(
                            child: Text(
                              'ENCODE 2',
                              style: buttonSmallTextStyle,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                      child: InkWell(
                        onTap: () => concurrentExecutionTab.encodeVideo(3),
                        child: Container(
                          width: 64,
                          height: 38,
                          decoration: buttonDecoration,
                          child: Center(
                            child: Text(
                              'ENCODE 3',
                              style: buttonSmallTextStyle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: InkWell(
                        onTap: () => concurrentExecutionTab.runCancel(1),
                        child: Container(
                          width: 62,
                          height: 38,
                          decoration: buttonDecoration,
                          child: Center(
                            child: Text(
                              'CANCEL 1',
                              style: buttonSmallTextStyle,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: InkWell(
                        onTap: () => concurrentExecutionTab.runCancel(2),
                        child: Container(
                          width: 62,
                          height: 38,
                          decoration: buttonDecoration,
                          child: Center(
                            child: Text(
                              'CANCEL 2',
                              style: buttonSmallTextStyle,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: InkWell(
                        onTap: () => concurrentExecutionTab.runCancel(3),
                        child: Container(
                          width: 62,
                          height: 38,
                          decoration: buttonDecoration,
                          child: Center(
                            child: Text(
                              'CANCEL 3',
                              style: buttonSmallTextStyle,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: InkWell(
                        onTap: () => concurrentExecutionTab.runCancel(0),
                        child: Container(
                          width: 76,
                          height: 38,
                          decoration: buttonDecoration,
                          child: Center(
                            child: Text(
                              'CANCEL ALL',
                              style: buttonSmallTextStyle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                      alignment: Alignment(-1.0, -1.0),
                      margin: EdgeInsets.all(20.0),
                      padding: EdgeInsets.all(4.0),
                      decoration: outputDecoration,
                      child: SingleChildScrollView(
                          reverse: true,
                          child: Text(concurrentExecutionTab.getOutputText()))),
                )
              ],
            )
          ],
          controller: _controller,
        ));
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

  @override
  void dispose() {
    commandTab.dispose();
    super.dispose();
  }
}
