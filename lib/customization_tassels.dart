import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fyp/Upload_image.dart';
import 'package:fyp/dialogs/save_or_chat.dart';
import 'package:fyp/services/app_toasts.dart';
import 'package:fyp/services/save_and_get_file_service.dart';
import 'package:fyp/services/supabase.dart';
import 'package:fyp/user_app_svcs/all_tailors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomizationTasselPage extends StatefulWidget {
  final ImageProvider imageProvider;
  final String path;
  const CustomizationTasselPage(
      {super.key, required this.imageProvider, required this.path});

  @override
  _CustomizationTasselPageState createState() =>
      _CustomizationTasselPageState();
}

class _CustomizationTasselPageState extends State<CustomizationTasselPage> {
  List<_TasselItem> _tasselItems = [];
  String? _selectedTassel;

  GlobalKey globalKey = GlobalKey();
  String generatedImagePath = "";

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
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save image')),
      );
    }
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final List<String> tesselImages = List.generate(7, (index) {
      return "assets/tassel${index + 1}.png";
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Customize Your Dress with Tassels',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFecd8c6),
      body: Skeletonizer(
        enabled: isLoading,
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height - 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: GestureDetector(
                  onTapDown: (TapDownDetails details) {
                    if (_selectedTassel != null) {
                      setState(() {
                        _tasselItems.add(_TasselItem(
                          imagePath: _selectedTassel!,
                          position:
                              details.localPosition - const Offset(50, 50),
                        ));
                        _selectedTassel = null;
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
                        for (var laceItem in _tasselItems)
                          Positioned(
                            left: laceItem.position.dx,
                            top: laceItem.position.dy,
                            child: GestureDetector(
                              onScaleUpdate: (details) {
                                setState(() {
                                  laceItem.position += details.focalPointDelta;
                                  laceItem.scale =
                                      laceItem.scale * details.scale;
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
                                    imageProvider:
                                        AssetImage(laceItem.imagePath),
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
                  itemCount: tesselImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTassel = tesselImages[index];
                          });
                        },
                        child: Image.asset(
                          tesselImages[index],
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                          color: _selectedTassel == tesselImages[index]
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
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 60, right: 60, bottom: 30),
        child: ElevatedButton(
          onPressed: () async {
            String? userChoice = await showDialog(
                context: context,
                builder: (context) => const SaveOrChatDialog());
            if (userChoice != null) {
              if (userChoice == "Chat") {
                setState(() {
                  isLoading = true;
                });
                await captureImage();
                final url = await SupabaseServices.instance
                    .uploadImageAndGetFile(image: File(generatedImagePath));
                setState(() {
                  isLoading = false;
                });
                await Future.delayed(const Duration(milliseconds: 800));
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AllTailorsView(image: url)));
              } else {
                await captureImage();
                await SaveAndGetFileService.instance.saveFile(widget.path);
                AppToasts.instance.simple(title: "Image saved successfully");
                while (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UploadImagePage()));
              }
            }
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

  Widget _buildSelectableTassel(String imagePath) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTassel = imagePath;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: _selectedTassel == imagePath
                  ? Colors.pinkAccent
                  : Colors.transparent,
              width: 2.0,
            ),
          ),
          child: Image.asset(
            imagePath,
            width: 50,
            height: 50,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class _TasselItem {
  final String imagePath;
  Offset position;
  double scale;

  _TasselItem({
    required this.imagePath,
    required this.position,
    this.scale = 1.0,
  });
}
