import 'package:flutter/material.dart';
import 'package:image_editor/screen/editImageScreen.dart';
import 'package:image_picker/image_picker.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
          icon: const Icon(Icons.upload_file),
          iconSize: 80,
          onPressed: () async {
            XFile? file =
                await ImagePicker().pickImage(source: ImageSource.gallery);
            if (file != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EditImageScreen(selectedImage: file.path),
                ),
              );
            } else {
              // Handle the case where no file was selected
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('No file selected')),
              );
            }
          },
        ),
      ),
    );
  }
}
