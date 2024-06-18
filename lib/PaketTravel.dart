import 'package:eavell/perkenalan.dart';
import 'package:flutter/material.dart';

class PaketTravel extends StatefulWidget {
  const PaketTravel({super.key});

  @override
  State<PaketTravel> createState() => _PaketTravelState();
}

class _PaketTravelState extends State<PaketTravel> {
  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.only(left: 16.0, top: 35.0), // Mengatur posisi x dan y
            child: IconButton(
              icon: Icon(Icons.arrow_back), // Ikon kembali bawaan Flutter
              color: Colors.white, // Mengubah warna ikon menjadi putih
              iconSize: 28, // Ukuran ikon
              onPressed: () {
                Navigator.push( context, MaterialPageRoute(builder: (context) => Beranda()),);
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
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
              SizedBox(width: 48), // Spacer untuk mengimbangi tombol kembali di kanan
            ],
          ),
        ),
      ),

        body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Posisi di bagian atas
            crossAxisAlignment: CrossAxisAlignment.center, // Tengah secara horizontal
            children: [

              SizedBox(height: 13),
              Stack(
                children: [
                  Material(
                    elevation: 5,
                    shadowColor: Colors.black26,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 304,
                      height: 225,
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
                          Navigator.push( context, MaterialPageRoute(builder: (context) => PaketDiamond()),);
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
                              height: 170,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: AssetImage('assets/diamond.png'),
                                  fit: BoxFit.cover, // Mengisi seluruh area yang tersedia
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Paket Platinum',
                                    style: TextStyle(
                                      color: Colors.black, // Warna teks
                                      fontSize: 12, // Ukuran font
                                      fontWeight: FontWeight.w500, // Ketebalan font
                                    ),
                                  ),
                                  Text(
                                    'Rp 950.000 - Rp 1.600.000',
                                    style: TextStyle(
                                      color: Color(0xFF7F7F7F), // Warna teks
                                      fontSize: 12, // Ukuran font
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
              ),

              SizedBox(height: 20), // Jarak antara Box 1 dan Box 2
              Stack(
                children: [
                  Material(
                    elevation: 5,
                    shadowColor: Colors.black26,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 304,
                      height: 225,
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
                          Navigator.push( context, MaterialPageRoute(builder: (context) => PaketGold()),);
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
                              height: 170,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: AssetImage('assets/gold.png'),
                                  fit: BoxFit.cover, // Mengisi seluruh area yang tersedia
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Paket Gold',
                                    style: TextStyle(
                                      color: Colors.black, // Warna teks
                                      fontSize: 12, // Ukuran font
                                      fontWeight: FontWeight.w500, // Ketebalan font
                                    ),
                                  ),
                                  Text(
                                    'Rp 950.000 - Rp 1.600.000',
                                    style: TextStyle(
                                      color: Color(0xFF7F7F7F), // Warna teks
                                      fontSize: 12, // Ukuran font
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
              ),

              SizedBox(height: 20), // Jarak antara Box 2 dan Box 3
              Stack(
                children: [
                  Material(
                    elevation: 5,
                    shadowColor: Colors.black26,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 304,
                      height: 225,
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
                          Navigator.push( context, MaterialPageRoute(builder: (context) => PaketSilver()),);
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
                              height: 170,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: AssetImage('assets/silver.png'),
                                  fit: BoxFit.cover, // Mengisi seluruh area yang tersedia
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Paket Silver',
                                    style: TextStyle(
                                      color: Colors.black, // Warna teks
                                      fontSize: 12, // Ukuran font
                                      fontWeight: FontWeight.w500, // Ketebalan font
                                    ),
                                  ),
                                  Text(
                                    'Rp 950.000 - Rp 1.600.000',
                                    style: TextStyle(
                                      color: Color(0xFF7F7F7F), // Warna teks
                                      fontSize: 12, // Ukuran font
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}