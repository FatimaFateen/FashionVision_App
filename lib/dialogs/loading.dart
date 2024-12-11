import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  final String? title;
  const LoadingDialog({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          title ?? "Loading",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      content: const LinearProgressIndicator(),
    );
  }
}
