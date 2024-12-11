import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fyp/main.dart';
import 'package:fyp/user_app_svcs/my_recent_saves.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'SelectCategoryPage.dart';

class UploadImagePage extends StatefulWidget {
  const UploadImagePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UploadImagePageState createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  Uint8List? _webImage;

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      if (kIsWeb) {
        final webImageBytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = webImageBytes;
          _imageFile = pickedFile;
        });
      } else {
        setState(() {
          _imageFile = pickedFile;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    final double imagePreviewSize = screenWidth * 0.5;
    final double buttonWidth = screenWidth * 0.4;
    final double buttonHeight = screenHeight * 0.07;

    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyRecentSaves()));
            },
            style: const ButtonStyle().copyWith(
                backgroundColor: const WidgetStatePropertyAll(Colors.black),
                foregroundColor: const WidgetStatePropertyAll(Colors.white),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                )),
            child: const Text('My Recent Saves'),
          ),
          const Gap(15),
        ],
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/baby pink.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Upload Image',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.pinkAccent,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _imageFile == null
                        ? const Text('No image selected.')
                        : kIsWeb
                            ? Image.memory(
                                _webImage!,
                                height: imagePreviewSize,
                                width: imagePreviewSize,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(_imageFile!.path),
                                height: imagePreviewSize,
                                width: imagePreviewSize,
                                fit: BoxFit.cover,
                              ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 20.0,
                      runSpacing: 20.0,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _pickImage(ImageSource.gallery),
                          icon: const Icon(Icons.image, color: Colors.white),
                          label: const Text(
                            'Select from Gallery',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pinkAccent,
                            minimumSize: Size(buttonWidth, buttonHeight),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _pickImage(ImageSource.camera),
                          icon:
                              const Icon(Icons.camera_alt, color: Colors.white),
                          label: const Text(
                            'Capture with Camera',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pinkAccent,
                            minimumSize: Size(buttonWidth, buttonHeight),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _imageFile == null && _webImage == null
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SelectCategoryPage(
                                    imageFile: _imageFile,
                                    webImage: _webImage,
                                  ),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        minimumSize: Size(buttonWidth, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: const Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
          height: 100,
          child: Padding(
            padding: EdgeInsets.only(
                left: screenWidth * .15, right: screenWidth * .15, bottom: 40),
            child: TextButton(
              style: const ButtonStyle().copyWith(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                backgroundColor: WidgetStatePropertyAll(
                  Colors.black.withOpacity(.7),
                ),
                foregroundColor: const WidgetStatePropertyAll(Colors.white),
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                while (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WelcomeScreen(),
                    ));
              },
              child: const Text("Logout"),
            ),
          )),
    );
  }
}
