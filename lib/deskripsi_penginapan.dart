import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';

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
  String linklokasi = '';
  String rating = '';
  String harga = '';
  String deskripsi = '';
  List<String> fasilitasItems = [];
  List<String> waktuCICO = [];
  String cp = '';
  String linkcp = '';

  int currentPage = 0;
  bool isBookmarked = false;

  Future<void> loadImagesFromFirebase() async {
    // Nama folder sesuai dengan nama paket yang dipilih oleh user
    String selectedPaket = widget
        .namaPenginapan; // Misal widget.paketName adalah 'Diamond', 'Gold', atau 'Silver'
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
        images =
            imageUrls; // Mengisi imagesGallery dengan URL gambar dari Firebase
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
          deskripsi =
              penginapanSnapshot.get('deskripsi') ?? 'Tidak ada deskripsi';
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
      DocumentSnapshot penginapanSnapshot = await FirebaseFirestore.instance
          .collection('deskripsi_penginapan')
          .doc(widget.namaPenginapan)
          .get();

      // Mengecek apakah data ada
      if (penginapanSnapshot.exists) {
        setState(() {
          // Ambil field 'linkalamat' dari dokumen
          linklokasi = penginapanSnapshot.get('link_lokasi') ?? 'Link tidak tersedia';
        });
      } else {
        print('Dokumen tidak ditemukan');
      }
    } catch (e) {
      print("Error fetching linkalamat: $e");
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
          // Konversi `penginapanData.data()` ke `Map<String, dynamic>`
          Map<String, dynamic>? data = penginapanData.data() as Map<String, dynamic>?;

          // Pastikan data tidak null sebelum memanggil `forEach`
          if (data != null) {
            data.forEach((key, value) {
              if (key.startsWith('fasilitas_') && value != null) {
                fasilitasItems.add(value as String); // Simpan nilai fasilitas
              }
            });
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

  Future<void> checkBookmarkStatus() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uid = user.uid;

      final bookmarkRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('bookmarksPenginapan')
          .doc(widget.namaPenginapan);

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
            .doc(widget.namaPenginapan)
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
          .collection('deskripsi_penginapan')
          .doc(widget.namaPenginapan)
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
    loadDataPenginapan();
    getFasilitasFromFirestore();
    getWaktuCICOFromFirestore();
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
              padding: EdgeInsets.only(top: 320.0),
              child: 
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 80.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .start, // Atur sesuai kebutuhan Anda (dalam hal ini, MainAxisAlignment.start untuk rata kiri)
                        crossAxisAlignment: CrossAxisAlignment
                            .start, // Ini yang akan membuat konten menjadi rata atas
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
                          var price = parts.length > 1
                              ? parts[1]
                              : '...'; // Default price if not available
                          return menuItem(waktuName, price);
                        }).toList(),
                      ),
                      SizedBox(height: 20.0),
                      // Bagian 3 Hari / 2 Malam
                      Text(
                        'Narahubung',  // Pastikan judul_cp memiliki nilai default
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
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30.0), // Add space at the bottom
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
                                      borderRadius: BorderRadius.circular(10.0), // Radius diterapkan ke PageView
                                      child: Container(
                                        height: 400.0,
                                        child: PageView(
                                          controller: _dialogPageController,
                                          children: images.map((image) {
                                            return Container(
                                              margin: EdgeInsets.all(2.0), // Margin kecil agar radius lebih terlihat
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
                    // Indikator gambar
                    Positioned(
                      bottom: 65.0,
                      right: 20.0,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0), // Padding untuk memberi ruang di sekitar konten
                        decoration: BoxDecoration(
                          color: Colors.grey[700], // Warna latar belakang abu-abu
                          borderRadius: BorderRadius.circular(10.0), // Sudut melingkar
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.image, // Ikon kamera
                              color: Colors.white, // Warna ikon putih
                            ),
                            SizedBox(width: 8.0), // Jarak antara ikon dan teks
                            Text(
                              '${currentPage + 1} / ${images.length}', // Tampilkan currentPage dan total images
                              style: TextStyle(
                                color: Colors.white, // Warna teks putih
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
                                  .collection('bookmarksPenginapan')
                                  .doc(widget.namaPenginapan);

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
                                    'namaPenginapan': widget.namaPenginapan,
                                    'lokasi': lokasi,
                                    'rating': rating,
                                    'harga': harga,
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
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber),
                        SizedBox(width: 4.0),
                        Text(
                          rating.isNotEmpty ? rating : '0.0',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        Spacer(), // Ini adalah bagian yang ditambahkan untuk membuat rata kanan
                        Text(
                          harga.isNotEmpty ? harga : 'Rp0',
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
