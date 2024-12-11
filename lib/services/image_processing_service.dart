import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class ImageProcessingService {
  ImageProcessingService._();

  static final instance = ImageProcessingService._();
  final baseURL =
      "https://protected-sea-17395-21ef5e7dc0b1.herokuapp.com/stylize";

  Future<Uint8List> postRequest({
    required File content,
    required File design,
  }) async {
    const contentImage = "content_image";
    const designImage = "design_image";
    var request = http.MultipartRequest('POST', Uri.parse(baseURL));
    request.files.add(await http.MultipartFile.fromPath(
      contentImage, // Field name for the first image
      content.path,
    ));
    request.files.add(await http.MultipartFile.fromPath(
      designImage,
      design.path,
    ));
    final response = await request.send();
    final bytes = await response.stream.toBytes();
    return bytes;
  }
}
