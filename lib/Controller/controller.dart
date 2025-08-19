// import 'package:get/get.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:flutter/material.dart';

// class SurahPlayerController extends GetxController
//     with GetSingleTickerProviderStateMixin {
//   final FlutterTts tts = FlutterTts();

//   var bookmarkedVerses = <String>{}.obs;
//   var playingVerseId = RxnString(); // Track currently playing verse

//   late AnimationController animController;
//   late Animation<double> fadeAnimation;
//   late Animation<double> scaleAnimation;

//   @override
//   void onInit() {
//     super.onInit();
//     _setupTTS();

//     animController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 900),
//     );

//     fadeAnimation = CurvedAnimation(
//       parent: animController,
//       curve: Curves.easeIn,
//     );
//     scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
//       CurvedAnimation(parent: animController, curve: Curves.elasticOut),
//     );

//     animController.forward();
//   }

//   Future<void> _setupTTS() async {
//     await tts.setLanguage("ar-SA");
//     await tts.setPitch(1.0);
//     await tts.setVolume(1.0);
//     await tts.setSpeechRate(0.5);

//     tts.setCompletionHandler(() {
//       playingVerseId.value = null;
//     });
//   }

//   void toggleBookmark(String verseId) {
//     if (bookmarkedVerses.contains(verseId)) {
//       bookmarkedVerses.remove(verseId);
//     } else {
//       bookmarkedVerses.add(verseId);
//     }
//   }

//   void playVerse(String verseId, String text) async {
//     if (playingVerseId.value == verseId) {
//       await tts.stop();
//       playingVerseId.value = null;
//     } else {
//       await tts.stop();
//       playingVerseId.value = verseId;
//       await tts.speak(text);
//     }
//   }

//   @override
//   void onClose() {
//     animController.dispose();
//     tts.stop();
//     super.onClose();
//   }
// }
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
