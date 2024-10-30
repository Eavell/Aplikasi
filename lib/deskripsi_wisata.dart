import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class WisataPage extends StatefulWidget {
  final String namaWisata;

  WisataPage({required this.namaWisata});

  @override
  _WisataPageState createState() => _WisataPageState();
}

class _WisataPageState extends State<WisataPage> {
  final PageController _pageController = PageController();
  List<String> images = [];
  String lokasi= '';
  String linklokasi = '';
  String rating = '';
  String deskripsi = '';
  String cp = '';
  String linkcp = '';

  int currentPage = 0;
  bool isBookmarked = false;

  Future<void> loadImagesFromFirebase() async {
    // Nama folder sesuai dengan nama paket yang dipilih oleh user
    String selectedPaket = widget.namaWisata; // Misal widget.paketName adalah 'Diamond', 'Gold', atau 'Silver'
    String folderPath = 'destination/$selectedPaket/';

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

  Future<void> loadDataWisata() async {
    try {
      // Mengambil data dari Firestore berdasarkan 'deskripsi_kuliner' dan namaKuliner
      DocumentSnapshot wisataSnapshot = await FirebaseFirestore.instance
          .collection('deskripsi_wisata')
          .doc(widget.namaWisata)
          .get();

      // Mengecek apakah data ada
      if (wisataSnapshot.exists) {
        setState(() {
          // Ambil data field 'alamat', 'rating', dan 'harga'
          lokasi = wisataSnapshot.get('lokasi') ?? 'Alamat tidak tersedia';
          rating = wisataSnapshot.get('rating') ?? 'Rating tidak tersedia';
          deskripsi = wisataSnapshot.get('deskripsi') ?? 'Harga tidak tersedia';
        });
      } else {
        print('Dokumen tidak ditemukan');
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> loadLinkLokasi() async {
    try {
      // Mengambil data dari Firestore berdasarkan 'deskripsi_kuliner' dan namaKuliner
      DocumentSnapshot wisataSnapshot = await FirebaseFirestore.instance
          .collection('deskripsi_wisata')
          .doc(widget.namaWisata)
          .get();

      // Mengecek apakah data ada
      if (wisataSnapshot.exists) {
        setState(() {
          // Ambil field 'linkalamat' dari dokumen
          linklokasi = wisataSnapshot.get('link_lokasi') ?? 'Link tidak tersedia';
        });
      } else {
        print('Dokumen tidak ditemukan');
      }
    } catch (e) {
      print("Error fetching linkalamat: $e");
    }
  }

  Future<void> checkBookmarkStatus() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uid = user.uid;

      final bookmarkRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('bookmarksWisata')
          .doc(widget.namaWisata);

      try {
        // Periksa apakah bookmark ada di Firestore
        DocumentSnapshot bookmarkSnapshot = await bookmarkRef.get();
        if (bookmarkSnapshot.exists) {
          setState(() {
            isBookmarked = true;
          });
        } else {
          setState(() {
            isBookmarked = false;
          });
        }
      } catch (e) {
        print("Error checking bookmark status: $e");
      }
    }
  }

  Future<void> loadDataCP() async {
    try {
      DocumentSnapshot cPSnapshot = await FirebaseFirestore.instance
            .collection('deskripsi_penginapan')
            .doc(widget.namaWisata)
            .get();

      // Mengecek apakah data ada
      if (cPSnapshot.exists) {
        setState(() {
          // Ambil data field 'alamat', 'rating', dan 'harga'
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
      DocumentSnapshot linkcPSnapshot = await FirebaseFirestore.instance
          .collection('deskripsi_kuliner')
          .doc(widget.namaWisata)
          .get();

      if (linkcPSnapshot.exists) {
        setState(() {
          linkcp = linkcPSnapshot.get('link_wa') ?? 'Link tidak tersedia';
        });
        print("Link WA: $linkcp"); // Menampilkan hasil di konsol
      } else {
        print('Dokumen tidak ditemukan');
      }
    } catch (e) {
      print("Error fetching linkalamat: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    loadDataWisata();
    loadImagesFromFirebase();
    checkBookmarkStatus();
    loadLinkLokasi();
    loadDataCP();
    loadLinkCP();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Bagian yang bisa di-scroll
          SingleChildScrollView(
            padding: EdgeInsets.only(top: 320.0), // Ruang untuk gambar dan kotak putih di bagian atas
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 80.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on, color: Colors.black54),
                      SizedBox(width: 4.0),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            if (linklokasi.isNotEmpty) {
                              final Uri url = Uri.parse(linklokasi);
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              } else {
                                print('Tidak dapat membuka alamat ini');
                              }
                            }
                          },
                          child: Text(
                            lokasi.isNotEmpty ? lokasi : 'Alamat tidak tersedia',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black54,
                            ),
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
                    'Narahubung',
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
                          await launchUrl(url);
                        } else {
                          print('Tidak dapat membuka alamat ini');
                        }
                      }
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/icon_wa.png',
                          width: 26.0,
                          height: 26.0,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          cp.isNotEmpty ? cp : '-',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.0),
                ],
              ),
            ),
          ),
          // Bagian gambar (tidak di-scroll)
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
                      children: images.asMap().entries.map((entry) {
                        int index = entry.key;
                        String image = entry.value;
                        return GestureDetector(
                          onTap: () {
                            PageController _dialogPageController = PageController(initialPage: index);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Container(
                                      height: 400.0,
                                      child: PageView(
                                        controller: _dialogPageController,
                                        children: images.map((image) {
                                          return Container(
                                            margin: EdgeInsets.all(2.0),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10.0),
                                              image: DecorationImage(
                                                image: NetworkImage(image),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(image),
                                fit: BoxFit.cover,
                              ),
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
                  Positioned(
                    bottom: 65.0,
                    right: 20.0,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.image,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            '${currentPage + 1} / ${images.length}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Kotak putih tetap pada posisi teratas
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
                          widget.namaWisata,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.bookmark,
                          size: 32,
                          color: isBookmarked ? Colors.pink : Colors.grey,
                        ),
                        onPressed: () async {
                          User? user = FirebaseAuth.instance.currentUser;
                          if (user != null) {
                            String uid = user.uid;
                            final bookmarkRef = FirebaseFirestore.instance
                                .collection('users')
                                .doc(uid)
                                .collection('bookmarksWisata')
                                .doc(widget.namaWisata);
                            try {
                              if (isBookmarked) {
                                await bookmarkRef.delete();
                                setState(() {
                                  isBookmarked = false;
                                });
                              } else {
                                await bookmarkRef.set({
                                  'namaKuliner': widget.namaWisata,
                                  'lokasi': lokasi,
                                  'imageUrl': images.isNotEmpty ? images[0] : '',
                                });
                                setState(() {
                                  isBookmarked = true;
                                });
                              }
                            } catch (e) {
                              print("Error updating bookmark: $e");
                            }
                          } else {
                            print("User not logged in");
                          }
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber),
                      SizedBox(width: 4.0),
                      Text(
                        rating,
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
              icon: Image.asset('assets/tombolKembali.png'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
