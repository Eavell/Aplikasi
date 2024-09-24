import 'package:eavell/beranda.dart';
import 'package:eavell/tiket.dart';
import 'package:flutter/material.dart';

class JadwalKapal extends StatefulWidget {
  const JadwalKapal({super.key});

  @override
  State<JadwalKapal> createState() => _JadwalKapalState();
}

class _JadwalKapalState extends State<JadwalKapal> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(58.0), // Tinggi AppBar
        child: Container(
          height: screenHeight *
              0.1, // Menyesuaikan tinggi AppBar dengan tinggi layar
          width: double.infinity, // Lebar AppBar, mengikuti lebar layar
          color: Color(0xFF4BBAE9), // Warna latar belakang AppBar
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: screenWidth * 0.04,
                    top: screenHeight * 0.030), // Mengatur posisi x dan y
                child: IconButton(
                  icon: Icon(Icons.arrow_back), // Ikon kembali bawaan Flutter
                  color: Colors.white, // Mengubah warna ikon menjadi putih
                  iconSize: screenWidth * 0.07, // Ukuran ikon
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Beranda()),
                    );
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.030),
                  child: Center(
                    child: Text(
                      'Jadwal Kapal',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                  width: screenWidth *
                      0.1), // Spacer untuk mengimbangi tombol kembali di kanan
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(
                    top: screenHeight *
                        0.02), // Mengatur margin atas agar tepat di bawah AppBar
                width: screenWidth * 0.6, // Lebar Container
                height: screenHeight * 0.029, // Tinggi Container
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), // Sudut melengkung
                  color: Color(0xff4BBAE9), // Warna latar belakang Container
                ),
                child: Center(
                  child: Text(
                    'Ulee Lheue - Balohan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
                height: screenHeight *
                    0.02), // Memberikan jarak antara dua Container
            Container(
              width: screenWidth * 0.9,
              height: screenHeight * 0.420,
              decoration: BoxDecoration(
                color: Color(0xff4BBAE9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 5.0, top: 0.0, right: 21.0, bottom: 23.0),
                child: Column(
                  children: [
                    _cardJadwalKapal(
                      screenWidth,
                      screenHeight,
                      "Jumat, 31 Mei 2024",
                      "Trip 1 Pukul 07.30 WIB AH2",
                      'assets/kapal 1.png',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Tiket(),
                          ),
                        );
                      },
                    ),
                    _cardJadwalKapal(
                      screenWidth,
                      screenHeight,
                      "Jumat, 31 Mei 2024",
                      "Trip 2 Pukul 10.30 WIB AH2",
                      'assets/kapal 1.png',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Tiket(),
                          ),
                        );
                      },
                    ),
                    _cardJadwalKapal(
                      screenWidth,
                      screenHeight,
                      "Jumat, 31 Mei 2024",
                      "Trip 3 Pukul 07.30 WIB BRR",
                      'assets/kapal 1.png',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Tiket(),
                          ),
                        );
                      },
                    ),
                    _cardJadwalKapal(
                      screenWidth,
                      screenHeight,
                      "Jumat, 31 Mei 2024",
                      "Trip 4 Pukul 07.30 WIB AH2",
                      'assets/kapal 1.png',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Tiket(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Container(
              width: screenWidth * 0.9,
              height: screenHeight * 0.330,
              decoration: BoxDecoration(
                color: Color(0xff4BBAE9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 5.0, top: 0.0, right: 21.0, bottom: 23.0),
                child: Column(
                  children: [
                    _cardJadwalKapal(
                      screenWidth,
                      screenHeight,
                      "Jumat, 31 Mei 2024",
                      "Trip 1 Pukul 07.30 WIB AH2",
                      'assets/kapal 1.png',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Tiket(),
                          ),
                        );
                      },
                    ),
                    _cardJadwalKapal(
                      screenWidth,
                      screenHeight,
                      "Jumat, 31 Mei 2024",
                      "Trip 2 Pukul 10.30 WIB AH2",
                      'assets/kapal 1.png',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Tiket(),
                          ),
                        );
                      },
                    ),
                    _cardJadwalKapal(
                      screenWidth,
                      screenHeight,
                      "Jumat, 31 Mei 2024",
                      "Trip 3 Pukul 07.30 WIB BRR",
                      'assets/kapal 1.png',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Tiket(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(
                    top: screenHeight *
                        0.02), // Mengatur margin atas agar tepat di bawah AppBar
                width: screenWidth * 0.6, // Lebar Container
                height: screenHeight * 0.029, // Tinggi Container
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), // Sudut melengkung
                  color: Color(0xff4BBAE9), // Warna latar belakang Container
                ),
                child: Center(
                  child: Text(
                    'Balohan - Ulee Lheue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Container(
              width: screenWidth * 0.9,
              height: screenHeight * 0.420,
              decoration: BoxDecoration(
                color: Color(0xff4BBAE9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 5.0, top: 0.0, right: 21.0, bottom: 23.0),
                child: Column(
                  children: [
                    _cardJadwalKapal(
                      screenWidth,
                      screenHeight,
                      "Jumat, 31 Mei 2024",
                      "Trip 1 Pukul 07.30 WIB AH2",
                      'assets/kapal 1.png',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Tiket(),
                          ),
                        );
                      },
                    ),
                    _cardJadwalKapal(
                      screenWidth,
                      screenHeight,
                      "Jumat, 31 Mei 2024",
                      "Trip 2 Pukul 10.30 WIB AH2",
                      'assets/kapal 1.png',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Tiket(),
                          ),
                        );
                      },
                    ),
                    _cardJadwalKapal(
                      screenWidth,
                      screenHeight,
                      "Jumat, 31 Mei 2024",
                      "Trip 3 Pukul 07.30 WIB BRR",
                      'assets/kapal 1.png',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Tiket(),
                          ),
                        );
                      },
                    ),
                    _cardJadwalKapal(
                      screenWidth,
                      screenHeight,
                      "Jumat, 31 Mei 2024",
                      "Trip 4 Pukul 07.30 WIB AH2",
                      'assets/kapal 1.png',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Tiket(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Container(
              width: screenWidth * 0.9,
              height: screenHeight * 0.330,
              decoration: BoxDecoration(
                color: Color(0xff4BBAE9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 5.0, top: 0.0, right: 21.0, bottom: 23.0),
                child: Column(
                  children: [
                    _cardJadwalKapal(
                      screenWidth,
                      screenHeight,
                      "Jumat, 31 Mei 2024",
                      "Trip 1 Pukul 07.30 WIB AH2",
                      'assets/kapal 1.png',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Tiket(),
                          ),
                        );
                      },
                    ),
                    _cardJadwalKapal(
                      screenWidth,
                      screenHeight,
                      "Jumat, 31 Mei 2024",
                      "Trip 2 10.30 WIB Exp Bahari 5F",
                      'assets/kapal 1.png',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Tiket(),
                          ),
                        );
                      },
                    ),
                    _cardJadwalKapal(
                      screenWidth,
                      screenHeight,
                      "Jumat, 31 Mei 2024",
                      "Trip 3 Pukul 07.30 WIB BRR",
                      'assets/kapal 1.png',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Tiket(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardJadwalKapal(
      screenWidth, screenHeight, date, title, imagePath, onClick) {
    return GestureDetector(
      onTap: onClick,
      child: SizedBox(
        width: double.infinity,
        height: 78.0,
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Positioned(
              top: 20.0,
              right: 0.0,
              child: Container(
                width: screenWidth * 0.8 - 16.0,
                height: screenHeight * 0.072,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            Positioned(
              left: -20.0,
              top: 0.0,
              child: Image.asset(
                imagePath, // URL gambar sebagai placeholder
                width: screenWidth * 0.5,
                height: screenWidth * 0.3,
              ),
            ),
            Positioned(
                top: 30.0,
                right: 10.0,
                child: Column(
                  children: [
                    Text(
                      date,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth * 0.030,
                      ),
                    ),
                  ],
                ))
              ],
            ),
          ),
        );
      }
    }
