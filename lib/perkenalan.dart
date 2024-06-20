import 'dart:ui';
// import 'package:eavell/beranda.dart';
import 'package:eavell/beranda.dart';
import 'package:eavell/daftar.dart';
import 'package:flutter/material.dart';

class Perkenalan extends StatefulWidget {
  const Perkenalan({Key? key}) : super(key: key);

  @override
  State<Perkenalan> createState() => _PerkenalanState();
}

class _PerkenalanState extends State<Perkenalan> {
  final List<String> imgList = [
    'assets/Perkenalan_1.jpg',
    'assets/Perkenalan_2.jpg',
    'assets/Perkenalan_3.jpg',
  ];

  final PageController _pageController = PageController();
  int _currentIndex = 0;

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
        children: [
          _buildIntroPage(
            context,
            screenWidth,
            screenHeight,
            imgList[0],
            'Bersiaplah untuk memulai petualangan yang tak \nterlupakan',
          ),
          _buildIntroPage(
            context,
            screenWidth,
            screenHeight,
            imgList[1],
            'Menemukan Keajaiban sejarah dan Kekayaan Budaya di setiap langkahmu',
          ),
          _buildLastIntroPage(
            context,
            screenWidth,
            screenHeight,
            imgList[2],
            'Indahnya pemandangan dan lezatnya kuliner lokal yang menggugah selera',
          ),
        ],
      ),
    );
  }

  Widget _buildIntroPage(BuildContext context, double screenWidth, double screenHeight, String imagePath, String text) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
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
          image: AssetImage(imagePath),
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
                  MaterialPageRoute(builder: (context) => const Daftar()),
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
              children: List.generate(3, (index) {
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
