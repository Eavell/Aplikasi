import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

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
  String cp = '';
  String linkcp = '';
  String judul_cp = '';

  @override
  void initState() {
    super.initState();
    loadImagesFromFirebase(); // Memanggil method untuk load gambar
    loadData();
    loadDataCP();
    loadLinkCP();
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

  Future<void> loadDataCP() async {
    try {
      DocumentSnapshot cPSnapshot = await FirebaseFirestore.instance
            .collection(widget.packageName)
            .doc('contactPerson')
            .get();

      // Mengecek apakah data ada
      if (cPSnapshot.exists) {
        setState(() {
          // Ambil data field 'alamat', 'rating', dan 'harga'
          judul_cp = cPSnapshot.get('judul') ?? 'Judul tidak tersedia';
          cp = cPSnapshot.get('cp') ?? '-';
        });
      } else {
        print('Dokumen tidak ditemukan');
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> loadLinkCP() async {
    try {
      DocumentSnapshot kulinerSnapshot = await FirebaseFirestore.instance
          .collection(widget.packageName)
          .doc('contactPerson')
          .get();

      if (kulinerSnapshot.exists) {
        setState(() {
          linkcp = kulinerSnapshot.get('link_wa') ?? 'Link tidak tersedia';
        });
        print("Link WA: $linkcp"); // Menampilkan hasil di konsol
      } else {
        print('Dokumen tidak ditemukan');
      }
    } catch (e) {
      print("Error fetching linkalamat: $e");
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
                        judul_cp,  // Pastikan judul_cp memiliki nilai default
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      InkWell(
                        onTap: () async {
                        if (linkcp.isNotEmpty) {
                          final Uri url = Uri.parse(linkcp);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url, mode: LaunchMode.externalApplication);
                          } else {
                            print('Tidak dapat membuka alamat ini');
                          }
                        }
                      },
                        child: Row(
                          children: [
                            // Gambar di sebelah kiri teks
                            Image.asset(
                              'assets/icon_wa.png', // Ganti dengan path gambar Anda
                              width: 26.0,
                              height: 26.0,
                            ),
                            SizedBox(width: 8.0), // Spasi antara gambar dan teks
                            Text(
                              cp.isNotEmpty ? cp : '-',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0),
                      // Bagian 3 Hari / 2 Malam
                      Text(
                        menu1Data['judul'] ?? 'Menu 1',
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
                                    '\u2022',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(width: 8.0),
                                  Text(
                                    entry.value,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        }).toList(),
                      ),
                      SizedBox(height: 20.0),
                      // Bagian Mencakup
                      Text(
                        menu2Data['judul'] ?? 'Menu 2',
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
                                    '\u2022',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(width: 8.0),
                                  Text(
                                    entry.value,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        }).toList(),
                      ),
                      SizedBox(height: 30.0),
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
                icon: Image.asset('assets/tombolKembali.png'),
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
}