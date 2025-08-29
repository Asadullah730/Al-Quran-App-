import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';

class SurahPlayerController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final AudioPlayer audioPlayer = AudioPlayer();

  var bookmarkedVerses = <String>{}.obs;
  var playingVerseId = RxnString();

  late AnimationController animController;
  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;

  @override
  void onInit() {
    super.onInit();

    animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    fadeAnimation = CurvedAnimation(
      parent: animController,
      curve: Curves.easeIn,
    );
    scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: animController, curve: Curves.elasticOut),
    );

    animController.forward();

    audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        playingVerseId.value = null;
      }
    });
  }

  void toggleBookmark(String verseId) {
    if (bookmarkedVerses.contains(verseId)) {
      bookmarkedVerses.remove(verseId);
    } else {
      bookmarkedVerses.add(verseId);
    }
  }

  Future<void> playVerse(String verseId, String url) async {
    if (playingVerseId.value == verseId) {
      await audioPlayer.stop();
      playingVerseId.value = null;
    } else {
      await audioPlayer.stop();
      playingVerseId.value = verseId;

      await audioPlayer.setUrl(
        "https://freequranmp3.com/sudais/001-al-fatihah.mp3",
      ); // scholar audio file link
      await audioPlayer.play();
    }
  }

  @override
  void onClose() {
    animController.dispose();
    audioPlayer.dispose();
    super.onClose();
  }
}
