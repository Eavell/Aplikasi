// import 'package:eavell/beranda.dart';
import 'package:eavell/beranda.dart';
import 'package:eavell/deskripsi_paket.dart';
import 'package:flutter/material.dart';

class PaketTravel extends StatefulWidget {
  const PaketTravel({super.key});

  @override
  State<PaketTravel> createState() => _PaketTravelState();
}

class _PaketTravelState extends State<PaketTravel> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(58.0), // Tinggi AppBar
        child: Container(
          height: 170.0, // Tinggi AppBar
          width: double.infinity, // Lebar AppBar, mengikuti lebar layar
          color: Color(0xFF4BBAE9), // Warna latar belakang AppBar
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.04, top: 35.0), // Mengatur posisi x dan y
                child: IconButton(
                  icon: Icon(Icons.arrow_back), // Ikon kembali bawaan Flutter
                  color: Colors.white, // Mengubah warna ikon menjadi putih
                  iconSize: screenWidth * 0.07, // Ukuran ikon
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Beranda()),);
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 35.0), // Menyamakan posisi y dengan ikon kembali
                  child: Center(
                    child: Text(
                      'Paket Travel',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.1), // Spacer untuk mengimbangi tombol kembali di kanan
            ],
          ),
        ),
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Posisi di bagian atas
            crossAxisAlignment: CrossAxisAlignment.center, // Tengah secara horizontal
            children: [
              SizedBox(height: screenWidth * 0.03),
              TravelPackageCard(
                imagePath: 'assets/diamond.png',
                packageName: 'Paket Diamond',
                packagePrice: 'Rp 950.000 - Rp 1.600.000',
                screenWidth: screenWidth,
                description: 'Deskripsi Paket Diamond',
              ),
              SizedBox(height: screenWidth * 0.05), // Jarak antara Box 1 dan Box 2
              TravelPackageCard(
                imagePath: 'assets/gold.png',
                packageName: 'Paket Gold',
                packagePrice: 'Rp 550.000 - Rp 950.000 ',
                screenWidth: screenWidth,
                description: 'Deskripsi Paket Gold',
              ),
              SizedBox(height: screenWidth * 0.05), // Jarak antara Box 2 dan Box 3
              TravelPackageCard(
                imagePath: 'assets/silver.png',
                packageName: 'Paket Silver',
                packagePrice: 'Rp 250.000 - Rp 550.000',
                screenWidth: screenWidth,
                description: 'Deskripsi Paket Silver',
              ),
            ],
          ),
        ),
      );
    }
  }

class TravelPackageCard extends StatelessWidget {
  final String imagePath;
  final String packageName;
  final String packagePrice;
  final double screenWidth;
  final String description;

  const TravelPackageCard({
    required this.imagePath,
    required this.packageName,
    required this.packagePrice,
    required this.screenWidth,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Material(
          elevation: 5,
          shadowColor: Colors.black26,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: screenWidth * 0.8,
            height: screenWidth * 0.56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), // Sudut melengkung
              boxShadow: [
                BoxShadow(
                  color: Colors.black26, // Warna bayangan
                  blurRadius: 5, // Jarak blur bayangan
                  offset: Offset(0, 4), // Posisi bayangan
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push( context, MaterialPageRoute(builder: (context) => DeskripsiPaketPage(imagePath : imagePath, packageName : packageName, packagePrice : packagePrice, description : description)),);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Warna latar belakang
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Sudut melengkung
                ),
                padding: EdgeInsets.zero, // Menghapus padding default
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: screenWidth * 0.45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage(imagePath),
                        fit: BoxFit.cover, // Mengisi seluruh area yang tersedia
                      ),
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.03),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          packageName,
                          style: TextStyle(
                            color: Colors.black, // Warna teks
                            fontSize: screenWidth * 0.035, // Ukuran font
                            fontWeight: FontWeight.w500, // Ketebalan font
                          ),
                        ),
                        Text(
                          packagePrice,
                          style: TextStyle(
                            color: Color(0xFF7F7F7F), // Warna teks
                            fontSize: screenWidth * 0.03, // Ukuran font
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
