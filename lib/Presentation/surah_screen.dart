// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:quranapp/Controller/surah_controller.dart';
// import 'package:quranapp/Model/versesModel.dart';

// class SurahScreen extends StatelessWidget {
//   final String surahPath;
//   final String surahName;
//   const SurahScreen({
//     super.key,
//     required this.surahPath,
//     required this.surahName,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Surah - $surahName',
//           style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.green.shade700,
//       ),
//       body: FutureBuilder(
//         future: SurahController.loadSurah(surahPath),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           } else {
//             final verses = snapshot.data!;
//             return ListView.builder(
//               itemCount: verses.length,
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 12.0,
//                     vertical: 8.0,
//                   ),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.2),
//                           spreadRadius: 1,
//                           blurRadius: 6,
//                           offset: const Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     padding: const EdgeInsets.all(16),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,

//                       children: [
//                         Expanded(
//                           child: Text(
//                             verses[index].text,
//                             textAlign: TextAlign.right,
//                             style: const TextStyle(
//                               fontFamily: "Amiri",
//                               fontSize: 22,
//                               height: 2.0,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         CircleAvatar(
//                           radius: 16,
//                           backgroundColor: Colors.green.shade700,
//                           child: Text(
//                             verses[index].number.replaceAll("verse_", ""),
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
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
          'سورة $surahName',
          style: const TextStyle(
            fontSize: 24,
            fontFamily: 'Uthman',
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
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
                  color: const Color(0xFF2C2C2C),
                  border: Border.all(color: Colors.white, width: 1.5),
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
                                    fontSize: 26,
                                    fontFamily: 'Uthman',
                                    color: Colors.white,
                                    height: 2,
                                  ),
                                ),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Container(
                                    width: 36,
                                    height: 36,

                                    child: Center(
                                      child: Text(
                                        verse.number.replaceAll("verse_", ""),
                                        style: const TextStyle(
                                          fontSize: 14,
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
