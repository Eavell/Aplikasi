import 'package:flutter/material.dart';

class PenginapanPage extends StatefulWidget {
  @override
  _PenginapanPageState createState() => _PenginapanPageState();
}

class _PenginapanPageState extends State<PenginapanPage> {
  final PageController _pageController = PageController();
  final List<String> images = [
    'assets/images/thehwaksnestresort.png',
    'assets/images/thehwaksnestresort2.png',
    'assets/images/thehwaksnestresort3.png',
  ];

  int currentPage = 0;
  bool isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 300.0,
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (int page) {
                          setState(() {
                            currentPage = page;
                          });
                        },
                        children: images.map((image) {
                          return Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    IgnorePointer(
                      child: Container(
                        height: 310.0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.white,
                            ],
                            stops: [0.6, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 80.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start, // Atur sesuai kebutuhan Anda (dalam hal ini, MainAxisAlignment.start untuk rata kiri)
                        crossAxisAlignment: CrossAxisAlignment.start, // Ini yang akan membuat konten menjadi rata atas
                        children: [
                          Icon(Icons.location_on, color: Colors.black54),
                          SizedBox(width: 4.0),
                          Expanded(
                            child: Text(
                              'Ujong, Sikundo, Sukakarya, Kota Sabang, Aceh 24410',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        'Deskripsi',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        "Saat Anda menginap di The Hawk's Nest Resort di kota Sabang, Anda akan berada hanya 10 menit dengan berkendara dari Danau Anak Laut dan Gunung Merapi. Bed & breakfast ini berada 3,6 mi (5,8 km) dari Masjid Agung Babussalam dan 5 mi (8 km) dari Pantai Samur Tiga.",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        'Fasilitas',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          menuItem("Kamar di The Hawk's Nest Resort", ''),
                          menuItem('Akses internet', ' '),
                          menuItem('Ayam Penyet Nasi', ' '),
                          menuItem('Ruang serbaguna', ' '),
                          menuItem('Restoran dan Cafe', ' '),
                          menuItem('Sarapan', ' '),
                          menuItem('Area piknik', ' '),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        'Waktu Check in/Check out',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          menuItem('Check-in', '2:00 PM-10:00 PM'),
                          menuItem('Check-out', '11:30 AM'),
                        ],
                      ),
                      SizedBox(height: 30.0),  // Add space at the bottom
                    ],
                  ),
                ),
              ],
            ),

            //KOTAK PUTIH
            Positioned(
              top: 260.0,
              left: 40.0,
              right: 40.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "The Hawk's Nest Resort",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        //TOMBOL SIMPAN
                        IconButton(
                          icon: Icon(
                            Icons.bookmark,
                            size: 32,
                            color: isBookmarked ? Colors.pink : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              isBookmarked = !isBookmarked;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber),
                        SizedBox(width: 4.0),
                        Text(
                          '4.6',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        Spacer(), // Ini adalah bagian yang ditambahkan untuk membuat rata kanan
                        Text(
                          'Rp 700.000',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                          
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            //TOMBOL KEMBALI
            Positioned(
              top: 40.0,
              left: 16.0,
              child: IconButton(
                icon: Image.asset('assets/images/back_arrow.png'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  //ATUR BAGIAN DESKRIPSI
  Widget menuItem(String name, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '\u2022', // Unicode for bullet
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black87,
            ),
          ),
          SizedBox(width: 8.0), // Add some spacing between bullet and text
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
