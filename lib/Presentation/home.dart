import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quranapp/Controller/audioController.dart';
import 'package:quranapp/Controller/home_controller.dart';
import 'package:quranapp/Presentation/surah_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final homeController = Get.put(HomeController());
  final audioController = Get.put(AudioController()); // ✅ Audio Controller

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    int crossAxisCount = (screenWidth ~/ 180).clamp(2, 4);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Al-Quran App'),
        centerTitle: true,
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                homeController.showGrid.value
                    ? Icons.view_list
                    : Icons.grid_view,
              ),
              onPressed: homeController.toggleView,
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (homeController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (homeController.error.isNotEmpty) {
          return Center(child: Text("Error: ${homeController.error}"));
        }

        final surahs = homeController.surahs;

        return homeController.showGrid.value
            ? GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: surahs.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: isTablet ? 1 : 2 / 2,
              ),
              itemBuilder: (context, index) {
                final surah = surahs[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () {
                      Get.to(
                        () => SurahScreen(
                          surahPath: surah['path'] ?? '',
                          surahName: surah['name'] ?? '',
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.green,
                            radius: screenWidth * 0.035,
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.035,
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            surah['name'] ?? 'Unknown',
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Ayat: ${surah['ayat'] ?? 'Unknown'}',
                            style: TextStyle(fontSize: screenWidth * 0.030),
                          ),
                          const SizedBox(height: 2),
                          Obx(() {
                            bool isPlaying =
                                audioController.isPlaying.value &&
                                audioController.currentSurah.value ==
                                    surah['name'];

                            return IconButton(
                              icon: Icon(
                                isPlaying
                                    ? Icons.pause_circle
                                    : Icons.play_circle,
                                color: Colors.green,
                                size: screenWidth * 0.08,
                              ),
                              onPressed: () {
                                if (isPlaying) {
                                  audioController.pauseSurah();
                                } else {
                                  audioController.playSurah(
                                    surah['link'] ?? '',
                                    surah['name'] ?? '',
                                  );
                                }
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
            : ListView.builder(
              itemCount: surahs.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final surah = surahs[index];
                return ListTile(
                  title: Text(
                    'Surah: ${surah['name'] ?? 'Unknown'}',
                    style: TextStyle(fontSize: screenWidth * 0.035),
                  ),
                  subtitle: Text(
                    'Total Ayat: ${surah['ayat'] ?? 'Unknown'}',
                    style: TextStyle(fontSize: screenWidth * 0.04),
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: screenWidth * 0.04,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.035,
                      ),
                    ),
                  ),
                  trailing: Obx(() {
                    bool isPlaying =
                        audioController.isPlaying.value &&
                        audioController.currentSurah.value == surah['name'];

                    return IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.volume_up,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        if (isPlaying) {
                          audioController.pauseSurah();
                        } else {
                          audioController.playSurah(
                            "https://freequranmp3.com/sudais/001-al-fatihah.mp3",
                            surah['name'] ?? '',
                          );
                        }
                      },
                    );
                  }),
                  onTap: () {
                    Get.to(
                      () => SurahScreen(
                        surahPath: surah['path'] ?? '',
                        surahName: surah['name'] ?? '',
                      ),
                    );
                  },
                );
              },
            );
      }),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Quran'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          // Handle navigation
        },
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Quran App Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(leading: Icon(Icons.info), title: Text('About')),
            ListTile(
              leading: Icon(Icons.contact_mail),
              title: Text('Contact Us'),
            ),
          ],
        ),
      ),
    );
  }
}
