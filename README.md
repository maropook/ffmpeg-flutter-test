# ffmpeg_flutter_test

```shell

$ flutter --version

Flutter 2.6.0-0.0.pre • channel dev •
https://github.com/flutter/flutter.git
Framework • revision 83b9e99cfb (3 weeks ago) • 2021-08-23 19:03:21
+0200
Engine • revision d5adde01dd
Tools • Dart 2.15.0 (build 2.15.0-42.0.dev)

````
<img width="199" alt="スクリーンショット 2021-09-15 18 41 33" src="https://user-images.githubusercontent.com/84751550/133410374-c1dc793a-f41a-45f3-8f35-1c8bf9ea6eed.png">

***

#### ffmpeg 公式サンプル/flutter_ffmpeg'

videoタブでencodeを押すと，assets配下にある画像3つを使って動画を作ってくれる

SUBTITLEタブではassets配下にあるフォントと字幕をstrファイルを合成して字幕付き動画を作ってくれる

***

#### api 書籍管理 /https,dio

djangoで作った本の情報を管理する自作apiと通信できる

***

#### 動画再生するだけ/video_player

ネットに上がっている一つの動画を再生するだけ

***

#### speechtotext/speech_to_text

しゃべったことをテキストにしてくれる

***

#### 録音・再生/audio_recoder_2

録音と再生ができる

***

## 以下実機ビルド必須!

#### カメラ(写真が撮れるだけ)/camera

写真が撮れて，それを表示する

***

#### 公式カメラ，動画撮影,/camera,video_player

写真と動画が撮れる．フラッシュなど色々オプション付き

***




## エラーメモ
実機ビルド　❯❯
flutter build ios

ios 14以上ではできないと思ったがreleaseにしたらいける

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.3'
    end
  end
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end

pod install --repo-update

ffmpeg使用

xcodeでframeworkのiosのversionを9.3以上にしておく
any simulator sdk をarm64にしておく

release.xconfig
#include "Pods/Target Support Files/Pods-Runner/Pods-Runner.release.xcconfig"
#include "Pods/Target Support Files/Pods-Runner/Pods-Runner.profile.xcconfig"

debug.xconfig
#include "Pods/Target Support Files/Pods-Runner/Pods-Runner.debug.xcconfig"

xcodeのプロジェクトの名前をユニークにし,teamに自分のappleIDを追加しておく

