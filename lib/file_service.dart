import 'dart:async';
import 'dart:io'; // 追加
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class FileController {
  // ドキュメントのパスを取得
  static Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  String pass = "aa";
  // 画像をドキュメントへ保存する。
  // 引数にはカメラ撮影時にreturnされるFileオブジェクトを持たせる。
  static Future saveLocalImage(File image) async {
    final path = await localPath;
    final imagePath = '$path/image.png';
    File imageFile = File(imagePath);
    // カメラで撮影した画像は撮影時用の一時的フォルダパスに保存されるため、
    // その画像をドキュメントへ保存し直す。
    var savedFile = await imageFile.writeAsBytes(await image.readAsBytes());
    // もしくは
    // var savedFile = await image.copy(imagePath);
    // でもOK

    return savedFile;
  }

  static Future loadLocalImage() async {
    final path = await localPath;
    final imagePath = '$path/image.png';
    return File(imagePath);
  }
}

class ImagePickerView extends StatefulWidget {
  @override
  State createState() {
    return ImagePickerViewState();
  }
}

class ImagePickerViewState extends State {
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ImagePicker'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (imageFile == null)
                  ? Icon(Icons.no_sim)
                  : Image.memory(
                      imageFile!.readAsBytesSync(),
                      height: 100.0,
                      width: 100.0,
                    ),
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: RaisedButton(
                    child: Text('ライブラリから選択'),
                    onPressed: () {
                      _getAndSaveImageFromDevice(ImageSource.gallery);
                    },
                  )),
            ],
          ),
        ));
  }

  final picker = ImagePicker();
// カメラまたはライブラリから画像を取得
// void _getImageFromDevice(ImageSource source) async { //メソッド名変更
  void _getAndSaveImageFromDevice(ImageSource source) async {
    // 撮影/選択したFileが返ってくる
    final imageFile = await picker.pickImage(source: source);
    // 撮影せずに閉じた場合はnullになる
    if (imageFile == null) {
      return;
    }

    await FileController.saveLocalImage(File(imageFile.path)); //追加

    setState(() {
      this.imageFile = File(imageFile.path);
      //this.imageFile = savedFile; //変更
    });
  }
}
