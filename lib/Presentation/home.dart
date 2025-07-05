import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quranapp/Controller/surah_controller.dart';
import 'package:quranapp/Data/Surahs%20Path/surah_paths.dart';

import 'package:quranapp/Presentation/surah_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  SurahPaths path = SurahPaths();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quran App')),
      body: FutureBuilder(
        future: SurahController.loadName(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final surahs = snapshot.data!;
            if (kDebugMode) {
              print("SURAH NAME: ${surahs[1]['name']}");
            }
            return ListView.builder(
              itemCount: surahs.length,
              addAutomaticKeepAlives: true,
              addRepaintBoundaries: true,
              padding: const EdgeInsets.all(8.0),
              addSemanticIndexes: true,
              itemBuilder: (context, index) {
                final surah = surahs[index]; // ✅ Correct indexing
                return ListTile(
                  title: Text(
                    'Total Ayat: ${surah['name'] ?? 'Unknown'}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  subtitle: Text(
                    'Surah: ${surah['ayat'] ?? 'Unknown'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  trailing: Image.asset(
                    'assets/logo/quran_logo.jpeg',
                    width: 40,
                    height: 40,
                  ),
                  onTap: () {
                    if (kDebugMode) {
                      print(surah['path']);
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => SurahScreen(
                              surahPath: surah['path'] ?? '',
                              surahName: surah['name'] ?? '',
                            ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
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
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Quran App Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                // Handle about action
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_mail),
              title: Text('Contact Us'),
              onTap: () {
                // Handle contact action
              },
            ),
          ],
        ),
      ),
    );
  }
}
