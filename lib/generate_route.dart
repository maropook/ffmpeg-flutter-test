import 'package:ffmpeg_flutter_test/avatar_detail_home.dart';
import 'package:ffmpeg_flutter_test/avatar_import_home.dart';
import 'package:ffmpeg_flutter_test/route_args.dart';
import 'package:flutter/material.dart';

const String initialRoute = '/';

Route<dynamic>? generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/avatar_detail':
      final AvatarDetailHomeArgs args =
          settings.arguments! as AvatarDetailHomeArgs;
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        return AvatarDetailHomeWidget(args);
      });
    case '/avatar_import':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        return const AvatarImportHomeWidget();
      });
  }
}
