import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageAdd extends StatefulWidget {
  final File? image; // Add this property
  const ImageAdd({super.key, this.image}); // Update constructor

  @override
  State<ImageAdd> createState() => _ImageAddState();
}

class _ImageAddState extends State<ImageAdd> {
  List<XFile>? _mediaFileList;
  File? _image; // 이미지 담을 변수
  final ImagePicker picker = ImagePicker();

  Widget _buildPhotoArea() {
    return _image != null || widget.image != null
        ? SizedBox(
          width: 300,
          height: 100,
          child: Image.file(_image ?? widget.image!),
        )
        : Container(width: 300, height: 100, color: Colors.grey);
  }

  void _setImageFileListFromFile(XFile? value) {
    _mediaFileList = value == null ? null : <XFile>[value];
  }

  Future getImage(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  ElevatedButton _buildElevatedButton(String label, ImageSource imageSource) {
    return ElevatedButton(
      onPressed: () {
        getImage(imageSource);
      },
      child: Text(label),
    );
  }

  @override // Move build method inside the class
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 2, width: double.infinity),
          _buildPhotoArea(),
          const SizedBox(height: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 10),
              _buildElevatedButton("갤러리", ImageSource.gallery),
            ],
          ),
        ],
      ),
    );
  }
}
