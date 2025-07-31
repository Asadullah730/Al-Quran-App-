import 'package:flutter/material.dart';
import 'package:quranapp/Controller/surah_controller.dart';
import 'dart:collection';

class SurahScreen extends StatefulWidget {
  final String surahPath;
  final String surahName;

  const SurahScreen({
    super.key,
    required this.surahPath,
    required this.surahName,
  });

  @override
  State<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final Set<String> _bookmarkedVerses = HashSet();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _controller.forward();
  }

  void toggleBookmark(String verseId) {
    setState(() {
      if (_bookmarkedVerses.contains(verseId)) {
        _bookmarkedVerses.remove(verseId);
      } else {
        _bookmarkedVerses.add(verseId);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool shouldShowBismillah(String name) {
    return name != "At-Tawbah";
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(
          'Surah ${widget.surahName}',
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
      body: FutureBuilder(
        future: SurahController.loadSurah(widget.surahPath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.green),
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
                      if (shouldShowBismillah(widget.surahName))
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
                      ...verses
                          .asMap()
                          .entries
                          .where((entry) => entry.key != 0)
                          .map((entry) {
                            final index = entry.key;
                            final verse = entry.value;
                            final isFirst = index == 0;
                            final verseId = verse.number;

                            final verseWidget = RichText(
                              textDirection: TextDirection.rtl,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: verse.text + " ",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontFamily: isFirst ? 'Amiri' : 'Uthman',
                                      color: Colors.black87,
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
                            );

                            return AnimatedBuilder(
                              animation: _controller,
                              builder: (context, child) {
                                final decorated = Container(
                                  padding: const EdgeInsets.all(12),
                                  margin: const EdgeInsets.only(bottom: 18),
                                  decoration:
                                      isFirst
                                          ? BoxDecoration(
                                            color: Colors.green.shade50,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            border: Border.all(
                                              color: Colors.green.shade400,
                                            ),
                                          )
                                          : null,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(child: verseWidget),
                                      IconButton(
                                        icon: Icon(
                                          _bookmarkedVerses.contains(verseId)
                                              ? Icons.bookmark
                                              : Icons.bookmark_border,
                                          color: Colors.green,
                                        ),
                                        onPressed:
                                            () => toggleBookmark(verseId),
                                      ),
                                    ],
                                  ),
                                );

                                if (isFirst) {
                                  return FadeTransition(
                                    opacity: _fadeAnimation,
                                    child: ScaleTransition(
                                      scale: _scaleAnimation,
                                      child: decorated,
                                    ),
                                  );
                                } else {
                                  return decorated;
                                }
                              },
                            );
                          })
                          .toList(),
                    ],
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
