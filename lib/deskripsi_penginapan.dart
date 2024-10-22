import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PenginapanPage extends StatefulWidget {
  final String namaPenginapan;

  PenginapanPage({required this.namaPenginapan});

  @override
  _PenginapanPageState createState() => _PenginapanPageState();
}

class _PenginapanPageState extends State<PenginapanPage> {
  final PageController _pageController = PageController();
  List<String> images = [];
  String lokasi = '';
  String rating = '';
  String harga = '';
  String deskripsi = '';
  List<String> fasilitasItems = [];
  List<String> waktuCICO = [];

  int currentPage = 0;
  bool isBookmarked = false;

  Future<void> loadImagesFromFirebase() async {
    // Nama folder sesuai dengan nama paket yang dipilih oleh user
    String selectedPaket = widget.namaPenginapan; // Misal widget.paketName adalah 'Diamond', 'Gold', atau 'Silver'
    String folderPath = 'accommodation/$selectedPaket/';

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

  Future<void> loadDataPenginapan() async {
    try {
      // Mengambil data dari Firestore berdasarkan 'deskripsi_kuliner' dan namaKuliner
      DocumentSnapshot penginapanSnapshot = await FirebaseFirestore.instance
          .collection('deskripsi_penginapan')
          .doc(widget.namaPenginapan)
          .get();

      // Mengecek apakah data ada
      if (penginapanSnapshot.exists) {
        setState(() {
          // Ambil data field 'alamat', 'rating', dan 'harga'
          lokasi = penginapanSnapshot.get('lokasi') ?? 'Alamat tidak tersedia';
          rating = penginapanSnapshot.get('rating') ?? 'Rating tidak tersedia';
          harga = penginapanSnapshot.get('harga') ?? 'Harga tidak tersedia';
          deskripsi = penginapanSnapshot.get('deskripsi') ?? 'Tidak ada deskripsi';
        });
      } else {
        print('Dokumen tidak ditemukan');
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> getFasilitasFromFirestore() async {
    try {
      DocumentSnapshot penginapanData = await FirebaseFirestore.instance
          .collection('deskripsi_penginapan')
          .doc(widget.namaPenginapan)
          .get();

      if (penginapanData.exists) {
        setState(() {
          fasilitasItems = [];
          for (int i = 1; i <= 7; i++) {
            String fieldName = 'fasilitas_$i';
            String? fasilitas = penginapanData.get(fieldName);
            if (fasilitas != null) {
              fasilitasItems.add(fasilitas); // Simpan jam buka dalam format String
            }
          }
        });
      }
    } catch (e) {
      print('Error mengambil fasilitas: $e');
    }
  }

  Future<void> getWaktuCICOFromFirestore() async {
    try {
      DocumentSnapshot penginapanData = await FirebaseFirestore.instance
          .collection('deskripsi_penginapan')
          .doc(widget.namaPenginapan)
          .get();

      if (penginapanData.exists) {
        setState(() {
          waktuCICO = [];
          for (int i = 1; i <= 7; i++) {
            String fieldName = 'waktu_$i';
            String? waktu = penginapanData.get(fieldName);
            if (waktu != null) {
              waktuCICO.add(waktu); // Simpan jam buka dalam format String
            }
          }
        });
      }
    } catch (e) {
      print('Error mengambil fasilitas: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    loadDataPenginapan();
    getFasilitasFromFirestore();
    getWaktuCICOFromFirestore();
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
                        mainAxisAlignment: MainAxisAlignment.start, // Atur sesuai kebutuhan Anda (dalam hal ini, MainAxisAlignment.start untuk rata kiri)
                        crossAxisAlignment: CrossAxisAlignment.start, // Ini yang akan membuat konten menjadi rata atas
                        children: [
                          Icon(Icons.location_on, color: Colors.black54),
                          SizedBox(width: 4.0),
                          Expanded(
                            child: Text(
                              lokasi.isNotEmpty
                                  ? lokasi
                                  : 'Lokasi tidak tersedia',
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
                        deskripsi,
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
                        children: fasilitasItems.map((menu) {
                          return menuItem(menu, "");
                        }).toList(),
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
                        children: waktuCICO.map((waktu) {
                          // Split the menu string into name and price
                          var parts = waktu.split(', ');
                          var waktuName = parts[0];
                          var price = parts.length > 1 ? parts[1] : '...'; // Default price if not available
                          return menuItem(waktuName, price);
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
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.namaPenginapan,
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
                          rating.isNotEmpty
                                  ? rating
                                  : '0.0',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        Spacer(), // Ini adalah bagian yang ditambahkan untuk membuat rata kanan
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
