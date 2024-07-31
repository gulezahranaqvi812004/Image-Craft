import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_editor/models/textInfo.dart';
import 'package:image_editor/screen/editImageScreen.dart';
import 'package:image_editor/widget/defaultButton.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import '../utils/utils.dart';

abstract class EditImageViewModel extends State<EditImageScreen> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController creatorText = TextEditingController();
  ScreenshotController screenshotController = ScreenshotController();
  int currentIndex = 0;
  setCurrentIndex(BuildContext context, index) {
    setState(() {
      currentIndex = index;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Selected for styling',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  removeText(BuildContext context) {
    setState(() {
      texts.removeAt(currentIndex);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Deleted',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  saveImageToGallery(BuildContext context) {
    if (texts.isNotEmpty) {
      screenshotController
          .capture()
          .then((Uint8List? image) {
            if (image != null) {
              saveImage(image);
            }
            return; // This ensures the function returns void, matching the expected type.
          } as FutureOr Function(Uint8List? image))
          .catchError((e) => print(e));
    }
  }

  saveImage(Uint8List bytes) async {
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');
    final name="screenshot_$time";
    await requestPermission(Permission.storage);
    await ImageGallerySaver.saveImage(bytes, name: name);
  }

  changeTextColor(Color color) {
    setState(() {
      texts[currentIndex].color = color;
    });
  }

  increaseFontSize() {
    setState(() {
      texts[currentIndex].fontSize = texts[currentIndex].fontSize + 2;
    });
  }

  decreaseFontSize() {
    setState(() {
      texts[currentIndex].fontSize = texts[currentIndex].fontSize - 2;
    });
  }

  boldText() {
    setState(() {
      if (texts[currentIndex].fontWeight == FontWeight.normal) {
        texts[currentIndex].fontWeight = FontWeight.bold;
      } else {
        texts[currentIndex].fontWeight = FontWeight.normal;
      }
    });
  }

  italicText() {
    setState(() {
      if (texts[currentIndex].fontStyle == FontStyle.normal) {
        texts[currentIndex].fontStyle = FontStyle.italic;
      } else {
        texts[currentIndex].fontStyle = FontStyle.normal;
      }
    });
  }

  addLinesToText() {
    setState(() {
      if (texts[currentIndex].text.contains('\n')) {
        texts[currentIndex].text =
            texts[currentIndex].text.replaceAll('\n', ' ');
      } else {
        texts[currentIndex].text =
            texts[currentIndex].text.replaceAll(' ', '\n');
      }
    });
  }

  alignLeft() {
    setState(() {
      if (texts[currentIndex].textAlign == TextAlign.left) {
        texts[currentIndex].textAlign = TextAlign.right;
      } else {
        texts[currentIndex].textAlign = TextAlign.left;
      }
    });
  }

  alignRight() {
    setState(() {
      if (texts[currentIndex].textAlign == TextAlign.right) {
        texts[currentIndex].textAlign = TextAlign.left;
      } else {
        texts[currentIndex].textAlign = TextAlign.right;
      }
    });
  }

  alignCenter() {
    setState(() {
      if (texts[currentIndex].textAlign == TextAlign.center) {
        texts[currentIndex].textAlign = TextAlign.left;
      } else {
        texts[currentIndex].textAlign = TextAlign.center;
      }
    });
  }

  List<TextInfo> texts = [];
  addNewText(BuildContext context) {
    setState(() {
      texts.add(TextInfo(
          text: textEditingController.text,
          left: 0,
          top: 0,
          color: Colors.black,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          textAlign: TextAlign.left,
          fontSize: 20));
      Navigator.pop(context);
    });
  }

  addNewDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Add new text',
        ),
        content: TextField(
          controller: textEditingController,
          maxLines: 5,
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.edit),
            filled: true,
            hintText: 'Your Text Here..',
          ),
        ),
        actions: <Widget>[
          Defaultbutton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back'),
              color: Colors.white,
              textColor: Colors.black54),
          Defaultbutton(
              onPressed: () => addNewText(context),
              child: const Text('Add Text'),
              color: Colors.red,
              textColor: Colors.white)
        ],
      ),
    );
  }
}
