import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quranapp/Controller/controller.dart';
import 'package:quranapp/Controller/surahDataController.dart';
import 'package:quranapp/Controller/surah_controller.dart';

class SurahScreen extends StatelessWidget {
  final String surahPath;
  final String surahName;

  const SurahScreen({
    super.key,
    required this.surahPath,
    required this.surahName,
  });

  bool shouldShowBismillah(String name) => name != "At-Tawbah";

  @override
  Widget build(BuildContext context) {
    final playerController = Get.put(SurahPlayerController());
    final dataController = Get.put(SurahDataController());

    // load verses when screen opens
    dataController.loadSurah(surahPath);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(
          'Surah $surahName',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Uthman',
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
        elevation: 4,
      ),
      body: Obx(() {
        if (dataController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.green),
          );
        }
        if (dataController.error.isNotEmpty) {
          return Center(
            child: Text(
              "Error: ${dataController.error.value}",
              style: const TextStyle(color: Colors.white),
            ),
          );
        }
        final verses = dataController.verses;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (shouldShowBismillah(surahName))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Center(
                        child: Text(
                          '﷽',
                          style: TextStyle(
                            fontSize: 42,
                            fontFamily: 'Uthman',
                            color: Colors.deepPurple.shade700,
                          ),
                        ),
                      ),
                    ),
                  ...verses.asMap().entries.map((entry) {
                    final index = entry.key;
                    final verse = entry.value;
                    final isFirst = index == 0;
                    final verseId = verse.number;

                    final verseWidget = Obx(
                      () => RichText(
                        textDirection: TextDirection.rtl,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: verse.text + " ",
                              style: TextStyle(
                                fontSize: 22,
                                fontFamily: isFirst ? 'Amiri' : 'Uthman',
                                color:
                                    playerController.playingVerseId.value ==
                                            verseId
                                        ? Colors.red
                                        : Colors.black87,
                                height: 1.2,
                              ),
                            ),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Container(
                                margin: const EdgeInsets.only(left: 1),
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.green,
                                    width: 1.2,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    verse.number.replaceAll("verse_", ""),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );

                    return AnimatedBuilder(
                      animation: playerController.animController,
                      builder: (context, child) {
                        final decorated = Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 18),
                          decoration:
                              isFirst
                                  ? BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.green.shade400,
                                    ),
                                  )
                                  : null,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: verseWidget),
                              Obx(
                                () => IconButton(
                                  icon: Icon(
                                    playerController.bookmarkedVerses.contains(
                                          verseId,
                                        )
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    color: Colors.green,
                                  ),
                                  onPressed:
                                      () => playerController.toggleBookmark(
                                        verseId,
                                      ),
                                ),
                              ),
                              Obx(
                                () => IconButton(
                                  icon: Icon(
                                    playerController.playingVerseId.value ==
                                            verseId
                                        ? Icons.stop
                                        : Icons.volume_up,
                                    color: Colors.red,
                                  ),
                                  onPressed:
                                      () => playerController.playVerse(
                                        verseId,
                                        verse.text,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (isFirst) {
                          return FadeTransition(
                            opacity: playerController.fadeAnimation,
                            child: ScaleTransition(
                              scale: playerController.scaleAnimation,
                              child: decorated,
                            ),
                          );
                        } else {
                          return decorated;
                        }
                      },
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
