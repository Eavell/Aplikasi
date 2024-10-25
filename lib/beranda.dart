import 'package:eavell/PaketTravel.dart';
import 'package:eavell/jadwalKapal.dart';
import 'package:eavell/kuliner.dart';
import 'package:eavell/penginapan.dart';
import 'package:eavell/profil.dart';
import 'package:eavell/wisata.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'deskripsi_penginapan.dart';
import 'deskripsi_wisata.dart';
import 'deskripsi_kuliner.dart';

class Beranda extends StatefulWidget {
  const Beranda({Key? key}) : super(key: key);

  @override
  _BerandaState createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  String userName = ''; // Untuk menyimpan nama pengguna
  String profileImageUrl = ''; // Untuk menyimpan URL gambar profil
  bool isSearching = false; // State untuk mode pencarian
  List<DocumentSnapshot> searchResults = []; // Hasil pencarian
  TextEditingController searchController =
      TextEditingController(); // Kontroler untuk input pencarian
  String searchText = "";
  final FocusNode _focusNode = FocusNode(); // FocusNode untuk TextField

  final CollectionReference _culinaryCollection =
      FirebaseFirestore.instance.collection('deskripsi_kuliner');

  final CollectionReference _accommodationCollection =
      FirebaseFirestore.instance.collection('deskripsi_penginapan');

  final CollectionReference _destinationCollection =
      FirebaseFirestore.instance.collection('deskripsi_wisata');

  @override
  void dispose() {
    // Dispose controller yang benar
    _focusNode.dispose(); // Hapus FocusNode ketika widget dihancurkan
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getUserName();
    _getProfileData();
  }

  // Fungsi untuk mengambil nama pengguna dari Firestore
  Future<void> _getUserName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        setState(() {
          userName = userData['name'];
        });
      }
    } catch (e) {
      print('Error getting user name: $e');
    }
  }

  Future<void> _getProfileData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        setState(() {
          userName = userData['name'];
          profileImageUrl = userData['profileImageUrl'] ?? '';
        });
      }
    } catch (e) {
      print('Error getting profile data: $e');
    }
  }

  // Fungsi untuk melakukan pencarian di Firestore
  Future<void> _searchFirestore(String query) async {
    print("Querying for: $query");

    if (query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    // Mengubah query ke format yang cocok dengan case field di Firestore
    String searchQuery =
        query[0].toUpperCase() + query.substring(1).toLowerCase();

    try {
      QuerySnapshot destinationResults = await FirebaseFirestore.instance
          .collection('deskripsi_wisata')
          .where('nama', isGreaterThanOrEqualTo: searchQuery)
          .where('nama', isLessThanOrEqualTo: searchQuery + '\uf8ff')
          .get();

      QuerySnapshot accommodationResults = await FirebaseFirestore.instance
          .collection('deskripsi_penginapan')
          .where('nama', isGreaterThanOrEqualTo: searchQuery)
          .where('nama', isLessThanOrEqualTo: searchQuery + '\uf8ff')
          .get();

      QuerySnapshot culinaryResults = await FirebaseFirestore.instance
          .collection('deskripsi_kuliner')
          .where('nama', isGreaterThanOrEqualTo: searchQuery)
          .where('nama', isLessThanOrEqualTo: searchQuery + '\uf8ff')
          .get();

      print("Destination Results: ${destinationResults.docs.length} found");
      print("Accommodation Results: ${accommodationResults.docs.length} found");
      print("Culinary Results: ${culinaryResults.docs.length} found");

      List<DocumentSnapshot> allResults = []
        ..addAll(destinationResults.docs)
        ..addAll(accommodationResults.docs)
        ..addAll(culinaryResults.docs);

      print("Total Results: ${allResults.length} found");

      setState(() {
        searchResults = allResults;
      });
    } catch (e) {
      print("Error during search: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(160.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Color(0xFF4BBAE9),
            ),
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName.isNotEmpty ? userName : 'Memuat...',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Mau ke mana hari ini?',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilPage(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(30.0),
                      splashColor: Colors.blue.withAlpha(30),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: profileImageUrl.isNotEmpty
                            ? NetworkImage(profileImageUrl)
                            : AssetImage('assets/defaultProfile.png')
                                as ImageProvider,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 40.0,
                  child: GestureDetector(
                    // Agar keyboard tidak muncul otomatis
                    onTap: () {
                      _focusNode
                          .requestFocus(); // Memfokuskan TextField saat diklik
                    },
                    child: TextField(
                      focusNode: _focusNode, // Tetapkan FocusNode ke TextField
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {
                          searchText = value.toLowerCase();
                        });
                        if (searchText.length > 2) {
                          _searchFirestore(
                              value); // Hanya panggil pencarian jika input lebih dari 2 karakter
                        }
                      },
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color(0xFFFB6BBC4),
                        fontWeight: FontWeight.w300,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Mau ke mana hari ini?',
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 15.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: isSearching
          ? _buildSearchResults() // Jika pencarian aktif, tampilkan hasil
          : _buildBody(), // Jika tidak, tampilkan body utama
    );
  }

  Widget _buildSearchResults() {
    if (searchResults.isEmpty) {
      return Center(
        child: Text('Tidak ada hasil ditemukan.'),
      );
    }
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        var data = searchResults[index].data() as Map<String, dynamic>;
        return ListTile(
          title: Text(
              data['fieldName']), // Sesuaikan dengan field yang ditampilkan
          subtitle: Text(data['fieldDescription']),
        );
      },
    );
  }

  Widget _buildBody() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Stack(
            children: [
              Container(
                height: 160,
                color: Colors.white,
              ),
              Container(
                height: 90,
                decoration: BoxDecoration(
                  color: Color(0xFF4BBAE9),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(45.0),
                    bottomRight: Radius.circular(45.0),
                  ),
                ),
                padding: EdgeInsets.all(16.0),
              ),
              Positioned(
                top: 20,
                left: 25,
                right: 25,
                child: Container(
                  height: 132,
                  width: 306,
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CategoryItem(
                          imagePath: 'jadwal kapal.png',
                          label: 'Jadwal \nKapal',
                        ),
                        CategoryItem(
                          imagePath: 'penginapan.png',
                          label: 'Penginapan',
                        ),
                        CategoryItem(
                          imagePath: 'wisata.png',
                          label: 'Wisata',
                        ),
                        CategoryItem(
                          imagePath: 'paket perjalanan.png',
                          label: 'Paket \nPerjalanan',
                        ),
                        CategoryItem(
                          imagePath: 'kuliner.png',
                          label: 'Kuliner',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          sliver: SliverToBoxAdapter(
            child: SectionTitle(
              title: 'Wisata', // Ubah judul berdasarkan status pencarian
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('deskripsi_wisata')
                .snapshots(), // Ambil semua data
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              // Lakukan pencarian manual di sisi klien berdasarkan input user atau rating
              List<Widget> destinationItem = snapshot.data!.docs.where((doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

                // Jika searchText kosong, filter berdasarkan rating
                if (searchText.isEmpty) {
                  if (data['rating'] != null) {
                    double rating = double.tryParse(data['rating']) ??
                        0.0; // Pastikan rating di-convert ke double
                    return rating >= 4.5; // Filter rating >= 4.5
                  }
                  return false;
                }

                // Jika searchText ada, tampilkan semua data tanpa filter rating
                String name = data['nama'].toString().toLowerCase();
                String searchLowerCase = searchText.toLowerCase();
                return name.contains(searchLowerCase);
              }).map((doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

                return DestinationItem(
                  imageUrl: data['imageUrl'] ?? '',
                  name: data['nama'] ?? 'Unknown',
                  location: data['lokasi'] ?? 'Unknown',
                );
              }).toList();

              // Jika destinationItem kosong, tampilkan teks bahwa tidak ada data yang ditemukan
              if (destinationItem.isEmpty) {
                return Center(
                    child: Text("Tidak ada data Wisata yang tersedia."));
              }

              return HorizontalListView(items: destinationItem);
            },
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          sliver: SliverToBoxAdapter(
            child: SectionTitle(
              title: 'Kuliner', // Ubah judul berdasarkan status pencarian
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('deskripsi_kuliner')
                .snapshots(), // Ambil semua data
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              // Lakukan pencarian manual di sisi klien berdasarkan input user atau rating
              List<Widget> culinaryItems = snapshot.data!.docs.where((doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

                // Jika searchText kosong, filter berdasarkan rating
                if (searchText.isEmpty) {
                  if (data['rating'] != null) {
                    double rating = double.tryParse(data['rating']) ??
                        0.0; // Pastikan rating di-convert ke double
                    return rating >= 4.5; // Filter rating >= 4.5
                  }
                  return false;
                }

                // Jika searchText ada, tampilkan semua data tanpa filter rating
                String name = data['nama'].toString().toLowerCase();
                String searchLowerCase = searchText.toLowerCase();
                return name.contains(searchLowerCase);
              }).map((doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

                return CulinaryItem(
                  imageUrl: data['imageUrl'] ?? '',
                  name: data['nama'] ?? 'Unknown',
                  rating: data['rating'] ?? '0.0',
                );
              }).toList();

              // Jika culinaryItems kosong, tampilkan teks bahwa tidak ada data yang ditemukan
              if (culinaryItems.isEmpty) {
                return Center(
                    child: Text("Tidak ada data Kuliner yang tersedia."));
              }

              return HorizontalListView(items: culinaryItems);
            },
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          sliver: SliverToBoxAdapter(
            child: SectionTitle(
              title: 'Penginapan', // Ubah judul berdasarkan status pencarian
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('deskripsi_penginapan')
                .snapshots(), // Ambil semua data
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              // Lakukan pencarian manual di sisi klien berdasarkan input user atau rating
              List<Widget> accommodationItems =
                  snapshot.data!.docs.where((doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

                // Jika searchText kosong, filter berdasarkan rating
                if (searchText.isEmpty) {
                  if (data['rating'] != null) {
                    double rating = double.tryParse(data['rating']) ??
                        0.0; // Pastikan rating di-convert ke double
                    return rating >= 4.5; // Filter rating >= 4.5
                  }
                  return false;
                }

                // Jika searchText ada, tampilkan semua data tanpa filter rating
                String name = data['nama'].toString().toLowerCase();
                String searchLowerCase = searchText.toLowerCase();
                return name.contains(searchLowerCase);
              }).map((doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

                return AccommodationItem(
                  imageUrl: data['imageUrl'] ?? '',
                  name: data['nama'] ?? 'Unknown',
                  rating: data['rating'] ?? '0.0',
                  price: data['harga'] ?? 'Rp0',
                );
              }).toList();

              // Jika accommodationItems kosong, tampilkan teks bahwa tidak ada data yang ditemukan
              if (accommodationItems.isEmpty) {
                return Center(
                    child: Text("Tidak ada data Penginapan yang tersedia."));
              }

              return HorizontalListView(items: accommodationItems);
            },
          ),
        ),
      ],
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String imagePath; // Ubah menjadi path dari Firebase Storage
  final String label;

  CategoryItem({required this.imagePath, required this.label});

  Future<String> _getImageUrl() async {
    // Ambil URL gambar dari Firebase Storage
    return await FirebaseStorage.instance.ref(imagePath).getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Aksi yang diambil saat tombol ditekan
        if (label == 'Jadwal \nKapal') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => JadwalKapal()),
          );
        } else if (label == 'Penginapan') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Penginapan()),
          );
        } else if (label == 'Wisata') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Wisata()),
          );
        } else if (label == 'Paket \nPerjalanan') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PaketTravel()),
          );
        } else if (label == 'Kuliner') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Kuliner()),
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FutureBuilder<String>(
            future: _getImageUrl(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Tampilkan loading saat menunggu URL
              } else if (snapshot.hasError) {
                return Icon(Icons.error); // Tampilkan icon error jika gagal
              } else {
                return Container(
                  width: 49, // Sesuaikan ukuran gambar sesuai kebutuhan
                  height: 64,
                  decoration: BoxDecoration(
                    color: Color(0xFF4BBAE9),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0), // Menambahkan padding
                      child: Image.network(
                        snapshot.data!, // Load gambar dari URL
                        fit: BoxFit
                            .contain, // Mengubah fit gambar menjadi contain
                      ),
                    ),
                  ),
                );
              }
            },
          ),
          SizedBox(height: 8),
          Align(
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center, // Align text to center
            ),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class HorizontalListView extends StatelessWidget {
  final List<Widget> items;

  HorizontalListView({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      color: Colors.white,
      padding: EdgeInsets.only(left: 12.0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: items,
      ),
    );
  }
}

class DestinationItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String location;

  DestinationItem({
    required this.imageUrl,
    required this.name,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 16.0,
        left: 4.0,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WisataPage(
                namaWisata: name,
              ),
            ),
          );
        },
        child: Container(
          width: 142,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          margin: EdgeInsets.only(right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
                child: Image.network(imageUrl,
                    fit: BoxFit.cover, height: 160, width: double.infinity),
              ), // Menggunakan Image dari URL
              Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 6.0),
                child: Text(
                  name,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.location_on,
                              size: 12, color: Color(0xFF7F7F7F)),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              location,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF7F7F7F),
                              ),
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CulinaryItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String rating;

  CulinaryItem({
    required this.imageUrl,
    required this.name,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 16.0,
        left: 4.0,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KulinerPage(
                namaKuliner: name,
              ),
            ),
          );
        },
        child: Container(
          width: 142,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          margin: EdgeInsets.only(right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
                child: Image.network(imageUrl,
                    fit: BoxFit.cover, height: 160, width: double.infinity),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 6.0),
                child: Text(
                  name,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star, size: 12, color: Colors.yellow),
                          SizedBox(width: 4),
                          Text(
                            rating,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF7F7F7F),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AccommodationItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String rating;
  final String price;

  AccommodationItem({
    required this.imageUrl,
    required this.name,
    required this.rating,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 16.0,
        left: 4.0,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PenginapanPage(
                namaPenginapan: name,
              ),
            ),
          );
        },
        child: Container(
          width: 142,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          margin: EdgeInsets.only(right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
                child: Image.network(imageUrl,
                    fit: BoxFit.cover, height: 160, width: double.infinity),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 6.0),
                child: Text(
                  name,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star, size: 12, color: Colors.yellow),
                          SizedBox(width: 4),
                          Text(
                            rating,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF7F7F7F),
                            ),
                          ),
                          Spacer(),
                          Text(
                            price,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF7F7F7F),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
