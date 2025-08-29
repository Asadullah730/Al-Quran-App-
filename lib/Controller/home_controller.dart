// Controller for HomeScreen
import 'package:get/get.dart';
import 'package:quranapp/Controller/surah_controller.dart';

class HomeController extends GetxController {
  var showGrid = false.obs;
  var surahs = [].obs;
  var isLoading = true.obs;
  var error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadSurahs();
  }

  void toggleView() {
    showGrid.value = !showGrid.value;
  }

  Future<void> loadSurahs() async {
    try {
      isLoading.value = true;
      final data = await SurahController.loadName();
      surahs.assignAll(data);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
