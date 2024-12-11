import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fyp/CustomizationPage.dart';
import 'package:fyp/services/app_toasts.dart';
import 'package:fyp/services/image_processing_service.dart';
import 'package:fyp/services/save_and_get_file_service.dart';
import 'package:fyp/utils/app_utils.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SelectCategoryPage extends StatefulWidget {
  final XFile? imageFile;
  final Uint8List? webImage;

  const SelectCategoryPage({super.key, this.imageFile, this.webImage});

  @override
  _SelectCategoryPageState createState() => _SelectCategoryPageState();
}

class _SelectCategoryPageState extends State<SelectCategoryPage> {
  String? _selectedCategory;
  String? _selectedSubCategory;
  String selectedForGenerate = "";
  Image? generatedImage;
  bool isLoading = false;
  String generatedImagePath = "";

  final List<String> _mainCategories = ['Qameez', 'Shalwar'];

  final Map<String, List<Map<String, String>>> _subCategories = {
    'Qameez': [
      {
        "name": "Kurta",
        'image': AppUtils.instance.kurta,
      },
      {
        "name": "Straight Shirt",
        'image': AppUtils.instance.straightShirt,
      },
      {
        "name": "Short Kurti",
        'image': AppUtils.instance.shortKurti,
      },
      {
        "name": "Button Down Shirt",
        'image': AppUtils.instance.buttonDownShirt,
      }
    ],
    'Shalwar': [
      {
        "name": "Trouser",
        'image': AppUtils.instance.trouser,
      },
      {
        "name": "Palazzo",
        'image': AppUtils.instance.plazzo,
      },
      {
        "name": "Shalwar",
        'image': AppUtils.instance.shalwar,
      },
      {
        "name": "Capri",
        'image': AppUtils.instance.capri,
      },
      {
        "name": "Dhoti Shalwar",
        'image': AppUtils.instance.dhotiShalwar,
      }
    ]
  };

  void _showSubCategoryDialog(String category) async {
    Map<String, dynamic>? pickedDesign = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select $category Type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _subCategories[category]!.map((e) {
              return ListTile(
                title: Text(e["name"]!),
                onTap: () {
                  setState(() {
                    _selectedSubCategory = e["name"];
                  });
                  Navigator.pop(context, e);
                },
              );
            }).toList(),
          ),
        );
      },
    );
    if (pickedDesign != null) {
      selectedForGenerate = pickedDesign["image"];
    }
  }

  void _onGeneratePressed() async {
    if (_selectedCategory != null && _selectedSubCategory != null) {
      try {
        setState(() {
          isLoading = true;
        });
        File contentImage =
            await AppUtils.instance.getFileFromAsset(selectedForGenerate);
        final designImage = File(widget.imageFile!.path);
        Uint8List img = await ImageProcessingService.instance
            .postRequest(content: contentImage, design: designImage);
        final saved = await SaveAndGetFileService.instance.saveImageBytes(img);
        setState(() {
          generatedImage = Image.memory(img);
          generatedImagePath = saved;
          isLoading = false;
        });
      } catch (e) {
        AppToasts.instance.simple(title: "An error occurred, please try again");
        setState(() {
          isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both category and subcategory.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;

    return Scaffold(
        backgroundColor: const Color(0xFFecd8c6),
        body: generatedImage == null
            ? Skeletonizer(enabled: isLoading, child: initialState(screenWidth))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: screenSize.height * .7,
                    ),
                    decoration: BoxDecoration(
                        image: DecorationImage(image: generatedImage!.image)),
                  ),
                  const Gap(70),
                  TextButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomizationPage(
                              image: generatedImage!.image,
                              path: generatedImagePath,
                            ),
                          ));
                      // await showDialog(
                      //     context: context, builder: (context) => DesignPage(
                      //       image: generatedImage.image,
                      //     ));
                    },
                    style: const ButtonStyle().copyWith(
                      backgroundColor:
                          const WidgetStatePropertyAll(Colors.pinkAccent),
                      minimumSize: const WidgetStatePropertyAll(Size(200, 45)),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                      foregroundColor:
                          const WidgetStatePropertyAll(Colors.white),
                    ),
                    child: const Text("Customize Design"),
                  )
                ],
              )
        // body: initialState(screenWidth),
        );
  }

  Center initialState(double screenWidth) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Let's Generate your design",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.pinkAccent,
              ),
            ),
            const SizedBox(height: 20),
            kIsWeb
                ? Image.memory(
                    widget.webImage ?? Uint8List(0),
                    height: screenWidth * 0.5,
                    width: screenWidth * 0.5,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    File(widget.imageFile?.path ?? ''),
                    height: screenWidth * 0.5,
                    width: screenWidth * 0.5,
                    fit: BoxFit.cover,
                  ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: _selectedCategory,
              hint: const Text("Select Category"),
              items: _mainCategories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                  _selectedSubCategory = null;
                  if (newValue != null) {
                    _showSubCategoryDialog(newValue);
                  }
                });
              },
              isExpanded: true,
              style: const TextStyle(fontSize: 18.0, color: Colors.black),
            ),
            const SizedBox(height: 20),
            if (_selectedSubCategory != null)
              Text(
                'Selected: $_selectedSubCategory',
                style: const TextStyle(fontSize: 16.0),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  _selectedCategory == null || _selectedSubCategory == null
                      ? null
                      : _onGeneratePressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                minimumSize: Size(screenWidth * 0.5, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text(
                "Generate",
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
