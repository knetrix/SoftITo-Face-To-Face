import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<TaskSnapshot> uploadFile({
    required File file,
    required String path,
    required String fileName,
  }) {
    final Reference ref = _storage.ref().child('$path/$fileName');
    final metadata = SettableMetadata(contentType: 'image/jpeg', customMetadata: {'uploader': 'Mustafa'});
    final UploadTask task = ref.putFile(file, metadata);

    task.snapshotEvents.listen((TaskSnapshot snapshot) {
      final double progress = snapshot.bytesTransferred / snapshot.totalBytes;
      debugPrint('Uploading: %${(progress * 100).toStringAsFixed(1)}');
    });

    return task;
  }
}
