import 'dart:ui';

// import 'package:eavell/beranda.dart';
import 'package:flutter/material.dart';

class PerkenalanSatu extends StatefulWidget {
  const PerkenalanSatu({Key? key}) : super(key: key);

  @override
  State<PerkenalanSatu> createState() => _PerkenalanSatuState();
}

class _PerkenalanSatuState extends State<PerkenalanSatu> {
  final List<String> imgList = [
    'assets/Perkenalan 1.png',
    'assets/Perkenalan 2.png',
    'assets/Perkenalan 3.png',
  ];

  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
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
            imgList[0],
            'Bersiaplah untuk memulai petualangan yang tak \nterlupakan',
          ),
          _buildIntroPage(
            context,
            imgList[1],
            'Menemukan Keajaiban sejarah dan Kekayaan Budaya di setiap langkahmu',
          ),
          _buildLastIntroPage(
            context,
            imgList[2],
            'Indahnya pemandangan dan lezatnya kuliner lokal yang menggugah selera',
          ),
        ],
      ),
    );
  }

  Widget _buildIntroPage(BuildContext context, String imagePath, String text) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 45,
          vertical: 23,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Spacer(),
            _buildIntroText(context, text),
          ],
        ),
      ),
    );
  }

  Widget _buildLastIntroPage(
      BuildContext context, String imagePath, String text) {
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
              horizontal: 45,
              vertical: 23,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Spacer(),
                _buildIntroText(context, text),
              ],
            ),
          ),
          Positioned(
            bottom: 35,
            right: 60,
            child: ElevatedButton(
              onPressed: () {
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(builder: (context) => const Beranda()),
                // );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color(0xFF69857C), // Warna latar belakang tombol
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

  Widget _buildIntroText(BuildContext context, String text) {
    return SizedBox(
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                height: 222,
                width: 304,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFF5A6A65).withOpacity(0.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 18,
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
