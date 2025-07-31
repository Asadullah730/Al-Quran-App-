import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:quranapp/Data/Surahs%20Path/surah_paths.dart';
import 'package:quranapp/Model/versesModel.dart';

class SurahController {
  static Future<List<Verse>> loadSurah(String path) async {
    final String response = await rootBundle.loadString(path);
    final data = json.decode(response);
    if (data['verse'] == null) {
      throw Exception("No verses found in the JSON file");
    }
    final Map<String, dynamic> verses = data['verse'];
    List<Verse> verseList =
        verses.entries.map((entry) {
          return Verse(
            number: entry.key,
            text: entry.value,
            translation: '',
            audioUrl: '',
          );
        }).toList();

    return verseList;
  }

  static Future<List<Map<String, dynamic>>> loadName() async {
    List<String> paths = SurahPaths.paths;
    List<Map<String, dynamic>> allSurahs = [];

    for (int i = 1; i <= paths.length; i++) {
      final String response = await rootBundle.loadString(
        'assets/surahs/surah_$i.json',
      );

      if (kDebugMode) {
        print("Loading Surah $i");
      }

      final data = json.decode(response);

      if (data['name'] == null) {
        throw Exception("No verses found in the JSON file");
      }

      final String name = data['name'];
      final Map<String, dynamic> verses = data['verse'];

      List<Verse> verseList =
          verses.entries.map((entry) {
            return Verse(
              number: entry.key,
              text: entry.value,
              translation: '',
              audioUrl: '',
            );
          }).toList();

      final totalayat = data['count'];

      Map<String, dynamic> eachsurah = {
        'name': name,
        'verses': verseList,
        'ayat': totalayat,
        'path': "assets/surahs/surah_$i.json",
      };

      allSurahs.add(eachsurah);
    }

    if (kDebugMode) {
      print("Total Surahs Loaded: ${allSurahs.length}");
    }

    return allSurahs;
  }
}
