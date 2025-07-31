class SurahPaths {
  static List<String> paths = List.generate(
    114,
    (index) => "assets/surahs/surah_${index + 1}.json",
  );

  static List<String> getPaths() {
    return List.unmodifiable(paths);
  }

  static void clearPaths() {
    paths.clear();
  }
}
