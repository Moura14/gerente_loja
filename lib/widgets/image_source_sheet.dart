import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageSourceSheet extends StatelessWidget {
  final Function(File) onImageSelected;
  ImageSourceSheet({this.onImageSelected});
  //const ImageSourceSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void imageSelected(File image) async {
      if (image != null) {
        File croppedImage = await ImageCropper.cropImage(
          sourcePath: image.path,
        );
        onImageSelected(croppedImage);
      }
    }

    return BottomSheet(
        onClosing: () {},
        builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FlatButton(
                  onPressed: () async {
                    File image =
                        await ImagePicker.pickImage(source: ImageSource.camera);
                    imageSelected(image);
                  },
                  child: Text("Câmera"),
                ),
                FlatButton(
                    onPressed: () async {
                      File image = await ImagePicker.pickImage(
                          source: ImageSource.gallery);
                      imageSelected(image);
                    },
                    child: Text("Galeria"))
              ],
            ));
  }
}
