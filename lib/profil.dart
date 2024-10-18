import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eavell/beranda.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({Key? key}) : super(key: key);

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  String userName = ''; // Untuk menyimpan nama pengguna
  String userEmail = ''; // Untuk menyimpan email pengguna
  String profileImageUrl = ''; // Untuk menyimpan URL gambar profil

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _getUserData(); // Ambil nama, email, dan gambar profil pengguna
  }

  // Fungsi untuk mengambil data pengguna dari Firestore
  Future<void> _getUserData() async {
    try {
      // Ambil UID pengguna yang sedang login
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Ambil email dari FirebaseAuth
        userEmail = user.email ?? 'No Email';

        // Ambil data dari Firestore menggunakan UID pengguna
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        setState(() {
          // Ambil nama dari Firestore
          userName = userData['name'] ?? 'No Name';

          // Ambil URL gambar profil dari Firestore, atau gunakan gambar default
          profileImageUrl = userData['profileImageUrl'] ?? '';
        });
      }
    } catch (e) {
      print('Error getting user data: $e');
    }
  }

  // Fungsi untuk memilih gambar dari galeri atau kamera
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery); // Pilih gambar dari galeri
    if (image != null) {
      await _uploadImageToFirebase(File(image.path)); // Unggah gambar ke Firebase
    }
  }

  // Fungsi untuk mengunggah gambar ke Firebase Storage
  Future<void> _uploadImageToFirebase(File imageFile) async {
    try {
      // Ambil UID pengguna
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;

        // Path di Firebase Storage
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('profileImages')
            .child(userId + '.jpg');

        // Unggah gambar
        UploadTask uploadTask = ref.putFile(imageFile);

        // Tunggu hingga selesai
        TaskSnapshot taskSnapshot = await uploadTask;

        // Dapatkan URL gambar yang sudah diunggah
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        // Simpan URL gambar di Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({'profileImageUrl': downloadUrl});

        // Perbarui state untuk menampilkan gambar baru
        setState(() {
          profileImageUrl = downloadUrl;
        });
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(58.0), // Tinggi AppBar
        child: Container(
          height: 170.0, // Tinggi AppBar
          width: double.infinity, // Lebar AppBar, mengikuti lebar layar
          color: Color(0xFF4BBAE9), // Warna latar belakang AppBar
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: screenWidth * 0.04,
                    top: 35.0), // Mengatur posisi x dan y
                child: IconButton(
                  icon: Icon(Icons.arrow_back), // Ikon kembali bawaan Flutter
                  color: Colors.white, // Mengubah warna ikon menjadi putih
                  iconSize: screenWidth * 0.07, // Ukuran ikon
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Beranda()),
                    );
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 35.0), // Menyamakan posisi y dengan ikon kembali
                  child: Center(
                    child: Text(
                      'Paket Travel',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                  width: screenWidth *
                      0.1), // Spacer untuk mengimbangi tombol kembali di kanan
            ],
          ),
        ),
      ),

      //Bagian Bawah
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 300,
                  color: Colors.white,
                ),
                Positioned(
                  top: 60,
                  left: 25,
                  right: 25,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 60), // Spacer for the profile picture
                        Text(
                          userName.isNotEmpty
                              ? userName
                              : 'Loading...', // Tampilkan nama pengguna
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          userEmail.isNotEmpty
                              ? userEmail
                              : 'Loading...', // Tampilkan email pengguna
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 48, // Ukuran untuk gambar profil
                          backgroundImage: profileImageUrl.isNotEmpty
                              ? NetworkImage(profileImageUrl) // Jika URL gambar profil ada, gunakan gambar dari internet
                              : AssetImage('assets/defaultProfile.png')
                                  as ImageProvider, // Jika tidak ada gambar, gunakan gambar default dari assets
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: _pickImage, // Ketika tombol edit ditekan
                          child: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            sliver: SliverToBoxAdapter(
              child: SectionTitle(title: 'Wisata Populer'),
            ),
          ),
          SliverToBoxAdapter(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('destination')
                  .orderBy('createdAt',
                      descending: true) // Urutkan berdasarkan waktu penambahan
                  .limit(5)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No destinations found'));
                }

                var destinations = snapshot.data!.docs;

                // Buat list DestinationItem dari data Firestore
                List<DestinationItem> destinationItems =
                    destinations.map((doc) {
                  var data = doc.data() as Map<String, dynamic>;

                  // Periksa apakah field ada dan tidak null
                  String imageUrl = data['imageUrl'] ??
                      'default_image_url'; // URL gambar default
                  String name =
                      data['name'] ?? 'Unnamed'; // Nama default jika null
                  String location = data['location'] ??
                      'Unknown Location'; // Lokasi default jika null

                  return DestinationItem(
                    imageUrl: imageUrl,
                    name: name,
                    location: location,
                  );
                }).toList();

                return HorizontalListView(items: destinationItems);
              },
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            sliver: SliverToBoxAdapter(
              child: SectionTitle(title: 'Kuliner Populer'),
            ),
          ),
          SliverToBoxAdapter(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('culinary')
                  .orderBy('createdAt', descending: true)
                  .limit(5)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No culinarys found'));
                }

                var culinarys = snapshot.data!.docs;

                // Buat list CulinaryItem dari data Firestore
                List<CulinaryItem> culinaryItems = culinarys.map((doc) {
                  var data = doc.data() as Map<String, dynamic>;

                  // Periksa apakah field ada dan tidak null
                  String imageUrl = data['imageUrl'] ??
                      'default_image_url'; // Ganti dengan URL gambar default jika perlu
                  String name =
                      data['name'] ?? 'Unnamed'; // Ganti dengan nilai default

                  // Konversi rating dari String ke double
                  double rating;
                  if (data['rating'] != null) {
                    try {
                      rating = double.parse(
                          data['rating']); // Konversi String ke double
                    } catch (e) {
                      rating = 0.0; // Nilai default jika konversi gagal
                    }
                  } else {
                    rating = 0.0; // Nilai default jika null
                  }

                  return CulinaryItem(
                    imageUrl: imageUrl,
                    name: name,
                    rating: rating,
                  );
                }).toList();

                return HorizontalListView(items: culinaryItems);
              },
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            sliver: SliverToBoxAdapter(
              child: SectionTitle(title: 'Penginapan Populer'),
            ),
          ),
          SliverToBoxAdapter(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('accommodation')
                  .orderBy('createdAt', descending: true)
                  .limit(5)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No  accommodations found'));
                }

                var accommodationns = snapshot.data!.docs;

                // Buat list DestinationItem dari data Firestore
                List<AccommodationItem> accommodationyItems =
                    accommodationns.map((doc) {
                  var data = doc.data() as Map<String, dynamic>;

                  // Periksa apakah field ada dan tidak null
                  String imageUrl = data['imageUrl'] ??
                      'default_image_url'; // Ganti dengan URL gambar default jika perlu
                  String name =
                      data['name'] ?? 'Unnamed'; // Ganti dengan nilai default

                  // Konversi rating dari String ke double
                  double rating;
                  if (data['rating'] != null) {
                    try {
                      rating = double.parse(
                          data['rating']); // Konversi String ke double
                    } catch (e) {
                      rating = 0.0; // Nilai default jika konversi gagal
                    }
                  } else {
                    rating = 0.0; // Nilai default jika null
                  }
                  String price =
                      data['price'] ?? 'Unprice'; // Ganti dengan nilai default

                  return AccommodationItem(
                    imageUrl: imageUrl,
                    name: name,
                    rating: rating,
                    price: price,
                  );
                }).toList();

                return HorizontalListView(items: accommodationyItems);
              },
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
              Image.network(imageUrl,
                  fit: BoxFit.cover,
                  height: 160,
                  width: 150), // Menggunakan Image dari URL
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
  final double rating;

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
        // onTap: () {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => DetailKulinerPage(
        //         name: name,
        //       ),
        //     ),
        //   );
        // },
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
              Image.network(imageUrl,
                  fit: BoxFit.cover, height: 160, width: 150),
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
                            '$rating',
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
  final double rating;
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
        // onTap: () {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => DetailPenginapanPage(
        //         name: name,
        //       ),
        //     ),
        //   );
        // },
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
              Image.network(imageUrl,
                  fit: BoxFit.cover, height: 160, width: 150),
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
                            '$rating',
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
