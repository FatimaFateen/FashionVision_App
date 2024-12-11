import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseServices {
  SupabaseServices._();
  static final instance = SupabaseServices._();
  final String url = "https://vlytyfgenzgauxxtyobc.supabase.co";
  final String key =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZseXR5ZmdlbnpnYXV4eHR5b2JjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzM4Mzg5MDYsImV4cCI6MjA0OTQxNDkwNn0.c3Rbu64hpDkaorb083iNVvEjVNlqS8oHFE8qopBinzI";
  Future<void> init() async {
    await Supabase.initialize(url: url, anonKey: key);
  }

  Future<String> uploadImageAndGetFile({required File image}) async {
    final imageFile = image;
    final fileName = '${DateTime.now().toIso8601String()}.png';
    final storagePath = 'uploads/$fileName';
    await Supabase.instance.client.storage
        .from('dress_designs')
        .upload(storagePath, imageFile);
    final publicUrl = Supabase.instance.client.storage
        .from('dress_designs')
        .getPublicUrl(storagePath);
    return publicUrl;
  }
}
