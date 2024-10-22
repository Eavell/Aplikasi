import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class KulinerPage extends StatefulWidget {
  final String namaKuliner; // Tambahkan parameter untuk nama kuliner

  KulinerPage({required this.namaKuliner}); // Constructor menerima namaKuliner

  @override
  _KulinerPageState createState() => _KulinerPageState();
}

class _KulinerPageState extends State<KulinerPage> {
  final PageController _pageController = PageController();
  List<String> images = [];
  String alamat = '';
  String rating = '';
  String harga = '';
  List<String> jamBukaItems = [];
  List<String> menumakan = [];

  int currentPage = 0;
  bool isBookmarked = false;
  
  Future<void> loadImagesFromFirebase() async {
    // Nama folder sesuai dengan nama paket yang dipilih oleh user
    String selectedPaket = widget.namaKuliner; // Misal widget.paketName adalah 'Diamond', 'Gold', atau 'Silver'
    String folderPath = 'culinary/$selectedPaket/';

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
        images = imageUrls; // Mengisi imagesGallery dengan URL gambar dari Firebase
      });
    } catch (e) {
      print("Failed to load images: $e");
    }
  }
  Future<void> loadDataKuliner() async {
    try {
      // Mengambil data dari Firestore berdasarkan 'deskripsi_kuliner' dan namaKuliner
      DocumentSnapshot kulinerSnapshot = await FirebaseFirestore.instance
          .collection('deskripsi_kuliner')
          .doc(widget.namaKuliner)
          .get();

      // Mengecek apakah data ada
      if (kulinerSnapshot.exists) {
        setState(() {
          // Ambil data field 'alamat', 'rating', dan 'harga'
          alamat = kulinerSnapshot.get('alamat') ?? 'Alamat tidak tersedia';
          rating = kulinerSnapshot.get('rating') ?? 'Rating tidak tersedia';
          harga = kulinerSnapshot.get('harga') ?? 'Harga tidak tersedia';
        });
      } else {
        print('Dokumen tidak ditemukan');
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }


  // Fungsi untuk mengambil data dari Firestore
  Future<void> getJamBukaFromFirestore() async {
    try {
      DocumentSnapshot kulinerData = await FirebaseFirestore.instance
          .collection('deskripsi_kuliner')
          .doc(widget.namaKuliner)
          .get();

      if (kulinerData.exists) {
        setState(() {
          jamBukaItems = [];
          for (int i = 1; i <= 7; i++) {
            String fieldName = 'jam_buka_$i';
            String? jamBuka = kulinerData.get(fieldName);
            if (jamBuka != null) {
              jamBukaItems.add(jamBuka); // Simpan jam buka dalam format String
            }
          }
        });
      }
    } catch (e) {
      print('Error mengambil jam buka: $e');
    }
  }

  Future<void> getMenuFromFirestore() async {
    try {
      DocumentSnapshot kulinerData = await FirebaseFirestore.instance
          .collection('deskripsi_kuliner')
          .doc(widget.namaKuliner)
          .get();

      if (kulinerData.exists) {
        setState(() {
          menumakan = [];
          for (int i = 1; i <= 10; i++) {
            String fieldName = 'menu_$i';
            String? menu = kulinerData.get(fieldName);
            if (menu != null) {
              menumakan.add(menu); // Simpan menu dalam format String
            }
          }
        });
      }
    } catch (e) {
      print('Error mengambil menu: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getJamBukaFromFirestore();
    getMenuFromFirestore();
    loadDataKuliner();
    loadImagesFromFirebase();
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
                                image: NetworkImage(image),
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.location_on, color: Colors.black54),
                          SizedBox(width: 4.0),
                          Expanded(
                            child: Text(
                              alamat.isNotEmpty
                                  ? alamat
                                  : 'Alamat tidak tersedia',
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
                        'Jam Buka',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      // Menampilkan jam buka dari Firestore
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: jamBukaItems.map((menu) {
                          // Split the menu string into name and price
                          var parts = menu.split(', ');
                          var menuName = parts[0];
                          var price = parts.length > 1 ? parts[1] : '...'; // Default price if not available
                          return menuItem(menuName, price);
                        }).toList(),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        'Menu',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      // Menampilkan menu dari Firestore
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: menumakan.map((menu) {
                          // Split the menu string into name and price
                          var parts = menu.split(', ');
                          var menuName = parts[0];
                          var price = parts.length > 1 ? parts[1] : 'Rp ...'; // Default price if not available
                          return menuItem(menuName, price);
                        }).toList(),
                      ),
                      SizedBox(height: 30.0),
                    ],
                  ),
                ),
              ],
            ),

            // KOTAK PUTIH
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
                            widget.namaKuliner, // Menampilkan nama kuliner yang dikirim
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        // TOMBOL SIMPAN
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
                          rating.isNotEmpty
                                  ? rating
                                  : '0.0',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        Spacer(),
                        Text(
                          harga.isNotEmpty
                                  ? harga
                                  : 'Rp0',
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

            // TOMBOL KEMBALI
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

  // ATUR BAGIAN DESKRIPSI
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
          SizedBox(width: 8.0),
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
