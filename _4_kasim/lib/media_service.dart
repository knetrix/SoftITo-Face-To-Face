import 'dart:io';

import 'package:image_picker/image_picker.dart';

class MediaPickerService {
  final ImagePicker _imagePicker = ImagePicker();

  Future<File?> pickImageGallery() async {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 500,
      maxHeight: 500,
    );
    if (pickedFile == null) return null;
    return File(pickedFile.path);
  }

  Future<File?> pickImageCamera() async {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      maxWidth: 1200,
      maxHeight: 1200,
    );
    if (pickedFile == null) return null;
    return File(pickedFile.path);
  }
}
