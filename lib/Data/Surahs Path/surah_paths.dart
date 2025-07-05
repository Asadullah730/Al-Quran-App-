class SurahPaths {
  static final List<String> paths = [
    "assets/surahs/surah_1.json",
    "assets/surahs/surah_2.json",
    "assets/surahs/surah_3.json",
    "assets/surahs/surah_4.json",
    "assets/surahs/surah_5.json",
    "assets/surahs/surah_6.json",
    "assets/surahs/surah_7.json",
    "assets/surahs/surah_8.json",
    "assets/surahs/surah_9.json",
    "assets/surahs/surah_10.json",
  ];

  static List<String> getPaths() {
    return List.unmodifiable(paths);
  }

  static void clearPaths() {
    paths.clear();
  }
}
