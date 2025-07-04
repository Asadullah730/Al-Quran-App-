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
                return ListTile(
                  title: Text(
                    "${verses[index].number}: ${verses[index].text}",
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontFamily: "Scheherazade",
                      fontSize: 20,
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
