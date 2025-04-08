import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tim_news_flutter/news/models/news_model.dart';
import 'package:tim_news_flutter/news/providers/news_provider.dart';
import 'dart:io';

import 'package:tim_news_flutter/theme/colors.dart';

import 'image_data_submit.dart';

class ImageAdd extends ConsumerStatefulWidget {
  final File? image; // Add this property
  const ImageAdd({super.key, this.image}); // Update constructor

  @override
  ConsumerState<ImageAdd> createState() => _ImageAddState();
}

class _ImageAddState extends ConsumerState<ImageAdd> {
  File? _image; // 이미지 담을 변수
  final ImagePicker picker = ImagePicker();

  Widget _buildPhotoArea(ImageSource imageSource, NewsModel news_data, NewsNotifier newsNotifier,) {
    return GestureDetector(
      onTap: () {
        getImage(imageSource, newsNotifier);
      },
      child:
          _image != null || widget.image != null || news_data.images != null
              ? SizedBox(
                width: 300,
                height: 300,
                child: Image.file(_image ?? widget.image ?? news_data.images!),
              )
              : Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 1),
                ),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.photo, size: 70),
                    SizedBox.fromSize(size: Size(double.infinity, 20)),
                    Text(
                      '사진을 넣어주세요',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Future getImage(ImageSource imageSource, NewsNotifier newsNotifier) async {
    try {
      final XFile? pickedFile = await picker.pickImage(source: imageSource);
      if (pickedFile != null) {
        newsNotifier.setImages(File(pickedFile.path));
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('오류가 발생했습니다. 다시 설정해주세요.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final news_data = ref.watch(newsProvider);
    final newsNotifier = ref.read(newsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text('이미지 추가')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: double.infinity),
              _buildPhotoArea(ImageSource.gallery, news_data, newsNotifier),
            ],
          ),
          SizedBox(height: 20),
          SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: yellowColor,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    newsCreateSubmit(ref, news_data.category, news_data.content, news_data.title, news_data.images, news_data.date);
                  },
                  child: Text(
                    '발행하기',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
