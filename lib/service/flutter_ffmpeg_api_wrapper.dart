import 'dart:async';

import 'package:flutter_ffmpeg/ffmpeg_execution.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_ffmpeg/media_information.dart';
import 'package:flutter_ffmpeg/statistics.dart';

final FlutterFFmpegConfig _flutterFFmpegConfig = new FlutterFFmpegConfig();
final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
final FlutterFFprobe _flutterFFprobe = new FlutterFFprobe();

void enableStatisticsCallback(StatisticsCallback? callback) {
  _flutterFFmpegConfig.enableStatisticsCallback(callback);
}

Future<int> executeAsyncFFmpeg(
    String command, ExecuteCallback executeCallback) async {
  return await _flutterFFmpeg.executeAsync(command, executeCallback);
}

Future<void> cancelExecution(int executionId) async {
  return await _flutterFFmpeg.cancelExecution(executionId);
}

Future<void> disableRedirection() async {
  return await _flutterFFmpegConfig.disableRedirection();
}

Future<void> setLogLevel(int logLevel) async {
  return await _flutterFFmpegConfig.setLogLevel(logLevel);
}

Future<void> resetStatistics() async {
  return await _flutterFFmpegConfig.resetStatistics();
}

Future<void> setFontDirectory(
    String fontDirectory, Map<String, String> fontNameMap) async {
  return await _flutterFFmpegConfig.setFontDirectory(
      fontDirectory, fontNameMap);
}

Future<void> setEnvironmentVariable(
    String variableName, String variableValue) async {
  return await _flutterFFmpegConfig.setEnvironmentVariable(
      variableName, variableValue);
}
