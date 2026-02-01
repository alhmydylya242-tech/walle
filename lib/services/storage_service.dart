import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageService {
  static final _supabase = Supabase.instance.client;

  static Future<String?> uploadImage(File file) async {
    try {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';

      await _supabase.storage
          .from('paintings')
          .upload(fileName, file);

      final imageUrl =
      _supabase.storage.from('paintings').getPublicUrl(fileName);

      return imageUrl;
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }
}