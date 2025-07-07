import 'package:flutter/material.dart';
import 'package:quranapp/Controller/surah_controller.dart';

class SurahScreen extends StatelessWidget {
  final String surahPath;
  final String surahName;

  const SurahScreen({
    super.key,
    required this.surahPath,
    required this.surahName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C), // Dark background
      appBar: AppBar(
        title: Text(
          'Surah $surahName',
          style: const TextStyle(
            fontSize: 24,
            fontFamily: 'Uthman',
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        // backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: SurahController.loadSurah(surahPath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            final verses = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black54, width: 1.5),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Wrap(
                    textDirection: TextDirection.rtl,
                    alignment: WrapAlignment.end,
                    runSpacing: 12,
                    children:
                        verses.map((verse) {
                          return RichText(
                            textDirection: TextDirection.rtl,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: verse.text + " ",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Uthman',
                                    color: Colors.black,
                                    height: 1.5,
                                  ),
                                ),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.top,
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                        color: Colors.black54,
                                        width: 1,
                                      ),
                                    ),

                                    child: Center(
                                      child: Text(
                                        verse.number.replaceAll("verse_", ""),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const TextSpan(text: " "),
                              ],
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
