import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

final class SaveAndGetFileService {
  SaveAndGetFileService._();

  static final instance = SaveAndGetFileService._();

  Future<void> saveFile(String image) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path =
        "${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png";
    File savedImage = await File(image).copy(path);
    debugPrint("Image saved to: ${savedImage.path}");
  }

  Future<List<File>> getSavedFiles() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final List<FileSystemEntity> files = directory.listSync();
    List<File> images = files
        .where((file) =>
            file is File &&
            (file.path.endsWith('.png') || file.path.endsWith('.jpg')))
        .map((file) => File(file.path))
        .toList();
    final Set<String> uniqueFiles = images.map((e) => e.path).toSet();
    return uniqueFiles.map((e) => File(e)).toList();
  }

  Future<String> saveImageBytes(Uint8List imgBytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final String filePath =
        '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';

    final File file = File(filePath);
    await file.writeAsBytes(imgBytes);

    return file.path;
  }
}
