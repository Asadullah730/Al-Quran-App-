import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quranapp/versesModel.dart';

class SurahScreen extends StatelessWidget {
  const SurahScreen({super.key});

  Future<List<Verse>> loadSurah() async {
    final String response = await rootBundle.loadString(
      'assets/surahs/surah_10.json',
    );
    final data = json.decode(response);
    if (data['verse'] == null) {
      throw Exception("No verses found in the JSON file");
    }
    final Map<String, dynamic> verses = data['verse'];
    List<Verse> verseList =
        verses.entries.map((entry) {
          return Verse(number: entry.key, text: entry.value);
        }).toList();

    return verseList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Surah Yunus")),
      body: FutureBuilder(
        future: loadSurah(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final verses = snapshot.data!;
            return ListView.builder(
              itemCount: verses.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Expanded(
                          child: Text(
                            verses[index].text,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontFamily: "Amiri",
                              fontSize: 22,
                              height: 2.0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.green.shade700,
                          child: Text(
                            verses[index].number.replaceAll("verse_", ""),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
