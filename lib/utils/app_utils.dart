import 'dart:io';
import 'package:flutter/services.dart';
import 'package:fyp/services/file_path_service.dart';

final class AppUtils {
  AppUtils._();

  static final instance = AppUtils._();

  final String kurta = "assets/designs/kurta.jpg";
  final String straightShirt = "assets/designs/straight_shirt.jpeg";
  final String shortKurti = "assets/designs/short_kurti.jpg";
  final String buttonDownShirt = "assets/designs/button_down.jpg";

  final String trouser = "assets/designs/trouser.png";
  final String plazzo = "assets/designs/flapper.png";
  final String shalwar = "assets/designs/shalwar.png";
  final String capri = "assets/designs/straight_trouser.png";
  final String dhotiShalwar = "assets/designs/dhoti_shalwar.jpg";

  Future<File> getFileFromAsset(
    String assetPath,
  ) async {
    ByteData data = await rootBundle.load(assetPath);
    Uint8List bytes = data.buffer.asUint8List();
    Directory tempDir = await FilesPathService.instance.getPath();
    String tempPath =
        '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.png';
    File file = await File(tempPath).writeAsBytes(bytes);
    return file;
  }
}
