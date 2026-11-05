import 'dart:io';

import 'package:flutter/material.dart';

class ImageUploadCard extends StatelessWidget {
  final File? selectedFile;
  final String? uploadUrl;
  final double loadingProgress;
  final bool isLoading;
  final VoidCallback onGallerySelect;
  final VoidCallback onTakePhoto;
  final VoidCallback onCloudUpload;

  const ImageUploadCard({
    super.key,
    required this.selectedFile,
    required this.uploadUrl,
    required this.loadingProgress,
    required this.isLoading,
    required this.onGallerySelect,
    required this.onTakePhoto,
    required this.onCloudUpload,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              children: [
                Icon(Icons.cloud_upload_outlined, color: Color(0xFF0047FF)),
                SizedBox(width: 8),
                Text(
                  'Firebase Media Uploader',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 46, 121, 212),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 12, 6, 37),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              alignment: Alignment.center,
              child: selectedFile != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        selectedFile!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    )
                  : (uploadUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              uploadUrl!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_outlined,
                                size: 48,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'No Image Selected Yet',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          )),
            ),
          ],
        ),
      ),
    );
  }
}
