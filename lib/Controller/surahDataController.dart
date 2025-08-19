import 'package:get/get.dart';
import 'package:quranapp/Controller/surah_controller.dart';

class SurahDataController extends GetxController {
  var verses = [].obs;
  var isLoading = true.obs;
  var error = ''.obs;

  Future<void> loadSurah(String path) async {
    try {
      isLoading.value = true;
      error.value = '';
      final data = await SurahController.loadSurah(path);
      if (data.isEmpty) {
        throw Exception("No verses found in the JSON file");
      }
      print("SURAH DATA TRY TO LOAD : $data");
      verses.assignAll(data);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
