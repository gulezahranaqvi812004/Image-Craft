import 'package:flutter/material.dart';
import 'package:image_editor/models/textInfo.dart';

class ImageText extends StatelessWidget {
  final TextInfo textInfo;
  const ImageText({Key? key, required this.textInfo});

  @override
  Widget build(BuildContext context) {
    return Text(
      textInfo.text,
      textAlign: textInfo.textAlign,
      style: TextStyle(
        fontSize: textInfo.fontSize,
        fontWeight: textInfo.fontWeight,
        fontStyle: textInfo.fontStyle,
        color: textInfo.color,
      ),
    );
  }
}
