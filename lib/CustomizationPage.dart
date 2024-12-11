import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'customization_button.dart';
import 'dart:ui' as ui;

class CustomizationPage extends StatefulWidget {
  final ImageProvider image;
  final String path;
  const CustomizationPage({super.key, required this.image, required this.path});

  @override
  _CustomizationPageState createState() => _CustomizationPageState();
}

class _CustomizationPageState extends State<CustomizationPage> {
  List<_LaceItem> _laceItems = [];
  String? _selectedLace;

  final List<String> laceImages = [
    'assets/lace1.png',
    'assets/lace2.png',
    'assets/lace3.png',
    'assets/lace4.png',
    'assets/lace5.png',
    'assets/lace6.png',
    'assets/lace7.png',
  ];

  GlobalKey globalKey = GlobalKey();
  String generatedImagePath = "";
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double containerHeight = screenSize.height * 0.6;
    final double containerWidth = screenSize.width * 0.8;

    Future<void> captureImage() async {
      try {
        RenderRepaintBoundary boundary = globalKey.currentContext
            ?.findRenderObject() as RenderRepaintBoundary;
        ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        Uint8List pngBytes = byteData!.buffer.asUint8List();
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/generated_image.png');
        await file.writeAsBytes(pngBytes);
        generatedImagePath = file.path;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image edited successfully.')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustomizationButtonPage(
              imageProvider: FileImage(file),
              path: generatedImagePath,
            ),
          ),
        );
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save image')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Customize Your Dress with Laces",
          style: TextStyle(
            fontSize: 19,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFecd8c6),
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height - 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: GestureDetector(
                onTapDown: (TapDownDetails details) {
                  if (_selectedLace != null) {
                    setState(() {
                      _laceItems.add(_LaceItem(
                        imagePath: _selectedLace!,
                        position: details.localPosition - const Offset(50, 50),
                      ));
                      _selectedLace = null;
                    });
                  }
                },
                child: RepaintBoundary(
                  key: globalKey,
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                          width: containerWidth,
                          height: containerHeight,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: widget.image,
                              )),
                        ),
                      ),
                      for (var laceItem in _laceItems)
                        Positioned(
                          left: laceItem.position.dx,
                          top: laceItem.position.dy,
                          child: GestureDetector(
                            onScaleUpdate: (details) {
                              setState(() {
                                laceItem.position += details.focalPointDelta;
                                laceItem.scale = laceItem.scale * details.scale;
                              });
                            },
                            child: Transform.scale(
                              scale: laceItem.scale,
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.transparent),
                                constraints: BoxConstraints(
                                  maxHeight: 160,
                                  minHeight: 40,
                                  minWidth: 200,
                                  maxWidth: MediaQuery.sizeOf(context).width,
                                ),
                                child: PhotoView(
                                  backgroundDecoration: const BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  imageProvider: AssetImage(laceItem.imagePath),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 120,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: laceImages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedLace = laceImages[index];
                        });
                      },
                      child: Image.asset(
                        laceImages[index],
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                        color: _selectedLace == laceImages[index]
                            ? Colors.grey.withOpacity(0.5)
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 30, left: 60, right: 60),
        child: ElevatedButton(
          onPressed: () async {
            await captureImage();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pinkAccent,
            padding:
                const EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          child: const Text(
            'Next',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _LaceItem {
  final String imagePath;
  Offset position;
  double scale;

  _LaceItem({
    required this.imagePath,
    required this.position,
    this.scale = 1.0,
  });
}
