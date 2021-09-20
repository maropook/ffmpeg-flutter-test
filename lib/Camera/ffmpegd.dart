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
