# ffmpeg_flutter_test

ffmpeg-------------------

videoタブでencodeを押すと，assets配下にある画像3つを使って動画を作ってくれる

SUBTITLEタブではassets配下にあるフォントと字幕をかけるstrファイルを合成してくれる





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

xcodeでframeworkのiosのversionを9.3にしておく
any simulator sdk をarm64にしておく

release.xconfig
#include "Pods/Target Support Files/Pods-Runner/Pods-Runner.release.xcconfig"
#include "Pods/Target Support Files/Pods-Runner/Pods-Runner.profile.xcconfig"

debug.xconfig
#include "Pods/Target Support Files/Pods-Runner/Pods-Runner.debug.xcconfig"

xcodeのプロジェクトの名前をユニークにしておく
