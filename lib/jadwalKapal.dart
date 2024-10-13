import 'package:eavell/beranda.dart';
import 'package:eavell/tiket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JadwalKapal extends StatefulWidget {
  const JadwalKapal({super.key});

  @override
  State<JadwalKapal> createState() => _JadwalKapalState();
}

class _JadwalKapalState extends State<JadwalKapal> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(58.0),
        child: Container(
          height: screenHeight * 0.1,
          width: double.infinity,
          color: const Color(0xFF4BBAE9),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: screenWidth * 0.04,
                    top: screenHeight * 0.030),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.white,
                  iconSize: screenWidth * 0.07,
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
              SizedBox(width: screenWidth * 0.1),
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
                margin: EdgeInsets.only(top: screenHeight * 0.02),
                width: screenWidth * 0.6,
                height: screenHeight * 0.029,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xff4BBAE9),
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
            SizedBox(height: screenHeight * 0.02),
            // StreamBuilder untuk Ship Schedule
            Container(
  width: screenWidth * 0.9,
  height: screenHeight * 0.420,
  decoration: BoxDecoration(
    color: Color(0xff4BBAE9),
    borderRadius: BorderRadius.circular(15),
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 4.0,
        offset: Offset(0, 2),
      ),
    ],
  ),
  child: Padding(
    padding: const EdgeInsets.only(left: 5.0, top: 0.0, right: 21.0, bottom: 23.0),
    child: StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('ship_schedule').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        // Memetakan data dokumen menjadi list widget
        return SingleChildScrollView(
          child: Column(
            children: snapshot.data!.docs.map((document) {
              // Mendapatkan data untuk card 1
              String date1 = document['date1'] ?? 'Tanggal Tidak Diketahui';
              String image1 = document['image1'] ?? 'assets/kapal 1.png'; // Gambar default
              String schedule1 = document['schedule1'] ?? 'Jadwal Tidak Diketahui';

              // Mendapatkan data untuk card 2 (ini masih berasal dari dokumen yang sama)
              String date2 = document['date2'] ?? 'Tanggal Tidak Diketahui';
              String image2 = document['image2'] ?? 'assets/kapal 1.png'; // Gambar default
              String schedule2 = document['schedule2'] ?? 'Jadwal Tidak Diketahui';

              // Mendapatkan data untuk card 3
              String date3 = document['date3'] ?? 'Tanggal Tidak Diketahui';
              String image3 = document['image3'] ?? 'assets/kapal 1.png'; // Gambar default
              String schedule3 = document['schedule3'] ?? 'Jadwal Tidak Diketahui';

              // Mendapatkan data untuk card 4
              String date4 = document['date4'] ?? 'Tanggal Tidak Diketahui';
              String image4 = document['image4'] ?? 'assets/kapal 1.png'; // Gambar default
              String schedule4 = document['schedule4'] ?? 'Jadwal Tidak Diketahui';

              // Mengembalikan beberapa card dalam Column
              return Column(
                children: [
                  _cardJadwalKapal(
                    screenWidth,
                    screenHeight,
                    date1,
                    schedule1,
                    image1,
                    () {
                      // Aksi ketika card 1 diklik
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Tiket(
                            date: date1,       // Kirimkan date dari Firestore
                            schedule: schedule1, // Kirimkan schedule di sini
                          ),
                        ),
                      );
                    },
                  ),
                  _cardJadwalKapal(
                    screenWidth,
                    screenHeight,
                    date2,
                    schedule2,
                    image2,
                    () {
                      // Aksi ketika card 2 diklik
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Tiket(
                            date: date2,       // Kirimkan date dari Firestore
                            schedule: schedule2, // Kirimkan schedule di sini
                          ),
                        ),
                      );
                    },
                  ),
                  // Tambahkan card lainnya jika diperlukan
                  _cardJadwalKapal(
                    screenWidth,
                    screenHeight,
                    date3,
                    schedule3,
                    image3,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Tiket(
                            date: date3,       // Kirimkan date dari Firestore
                            schedule: schedule3, // Kirimkan schedule di sini
                          ),
                        ),
                      );
                    },
                  ),
                  _cardJadwalKapal(
                    screenWidth,
                    screenHeight,
                    date4,
                    schedule4,
                    image4,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Tiket(
                            date: date4,       // Kirimkan date dari Firestore
                            schedule: schedule4, // Kirimkan schedule di sini
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            }).toList(),  // Konversi Iterable menjadi List
          ),
        );
      },
    ),
  ),
),


            SizedBox(height: screenHeight * 0.02),

            Container(
              width: screenWidth * 0.9,
              height: screenHeight * 0.330,
              decoration: BoxDecoration(
                color: Color(0xff4BBAE9),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4.0,
                    offset: Offset(0, 2),
                  ),
                ]
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 5.0, top: 0.0, right: 21.0, bottom: 23.0),
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('ship_schedule').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // Memetakan data dokumen menjadi list widget
                    return Column(
                      children: snapshot.data!.docs.map((document) {
                        // Mendapatkan data untuk card 1
                        String date5 = document['date5'] ?? 'Tanggal Tidak Diketahui';
                        String image5 = document['image3'] ?? 'assets/kapal 1.png'; // Gambar default
                        String schedule5 = document['schedule5'] ?? 'Jadwal Tidak Diketahui';

                        // Mendapatkan data untuk card 2
                        String date6 = document['date6'] ?? 'Tanggal Tidak Diketahui'; // Pastikan ini field yang benar
                        String image6 = document['image4'] ?? 'assets/kapal 1.png'; // Gambar default
                        String schedule6 = document['schedule6'] ?? 'Jadwal Tidak Diketahui'; // Pastikan ini field yang benar

                        // Mendapatkan data untuk card 2
                        String date7 = document['date7'] ?? 'Tanggal Tidak Diketahui'; // Pastikan ini field yang benar
                        String image7 = document['image5'] ?? 'assets/kapal 1.png'; // Gambar default
                        String schedule7 = document['schedule7'] ?? 'Jadwal Tidak Diketahui'; // Pastikan ini field yang benar

                        return Column(
                          children: [
                            _cardJadwalKapal(
                              screenWidth,
                              screenHeight,
                              date5,
                              schedule5,
                              image5,
                              () {
                                // Aksi ketika card 1 diklik
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Tiket(
                                      date: date5,       // Kirimkan date dari Firestore
                                      schedule: schedule5, // Kirimkan schedule di sini
                                    ),
                                  ),
                                );
                              },
                            ),
                            
                            _cardJadwalKapal(
                              screenWidth,
                              screenHeight,
                              date6,
                              schedule6,
                              image6,
                              () {
                                // Aksi ketika card 2 diklik
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Tiket(
                                      date: date6,       // Kirimkan date dari Firestore
                                      schedule: schedule6, // Kirimkan schedule di sini
                                    ),
                                  ),
                                );
                              },
                            ),

                            _cardJadwalKapal(
                              screenWidth,
                              screenHeight,
                              date7,
                              schedule7,
                              image7,
                              () {
                                // Aksi ketika card 2 diklik
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Tiket(
                                      date: date7,       // Kirimkan date dari Firestore
                                      schedule: schedule7, // Kirimkan schedule di sini
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  },
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 5.0, top: 0.0, right: 21.0, bottom: 23.0),
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('ship_schedule').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // Memetakan data dokumen menjadi list widget
                    return Column(
                      children: snapshot.data!.docs.map((document) {
                        // Mendapatkan data untuk card 1
                        String date8 = document['date8'] ?? 'Tanggal Tidak Diketahui';
                        String image8 = document['image1'] ?? 'assets/kapal 1.png'; // Gambar default
                        String schedule8 = document['schedule8'] ?? 'Jadwal Tidak Diketahui';

                        // Mendapatkan data untuk card 2
                        String date9 = document['date9'] ?? 'Tanggal Tidak Diketahui'; // Pastikan ini field yang benar
                        String image9 = document['image2'] ?? 'assets/kapal 1.png'; // Gambar default
                        String schedule9 = document['schedule9'] ?? 'Jadwal Tidak Diketahui'; // Pastikan ini field yang benar

                        String date10 = document['date10'] ?? 'Tanggal Tidak Diketahui'; // Pastikan ini field yang benar
                        String image10 = document['image1'] ?? 'assets/kapal 1.png'; // Gambar default
                        String schedule10 = document['schedule10'] ?? 'Jadwal Tidak Diketahui'; // Pastikan ini field yang benar

                        String date11 = document['date11'] ?? 'Tanggal Tidak Diketahui'; // Pastikan ini field yang benar
                        String image11 = document['image2'] ?? 'assets/kapal 1.png'; // Gambar default
                        String schedule11 = document['schedule11'] ?? 'Jadwal Tidak Diketahui'; // Pastikan ini field yang benar

                        return Column(
                          children: [
                            _cardJadwalKapal(
                              screenWidth,
                              screenHeight,
                              date8,
                              schedule8,
                              image8,
                              () {
                                // Aksi ketika card 1 diklik
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Tiket(
                                      date: date8,       // Kirimkan date dari Firestore
                                      schedule: schedule8, // Kirimkan schedule di sini
                                    ),
                                  ),
                                );
                              },
                            ),
                            
                            _cardJadwalKapal(
                              screenWidth,
                              screenHeight,
                              date9,
                              schedule9,
                              image9,
                              () {
                                // Aksi ketika card 2 diklik
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Tiket(
                                      date: date9,       // Kirimkan date dari Firestore
                                      schedule: schedule9, // Kirimkan schedule di sini
                                    ),
                                  ),
                                );
                              },
                            ),

                            _cardJadwalKapal(
                              screenWidth,
                              screenHeight,
                              date10,
                              schedule10,
                              image10,
                              () {
                                // Aksi ketika card 2 diklik
                               Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Tiket(
                                      date: date10,       // Kirimkan date dari Firestore
                                      schedule: schedule10, // Kirimkan schedule di sini
                                    ),
                                  ),
                                );
                              },
                            ),

                            _cardJadwalKapal(
                              screenWidth,
                              screenHeight,
                              date11,
                              schedule11,
                              image11,
                              () {
                                // Aksi ketika card 2 diklik
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Tiket(
                                      date: date11,       // Kirimkan date dari Firestore
                                      schedule: schedule11, // Kirimkan schedule di sini
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            Container(
              width: screenWidth * 0.9,
              height: screenHeight * 0.330,
              decoration: BoxDecoration(
                color: Color(0xff4BBAE9),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4.0,
                    offset: Offset(0, 2),
                  ),
                ]
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 5.0, top: 0.0, right: 21.0, bottom: 23.0),
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('ship_schedule').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // Memetakan data dokumen menjadi list widget
                    return Column(
                      children: snapshot.data!.docs.map((document) {
                        // Mendapatkan data untuk card 1
                        String date12 = document['date12'] ?? 'Tanggal Tidak Diketahui';
                        String image12 = document['image3'] ?? 'assets/kapal 1.png'; // Gambar default
                        String schedule12 = document['schedule12'] ?? 'Jadwal Tidak Diketahui';

                        // Mendapatkan data untuk card 2
                        String date13 = document['date13'] ?? 'Tanggal Tidak Diketahui'; // Pastikan ini field yang benar
                        String image13 = document['image4'] ?? 'assets/kapal 1.png'; // Gambar default
                        String schedule13 = document['schedule13'] ?? 'Jadwal Tidak Diketahui'; // Pastikan ini field yang benar

                        // Mendapatkan data untuk card 2
                        String date14 = document['date14'] ?? 'Tanggal Tidak Diketahui'; // Pastikan ini field yang benar
                        String image14 = document['image5'] ?? 'assets/kapal 1.png'; // Gambar default
                        String schedule14 = document['schedule14'] ?? 'Jadwal Tidak Diketahui'; // Pastikan ini field yang benar

                        return Column(
                          children: [
                            _cardJadwalKapal(
                              screenWidth,
                              screenHeight,
                              date12,
                              schedule12,
                              image12,
                              () {
                                // Aksi ketika card 1 diklik
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Tiket(
                                      date: date12,       // Kirimkan date dari Firestore
                                      schedule: schedule12, // Kirimkan schedule di sini
                                    ),
                                  ),
                                );
                              },
                            ),
                            
                            _cardJadwalKapal(
                              screenWidth,
                              screenHeight,
                              date13,
                              schedule13,
                              image13,
                              () {
                                // Aksi ketika card 2 diklik
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Tiket(
                                      date: date13,       // Kirimkan date dari Firestore
                                      schedule: schedule13, // Kirimkan schedule di sini
                                    ),
                                  ),
                                );
                              },
                            ),

                            _cardJadwalKapal(
                              screenWidth,
                              screenHeight,
                              date14,
                              schedule14,
                              image14,
                              () {
                                // Aksi ketika card 2 diklik
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Tiket(
                                      date: date14,       // Kirimkan date dari Firestore
                                      schedule: schedule14, // Kirimkan schedule di sini
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }

  Widget _cardJadwalKapal(
      double screenWidth, double screenHeight, String date, String schedule, String image, VoidCallback onClick) {
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
              left: -10.0,
              top: 10.0,
              child: Image.network(
                image, // URL gambar yang diambil dari Firestore
                width: screenWidth * 0.41,
                height: screenWidth * 0.26,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 30.0,
              right: 6.0,
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
                    schedule,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: screenWidth * 0.027,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
