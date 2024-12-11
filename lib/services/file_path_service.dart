import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

final class FilesPathService {
  FilesPathService._();
  static final instance = FilesPathService._();
  Future<Directory> getPath() async {
    try {
      if (Platform.isIOS) {
        Directory? directory = await getApplicationDocumentsDirectory();
        return directory;
      } else {
        Directory? directory = await getApplicationSupportDirectory();
        return directory;
      }
    } catch (e) {
      throw PlatformException(code: e.toString());
    }
  }
}
