import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class AudioController extends GetxController {
  final player = AudioPlayer();
  var isPlaying = false.obs;
  var currentSurah = ''.obs;

  Future<void> playSurah(String url, String surahName) async {
    try {
      await player.setUrl(url); // Surah audio path
      await player.play();
      currentSurah.value = surahName;
      isPlaying.value = true;
    } catch (e) {
      Get.snackbar("Error", "Unable to play audio: $e");
    }
  }

  Future<void> pauseSurah() async {
    await player.pause();
    isPlaying.value = false;
  }

  Future<void> stopSurah() async {
    await player.stop();
    isPlaying.value = false;
    currentSurah.value = '';
  }

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }
}
