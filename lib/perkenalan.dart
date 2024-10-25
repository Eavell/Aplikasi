import 'dart:ui';
import 'package:TripNest/masuk.dart';
import 'package:flutter/material.dart';

class Perkenalan extends StatefulWidget {
  const Perkenalan({Key? key}) : super(key: key);

  @override
  State<Perkenalan> createState() => _PerkenalanState();
}

class _PerkenalanState extends State<Perkenalan> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  // List yang akan menampung path gambar dari lokal
  final List<String> imgPaths = [
    'assets/Perkenalan_1.png',
    'assets/Perkenalan_2.png',
    'assets/Perkenalan_3.png',
  ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: imgPaths.map((path) {
          // Sesuaikan teks berdasarkan urutan gambar
          int index = imgPaths.indexOf(path);
          String text;
          if (index == 0) {
            text = 'Bersiaplah untuk memulai petualangan yang tak \nterlupakan';
          } else if (index == 1) {
            text = 'Menemukan Keajaiban sejarah dan Kekayaan Budaya di setiap langkahmu';
          } else {
            text = 'Indahnya pemandangan dan lezatnya kuliner lokal yang menggugah selera';
          }

          if (index == imgPaths.length - 1) {
            return _buildLastIntroPage(context, screenWidth, screenHeight, path, text);
          } else {
            return _buildIntroPage(context, screenWidth, screenHeight, path, text);
          }
        }).toList(),
      ),
    );
  }

  Widget _buildIntroPage(BuildContext context, double screenWidth, double screenHeight, String imagePath, String text) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath), // Gambar diambil dari lokal (aset)
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.1,
          vertical: screenHeight * 0.05,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Spacer(),
            _buildIntroText(context, screenWidth, screenHeight, text),
          ],
        ),
      ),
    );
  }

  Widget _buildLastIntroPage(BuildContext context, double screenWidth, double screenHeight, String imagePath, String text) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath), // Gambar diambil dari lokal (aset)
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.1,
              vertical: screenHeight * 0.05,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Spacer(),
                _buildIntroText(context, screenWidth, screenHeight, text),
              ],
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.06,
            right: screenWidth * 0.15,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Masuk()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF69857C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                'Mulai',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroText(BuildContext context, double screenWidth, double screenHeight, String text) {
    return SizedBox(
      width: screenWidth * 0.8,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                height: screenHeight * 0.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFF5A6A65).withOpacity(0.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 25,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(imgPaths.length, (index) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index
                        ? Color(0xFFFFFFFF)
                        : Color(0xFFFFFFFF).withOpacity(0.5),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
