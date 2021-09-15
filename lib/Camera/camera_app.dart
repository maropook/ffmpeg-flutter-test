import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CameraAppSmall extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddImageFille>(
        create: (_) => AddImageFille(),
        child: Consumer<AddImageFille>(builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Image Picker Sample'),
            ),
            body: Center(
              child: GestureDetector(
                child: SizedBox(
                  width: 100,
                  height: 160,
                  child: model.imageFile != null
                      ? Image.file(model.imageFile!)
                      : Container(color: Colors.grey),
                ),
                onTap: () async {
                  await model.pickImage();
                },
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await model.pickImage();
              },
              child: Icon(Icons.add_a_photo),
            ),
          );
        }));
  }
}

class AddImageFille extends ChangeNotifier {
  File? imageFile;

  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera); //gallery

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      notifyListeners();
    }
  }
}
