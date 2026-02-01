import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/painting_model.dart';

class PaintingController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  var paintings = <PaintingModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPaintings();
  }

  Future<void> fetchPaintings() async {
    try {
      isLoading.value = true;

      final response = await supabase
          .from('paintings')
          .select()
          .order('created_at', ascending: false);

      paintings.value = (response as List)
          .map((data) => PaintingModel.fromMap(data))
          .toList();
    } catch (e) {
      Get.snackbar('خطأ', 'فشل تحميل اللوحات');
    } finally {
      isLoading.value = false;
    }
  }
}