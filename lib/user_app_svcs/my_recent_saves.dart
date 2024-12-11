import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fyp/dialogs/loading.dart';
import 'package:fyp/services/app_toasts.dart';
import 'package:fyp/services/save_and_get_file_service.dart';
import 'package:fyp/services/supabase.dart';
import 'package:fyp/user_app_svcs/all_tailors.dart';

class MyRecentSaves extends StatefulWidget {
  const MyRecentSaves({super.key});

  @override
  State<MyRecentSaves> createState() => _MyRecentSavesState();
}

class _MyRecentSavesState extends State<MyRecentSaves> {
  List<File> images = [];
  bool isLoading = false;

  void getImages() async {
    try {
      setState(() {
        isLoading = true;
      });
      images = await SaveAndGetFileService.instance.getSavedFiles();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      AppToasts.instance.simple(title: "Error occured");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    getImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My recent saves"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : (images.isEmpty
              ? const Center(child: Text("No files found"))
              : ListView.builder(
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.sizeOf(context).height * .5,
                        maxWidth: MediaQuery.of(context).size.width,
                        minWidth: MediaQuery.of(context).size.width,
                        minHeight: MediaQuery.sizeOf(context).height * .4,
                      ),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(images[index]),
                        ),
                      ),
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.only(
                        top: MediaQuery.sizeOf(context).height * .3,
                        bottom: 20,
                      ),
                      child: TextButton(
                        onPressed: () async {
                          await showDialog(
                              context: context,
                              builder: (context) => const LoadingDialog());
                          final url = await SupabaseServices.instance
                              .uploadImageAndGetFile(image: images[index]);
                          Navigator.pop(context);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AllTailorsView(
                                image: url,
                              ),
                            ),
                          );
                        },
                        style: const ButtonStyle().copyWith(
                            backgroundColor:
                                const WidgetStatePropertyAll(Colors.black),
                            foregroundColor:
                                const WidgetStatePropertyAll(Colors.white),
                            shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)))),
                        child: const Text("Chat with Tailor"),
                      ),
                    );
                  },
                )),
    );
  }
}
