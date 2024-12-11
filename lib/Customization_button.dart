import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'customization_tassels.dart';

class CustomizationButtonPage extends StatefulWidget {
  final ImageProvider imageProvider;
  final String path;
  const CustomizationButtonPage(
      {super.key, required this.imageProvider, required this.path});

  @override
  _CustomizationButtonPageState createState() =>
      _CustomizationButtonPageState();
}

class _CustomizationButtonPageState extends State<CustomizationButtonPage> {
  List<_ButtonItem> _buttonItems = [];
  String? _selectedButton;
  GlobalKey globalKey = GlobalKey();
  String generatedImagePath = "";

  final List<String> buttonImages = [
    'assets/button1.png',
    'assets/button2.png',
    'assets/button3.png',
    'assets/button4.png',
    'assets/button5.png',
    'assets/button6.png',
  ];

  Future<void> captureImage() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      final directory = await getApplicationDocumentsDirectory();
      final int now = DateTime.now().millisecondsSinceEpoch;
      final file = File('${directory.path}/$now.png');
      await file.writeAsBytes(pngBytes);
      generatedImagePath = file.path;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image edited successfully.')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CustomizationTasselPage(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Customize Your Dress with Buttons',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
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
                  if (_selectedButton != null) {
                    setState(() {
                      _buttonItems.add(_ButtonItem(
                        imagePath: _selectedButton!,
                        position: details.localPosition - const Offset(50, 50),
                      ));
                      _selectedButton = null;
                    });
                  }
                },
                child: RepaintBoundary(
                  key: globalKey,
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.6,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: widget.imageProvider,
                              )),
                        ),
                      ),
                      for (var laceItem in _buttonItems)
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
                itemCount: buttonImages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedButton = buttonImages[index];
                        });
                      },
                      child: Image.asset(
                        buttonImages[index],
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                        color: _selectedButton == buttonImages[index]
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
      // body: SizedBox(
      //   height: MediaQuery.sizeOf(context).height - 200,
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Expanded(
      //         child: GestureDetector(
      //           onTapDown: (details) {
      //             if (_selectedButton != null) {
      //               setState(() {
      //                 _buttonItems.add(_ButtonItem(
      //                   imagePath: _selectedButton!,
      //                   position: details.localPosition,
      //                 ));
      //               });
      //             }
      //           },
      //           child: RepaintBoundary(
      //             key: globalKey,
      //             child: Stack(
      //               children: [
      //                 Center(
      //                   child: Container(
      // width: MediaQuery.of(context).size.width * 0.8,
      // height: MediaQuery.of(context).size.height * 0.6,
      //                     decoration: BoxDecoration(
      //                       color: Colors.white,
      //                       borderRadius: BorderRadius.circular(12),
      //                       image: DecorationImage(image: widget.imageProvider),
      //                     ),
      //                   ),
      //                 ),
      //                 for (var buttonItem in _buttonItems)
      //                   Positioned(
      //                     left: buttonItem.position.dx - 50,
      //                     top: buttonItem.position.dy - 50,
      //                     child: GestureDetector(
      //                       onScaleUpdate: (details) {
      //                         setState(() {
      //                           buttonItem.position += details.focalPointDelta;
      //                           buttonItem.scale *= details.scale;
      //                           buttonItem.scale =
      //                               buttonItem.scale.clamp(0.5, 3.0);
      //                         });
      //                       },
      //                       child: Transform.scale(
      //                         scale: buttonItem.scale,
      //                         child: Container(
      //                           decoration: const BoxDecoration(
      //                               color: Colors.transparent),
      //                           constraints: BoxConstraints(
      //                             maxHeight: 160,
      //                             minHeight: 40,
      //                             minWidth: 200,
      //                             maxWidth: MediaQuery.sizeOf(context).width,
      //                           ),
      //                           child: PhotoView(
      //                             backgroundDecoration: const BoxDecoration(
      //                               color: Colors.transparent,
      //                             ),
      //                             imageProvider:
      //                                 AssetImage(buttonItem.imagePath),
      //                           ),
      //                         ),
      //                       ),
      //                     ),
      //                   ),
      //               ],
      //             ),
      //           ),
      //         ),
      //       ),
      //       const SizedBox(height: 20),
      //       Container(
      //         height: 120,
      //         padding: const EdgeInsets.symmetric(horizontal: 10),
      //         child: ListView.builder(
      //           scrollDirection: Axis.horizontal,
      //           itemCount: buttonImages.length,
      //           itemBuilder: (context, index) {
      //             return Padding(
      //               padding: const EdgeInsets.all(8.0),
      //               child: GestureDetector(
      //                 onTap: () {
      //                   setState(() {
      //                     _selectedButton = buttonImages[index];
      //                   });
      //                 },
      //                 child: Container(
      //                   decoration: BoxDecoration(
      //                     border: Border.all(
      //                       color: _selectedButton == buttonImages[index]
      //                           ? Colors.pinkAccent
      //                           : Colors.transparent,
      //                       width: 2.0,
      //                     ),
      //                   ),
      //                   child: Image.asset(
      //                     buttonImages[index],
      //                     width: 100,
      //                     height: 100,
      //                     fit: BoxFit.contain,
      //                   ),
      //                 ),
      //               ),
      //             );
      //           },
      //         ),
      //       ),
      //       const SizedBox(height: 20),
      //     ],
      //   ),
      // ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 60, right: 60, bottom: 30),
        child: ElevatedButton(
          onPressed: () async {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => CustomizationTasselPage(
            //       imageProvider: widget.imageProvider,
            //       path: widget.path,
            //     ),
            //   ),
            // );
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

class _ButtonItem {
  final String imagePath;
  Offset position;
  double scale;

  _ButtonItem({
    required this.imagePath,
    required this.position,
    this.scale = 1.0,
  });
}
