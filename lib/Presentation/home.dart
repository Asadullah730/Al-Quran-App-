import 'package:flutter/material.dart';
import 'package:quranapp/Controller/surah_controller.dart';
import 'package:quranapp/Data/Surahs%20Path/surah_paths.dart';
import 'package:quranapp/Presentation/surah_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SurahPaths path = SurahPaths();
  bool showGrid = false;

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
          IconButton(
            icon: Icon(showGrid ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                showGrid = !showGrid;
              });
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: SurahController.loadName(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final surahs = snapshot.data!;
            return showGrid
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
                              Image.asset(
                                'assets/logo/quran_logo.jpeg',
                                width: screenWidth * 0.1,
                                height: screenWidth * 0.1,
                              ),
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
                      trailing: Image.asset(
                        'assets/logo/quran_logo.jpeg',
                        width: screenWidth * 0.08,
                        height: screenWidth * 0.08,
                      ),
                      onTap: () {
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
