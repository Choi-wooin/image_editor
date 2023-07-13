import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_editor/component/main_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../component/emoticon_sticker.dart';
import '../component/footer.dart';
import '../model/sticker_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? image;
  Set<StickerModel> stickers = {};
  String? selectedID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          renderBody(),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: MainAppBar(
              onPickImage: onPickImage,
              onSaveImage: onSaveImage,
              onDeleteImage: onDeleteImage,
            ),
          ),
          if (image != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Footer(
                onEmoticonTap: onEmoticonTap,
              ),
            )
        ],
      ),
    );
  }

  Widget renderBody() {
    if (image != null) {
      return Positioned.fill(
        child: InteractiveViewer(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.file(
                File(image!.path),
                fit: BoxFit.cover,
              ),
              ...stickers.map(
                (sticker) => Center(
                  child: EmoticonSticker(
                    key: ObjectKey(sticker.id),
                    onTransform: (){onTransform(sticker.id);},
                    imgPath: sticker.imgPath,
                    isSelected: selectedID == sticker.id,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Center(
        child: TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.grey),
          onPressed: onPickImage,
          child: Text('이미지 선택하기'),
        ),
      );
    }
  }

  void onPickImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      this.image = image;
    });
  }

  void onSaveImage() {}

  void onDeleteImage() {}

  void onEmoticonTap(int index) async {
    setState(() {
      stickers = {
        ...stickers,
        StickerModel(
          id: Uuid().v4(),
          imgPath: 'assets/img/emoticon_$index.png',
        ),
      };
    });
  }

  void onTransform(String id) {
    setState(() {
      selectedID = id;
    });
  }
}
