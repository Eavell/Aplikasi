import 'package:flutter/material.dart';

class DeskripsiPaketPage extends StatefulWidget {
  @override
  _DeskripsiPaketPageState createState() => _DeskripsiPaketPageState();
}

class _DeskripsiPaketPageState extends State<DeskripsiPaketPage> {
  final List<String> images = [
    'assets/images/Diamond.png',
  ];

  final List<String> imagesGallery = [
    'assets/images/Diamond1.png',
    'assets/images/Diamond2.png',
    'assets/images/Diamond3.png',
    'assets/images/Diamond4.png',
  ];

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
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(images[0]),
                          fit: BoxFit.cover,
                        ),
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
                SizedBox(height: 60.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.0),
                      Text(
                        'Galeri',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: imagesGallery.asMap().entries.map((entry) {
                          int index = entry.key;
                          String image = entry.value;
                          return GestureDetector(
                            onTap: () {
                              PageController _pageController = PageController(initialPage: index);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    child: Container(
                                      height: 400.0,
                                      child: PageView(
                                        controller: _pageController,
                                        children: imagesGallery.map((image) {
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
                                  );
                                },
                              );
                            },
                            child: Container(
                              width: 70.0,
                              height: 70.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(image),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        '3 Hari / 2 Malam',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          menuItem("2 Pax - Rp 1.600.000 / Orang", ''),
                          menuItem('3 Pax - Rp 1.300.000 / Orang', ' '),
                          menuItem('4 Pax - Rp 1.200.000 / Orang', ' '),
                          menuItem('5 Pax - Rp 1.100.000 / Orang', ' '),
                          menuItem('6 Pax - Rp 1.000.000 / Orang', ' '),
                          menuItem('7 Pax - Rp 950.000 / Orang', ' '),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        'Mencakup',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          menuItem('Tiket kapal express pp', ' '),
                          menuItem('Transportasi + Supir + BBM', ' '),
                          menuItem('Penginapan', ' '),
                          menuItem('Guide Snorkling', ' '),
                          menuItem('Dokumetasi foto + vidio + editing', ' '),
                          menuItem('Tiket masuk setiap objek wisata', ' '),
                          menuItem('Parkir', ' '),
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
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Paket Diamond",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Text('Rp 950.000 - Rp 1.600.000',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Color(0xFF7F7F7F),
                      ),
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
