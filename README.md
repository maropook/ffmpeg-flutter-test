
## ffmpeg_flutter_test

__できること__
  
- dio と http
- カメラ使った動画,写真撮影
- ffmpegでの動画編集
- SpeechToText
- マイク入力,録音

__開発環境__
  
* OS: `macOS Big Sur v11.5.2`

```shell

$ flutter --version

Flutter 2.6.0-0.0.pre • channel dev •
https://github.com/flutter/flutter.git
Framework • revision 83b9e99cfb (3 weeks ago) • 2021-08-23 19:03:21
+0200
Engine • revision d5adde01dd
Tools • Dart 2.15.0 (build 2.15.0-42.0.dev)

````

***

<img width="186" alt="スクリーンショット 2021-09-15 18 41 33" src="https://user-images.githubusercontent.com/84751550/133410374-c1dc793a-f41a-45f3-8f35-1c8bf9ea6eed.png"><img width="186" alt="スクリーンショット 2021-09-15 19 36 22" src="https://user-images.githubusercontent.com/84751550/133418558-fd8d9546-d130-41ee-8725-4026b1c55419.png"><img width="186" alt="スクリーンショット 2021-09-15 19 51 40" src="https://user-images.githubusercontent.com/84751550/133420699-d61606fa-f31d-4e54-ae25-3a14199979e7.png"><img width="186" alt="スクリーンショット 2021-09-15 19 31 20" src="https://user-images.githubusercontent.com/84751550/133417918-53697c2b-8124-4574-86e8-a78106a85982.png">
<img width="186" alt="スクリーンショット 2021-09-15 19 31 55" src="https://user-images.githubusercontent.com/84751550/133417921-f581c9b8-a816-4085-b25e-96b7c4de8e8c.png"><img width="186" alt="スクリーンショット 2021-09-15 19 31 41" src="https://user-images.githubusercontent.com/84751550/133417902-dcb88563-efbe-4835-8568-5b9f1d60501d.png"><img width="181" alt="スクリーンショット 2021-09-15 19 31 07" src="https://user-images.githubusercontent.com/84751550/133417912-889e7142-0b05-4ca0-bb0e-26a6ea6d799e.png"><img width="186" alt="スクリーンショット 2021-09-15 19 31 50" src="https://user-images.githubusercontent.com/84751550/133417916-7a71c0c6-80ad-498b-a416-b531d9dc7f9c.png">

***

#### トップページ

以下6つの機能が使える．一覧ページ

***

#### 【公式サンプル】ffmpeg /flutter_ffmpeg

videoタブでencodeを押すと，assets配下にある画像3つを使って動画を作ってくれる

SUBTITLEタブではassets配下にあるフォントと字幕をstrファイルを合成して字幕付き動画を作ってくれる

***

#### api 書籍管理 /https,dio

djangoで作った本の情報を管理する自作apiと通信できる

***

#### speechtotext/speech_to_text

しゃべったことをテキストにしてくれる

***

#### 録音・再生/audio_recoder_2

録音と再生ができる


***

## 以下実機ビルド必須!

#### カメラ,写真が撮れる，画像が選べる/camera

撮った写真，アルバム内の写真を選択し，表示させることができる

***

#### 動画再生する,録画する/video_player

撮影した動画，またはアルバム内の動画を選択し，表示させれる

- imagepicker
- provider

***

#### 【公式サンプル】カメラ，動画撮影/camera,video_player

写真と動画が撮れる．フラッシュなど色々オプション付き

***



## plugin

### flutter_audio_recorder

__依存関係__

flutter_audio_recorder

audio_players

path_provider


__改善が必要__

時間内に記録する視覚的進歩

録音ボタンへのオーディオピッチアニメーション

別のタイルをテープで貼り付けるときは、他の拡張タイルを閉じる必要がある

オーディオの一時停止および再開機能

***

## エラーメモ
実機ビルド　❯❯
flutter build ios

ios 14以上ではできないと思ったがreleaseにしたらいける

pod install --repo-update

ffmpeg使用

xcodeでframeworkのiosのversionを9.3以上にしておく

any simulator sdk をarm64にしておく

Podfileに以下を追記

```

def flutter_install_plugin_pods(application_path = nil, relative_symlink_dir, platform)

  application_path ||= File.dirname(defined_in_file.realpath) if self.respond_to?(:defined_in_file)
  raise 'Could not find application path' unless application_path

  symlink_dir = File.expand_path(relative_symlink_dir, application_path)
  system('rm', '-rf', symlink_dir) # Avoid the complication of dependencies like FileUtils.

  symlink_plugins_dir = File.expand_path('plugins', symlink_dir)
  system('mkdir', '-p', symlink_plugins_dir)

  plugins_file = File.join(application_path, '..', '.flutter-plugins-dependencies')
  plugin_pods = flutter_parse_plugins_file(plugins_file, platform)
  plugin_pods.each do |plugin_hash|
    plugin_name = plugin_hash['name']
    plugin_path = plugin_hash['path']
    if (plugin_name && plugin_path)
      symlink = File.join(symlink_plugins_dir, plugin_name)
      File.symlink(plugin_path, symlink)

      if plugin_name == 'flutter_ffmpeg'
        pod 'flutter_ffmpeg/full-gpl-lts', :path => File.join(relative_symlink_dir, 'plugins', plugin_name, platform) #fll-gpl-tlsはffmpegの使いたい種類を追記
      else
        pod plugin_name, :path => File.join(relative_symlink_dir, 'plugins', plugin_name, platform)
      end
    end
  end
end

```

```

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

```

release.xconfig

```

#include "Pods/Target Support Files/Pods-Runner/Pods-Runner.release.xcconfig"

#include "Pods/Target Support Files/Pods-Runner/Pods-Runner.profile.xcconfig"

```
debug.xconfig

```

#include "Pods/Target Support Files/Pods-Runner/Pods-Runner.debug.xcconfig"

```

xcodeのプロジェクトの名前をユニークにし,teamに自分のappleIDを追加しておく

