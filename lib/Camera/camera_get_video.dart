import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class CameraToVideo extends StatefulWidget {
  @override
  _CameraToVideo createState() => _CameraToVideo();
}

class _CameraToVideo extends State<CameraToVideo> {
  File? _image;
  final picker = ImagePicker();

  Future _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future _getImageNow() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera); //gallery

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future _getVideoNow() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future _getVideo() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("動画を取得し，再生"),
      ),
      body: Center(
        child:
            _image == null ? Text('No image selected.') : Image.file(_image!),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'selectvideo',
            onPressed: _getImage,
            child: Icon(Icons.image),
          ),
          FloatingActionButton(
            heroTag: 'getvideonow',
            onPressed: _getImageNow,
            child: Icon(Icons.camera_alt),
          ),
          FloatingActionButton(
              heroTag: 'selectcamera',
              onPressed: _getVideo,
              child: Icon(Icons.slow_motion_video)),
          FloatingActionButton(
            heroTag: 'getcameranow',
            onPressed: _getVideoNow,
            child: Icon(Icons.video_call),
          ),
        ],
      ),
    );
  }
}
