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

  @override
  void initState() {
    super.initState();
    loadDataWisata();
    loadImagesFromFirebase();
    checkBookmarkStatus();
    loadLinkLokasi();
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
                            child: InkWell( // Gunakan InkWell agar teks bisa ditekan
                              onTap: () async {
                                // Cek apakah alamat valid dan buat Uri
                                if (linklokasi.isNotEmpty) {
                                  final Uri url = Uri.parse(linklokasi); // Gunakan Uri untuk URL
                                  // Cek apakah bisa meluncurkan URL dengan launchUrl
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(url); // Luncurkan Google Maps dengan alamat
                                  } else {
                                    print('Tidak dapat membuka alamat ini');
                                  }
                                }
                              },
                              child: Text(
                                lokasi.isNotEmpty ? lokasi: 'Alamat tidak tersedia',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black54, // Ubah warna teks menjadi biru seperti link
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

                        //TOMBOL SIMPAN
                        IconButton(
                          icon: Icon(
                            Icons.bookmark,
                            size: 32,
                            color: isBookmarked
                                ? Colors.pink
                                : Colors
                                    .grey, // Bookmark color based on the state
                          ),
                          onPressed: () async {
                            // Get the current logged-in user
                            User? user = FirebaseAuth.instance.currentUser;

                            if (user != null) {
                              String uid =
                                  user.uid; // Get the UID of the logged-in user

                              // Firestore reference to the user's bookmarks collection
                              final bookmarkRef = FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(uid)
                                  .collection('bookmarksWisata')
                                  .doc(widget.namaWisata);

                              try {
                                if (isBookmarked) {
                                  // If the item is already bookmarked, remove it from Firestore
                                  await bookmarkRef.delete();

                                  // If the delete operation is successful, update the state
                                  setState(() {
                                    isBookmarked = false;
                                  });
                                } else {
                                  // If the item is not bookmarked, add it to Firestore
                                  await bookmarkRef.set({
                                    'namaKuliner': widget.namaWisata,
                                    'lokasi': lokasi,
                                    'imageUrl': images.isNotEmpty
                                        ? images[0]
                                        : '',
                                  });

                                  // If the set operation is successful, update the state
                                  setState(() {
                                    isBookmarked = true;
                                  });
                                }
                              } catch (e) {
                                // Handle error (e.g., show a Snackbar or print an error message)
                                print("Error updating bookmark: $e");
                              }
                            } else {
                              // Handle the case when the user is not logged in
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
