import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:image_picker/image_picker.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage({bool withCamera = false}) async {
    final XFile? xFile = await _picker.pickImage(
      source: withCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1200,
    );
    if (xFile == null) return null;
    return File(xFile.path);
  }

  UploadTask uploadFile({
    required File file,
    required String fileName,
    required String path,
  }) {
    final Reference reference = _storage.ref().child('$path/$fileName');
    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'Uploader': 'Mustafa'},
    );
    return reference.putFile(file, metadata);
  }

  Future<String> downloadUrl({required Reference reference}) async {
    return await reference.getDownloadURL();
  }

  Future<void> deleteFile({required String path}) async {
    final Reference reference = _storage.ref().child(path);
    await reference.delete();
  }
}
