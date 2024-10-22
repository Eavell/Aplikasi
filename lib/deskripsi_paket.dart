import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeskripsiPaketPage extends StatefulWidget {
  final String packageName;
  final String packagePrice;
  final String imagePath;
  final String description;
  // final String screenWidth;

  const DeskripsiPaketPage({
    required this.packageName,
    required this.packagePrice,
    required this.imagePath,
    required this.description,
    // required this.screenWidth,
    Key? key,
  }) : super(key: key);

  @override
  _DeskripsiPaketPageState createState() => _DeskripsiPaketPageState();
}

class _DeskripsiPaketPageState extends State<DeskripsiPaketPage> {
  List<String> imagesGallery = [];
  bool isBookmarked = false;
  Map<String, dynamic> menu1Data = {};
  Map<String, dynamic> menu2Data = {};

  @override
  void initState() {
    super.initState();
    loadImagesFromFirebase(); // Memanggil method untuk load gambar
    loadData();
  }

  Future<void> loadImagesFromFirebase() async {
    // Nama folder sesuai dengan nama paket yang dipilih oleh user
    String selectedPaket = widget.packageName; // Misal widget.paketName adalah 'Diamond', 'Gold', atau 'Silver'
    String folderPath = 'Galeri Paket Travel/$selectedPaket/';

    try {
      final storageRef = FirebaseStorage.instance.ref().child(folderPath);
      final listResult = await storageRef.listAll();

      List<String> imageUrls = [];
      for (var item in listResult.items) {
        // Mendapatkan URL download dari setiap file di folder
        String downloadUrl = await item.getDownloadURL();
        // print("Download URL: $downloadUrl"); // Tambahkan ini untuk debug
        imageUrls.add(downloadUrl);
      }

      setState(() {
        imagesGallery = imageUrls; // Mengisi imagesGallery dengan URL gambar dari Firebase
      });
    } catch (e) {
      print("Failed to load images: $e");
    }
  }

  Future<void> loadData() async {
      try {
        // Mengambil data dari Firestore
        DocumentSnapshot menu1Snapshot = await FirebaseFirestore.instance
            .collection(widget.packageName)
            .doc('menu1')
            .get();
        DocumentSnapshot menu2Snapshot = await FirebaseFirestore.instance
            .collection(widget.packageName)
            .doc('menu2')
            .get();

        setState(() {
          menu1Data = menu1Snapshot.data() as Map<String, dynamic>;
          menu2Data = menu2Snapshot.data() as Map<String, dynamic>;
        });
      } catch (e) {
        print("Error fetching data: $e");
      }
    }

  Widget menuItem(String title, String subtitle) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

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
                          image: AssetImage(widget.imagePath),
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
                                                image: NetworkImage(image),
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
                                  image: NetworkImage(image),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 20.0),
                      // Bagian 3 Hari / 2 Malam
                      Text(
                        menu1Data['judul'] ?? 'Menu 1',  // Mengambil data dari menu1
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: menu1Data.entries.map((entry) {
                          if (entry.key != 'judul') {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  Text(
                                    '\u2022', // Bullet point
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(width: 8.0),
                                  Text(
                                    entry.value, // Menampilkan item dari menu1
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return SizedBox.shrink(); // Tidak menampilkan 'title'
                          }
                        }).toList(),
                      ),
                      SizedBox(height: 20.0),
                      // Bagian Mencakup
                      Text(
                        menu2Data['judul'] ?? 'Menu 2',  // Mengambil data dari menu1
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: menu2Data.entries.map((entry) {
                          if (entry.key != 'judul') {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  Text(
                                    '\u2022', // Bullet point
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(width: 8.0),
                                  Text(
                                    entry.value, // Menampilkan item dari menu1
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return SizedBox.shrink(); // Tidak menampilkan 'title'
                          }
                        }).toList(),
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
                            widget.packageName,
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
                    Text(widget.packagePrice,
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
                icon: Image.asset('assets/tombol_kembali.png'),
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

  // //ATUR BAGIAN DESKRIPSI
  // Widget menuItem(String name, String price) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 4.0),
  //     child: Row(
  //       children: [
  //         Text(
  //           '\u2022', // Unicode for bullet
  //           style: TextStyle(
  //             fontSize: 16.0,
  //             color: Colors.black87,
  //           ),
  //         ),
  //         SizedBox(width: 8.0), // Add some spacing between bullet and text
  //         Expanded(
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 name,
  //                 style: TextStyle(
  //                   fontSize: 16.0,
  //                   color: Colors.black87,
  //                 ),
  //               ),
  //               Text(
  //                 price,
  //                 style: TextStyle(
  //                   fontSize: 16.0,
  //                   color: Colors.black87,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
