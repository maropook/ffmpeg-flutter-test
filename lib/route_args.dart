import 'package:ffmpeg_flutter_test/avatar.dart';

class AvatarDetailHomeArgs {
  AvatarDetailHomeArgs(this.avatar, this.selectedAvatar);

  final Avatar avatar;
  final Avatar selectedAvatar;
}

class AvatarListHomeArgs {
  AvatarListHomeArgs(this.avatar);

  final Avatar avatar;
}
