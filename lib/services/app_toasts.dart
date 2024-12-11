import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toastification/toastification.dart';

final class AppToasts {
  AppToasts._();
  static final instance = AppToasts._();

  void simple({
    String? title,
  }) async {
    await HapticFeedback.heavyImpact();
    toastification.show(
      backgroundColor: Colors.black,
      style: ToastificationStyle.simple,
      foregroundColor: Colors.white,
      title: Text(title ?? "",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          )),
      autoCloseDuration: const Duration(seconds: 5),
      borderSide: BorderSide.none,
    );
  }

  void filled({
    String? title,
    String? description,
  }) async {
    await HapticFeedback.heavyImpact();
    toastification.show(
      backgroundColor: Colors.black,
      style: ToastificationStyle.fillColored,
      foregroundColor: Colors.white,
      title: Text(title ?? "",
          style: const TextStyle(color: Colors.white, fontSize: 14)),
      description: Text(description ?? "data"),
      autoCloseDuration: const Duration(seconds: 5),
      borderSide: BorderSide.none,
      primaryColor: Colors.black,
      showIcon: false,
      showProgressBar: false,
    );
  }
}
