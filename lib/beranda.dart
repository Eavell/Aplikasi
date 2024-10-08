import 'package:eavell/splashScreen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Beranda extends StatefulWidget {
  const Beranda({Key? key}) : super(key: key);

  @override
  _BerandaState createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  String userName = ''; // Untuk menyimpan nama pengguna
  String profileImageUrl = ''; // Untuk menyimpan URL gambar profil

  @override
  void initState() {
    super.initState();
    _getUserName(); // Ambil nama pengguna
    _getProfileData(); // Ambil gambar profil
  }

  // Fungsi untuk mengambil nama pengguna dari Firestore
  Future<void> _getUserName() async {
    try {
      // Ambil UID pengguna yang sedang login
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Ambil data dari Firestore menggunakan UID pengguna
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        setState(() {
          // Ambil nama dari Firestore dan simpan dalam variabel
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
        // Ambil data pengguna dari Firestore menggunakan UID
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        setState(() {
          // Ambil nama dari Firestore
          userName = userData['name'];

          // Periksa apakah 'profileImageUrl' ada dan tidak null, jika tidak ada gunakan gambar default
          profileImageUrl = userData['profileImageUrl'] ?? ''; // Kosong jika belum diatur
        });
      }
    } catch (e) {
      print('Error getting profile data: $e');
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
                            builder: (context) => SplashScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(30.0),
                      splashColor: Colors.blue.withAlpha(30),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: profileImageUrl.isNotEmpty
                            ? NetworkImage(profileImageUrl) // Gunakan URL jika ada
                            : AssetImage('assets/defaultProfile.png'), // Gambar default jika null atau kosong
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 40.0,
                  child: TextField(
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Color(0xFFFB6BBC4),
                      fontWeight: FontWeight.w300,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Mau ke mana hari ini?',
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: CustomScrollView(
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
                          vertical: 12.0,
                          horizontal:
                              12.0), // Menambahkan padding atas, kanan, dan kiri
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween, // Rata kanan kiri
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Rata atas
                        children: [
                          CategoryItem(
                            icon: AssetImage('assets/jadwal kapal.png'),
                            label: 'Jadwal \nKapal',
                          ),
                          CategoryItem(
                            icon: AssetImage('assets/penginapan.png'),
                            label: 'Penginapan',
                          ),
                          CategoryItem(
                            icon: AssetImage('assets/wisata.png'),
                            label: 'Wisata',
                          ),
                          CategoryItem(
                            icon: AssetImage('assets/paket perjalanan.png'),
                            label: 'Paket \nPerjalanan',
                          ),
                          CategoryItem(
                            icon: AssetImage('assets/kuliner.png'),
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
              child: SectionTitle(title: 'Wisata Populer'),
            ),
          ),
          SliverToBoxAdapter(
            child: HorizontalListView(
              items: [
                DestinationItem(
                  assetPath: 'assets/pulau rubiah.png',
                  name: 'Pulau Rubiah',
                  location: 'Kota Sabang, Aceh 24411',
                ),
                DestinationItem(
                  assetPath: 'assets/pulau rubiah.png',
                  name: 'Pantai Iboih',
                  location: 'Kota Sabang, Aceh',
                ),
                DestinationItem(
                  assetPath: 'assets/pulau rubiah.png',
                  name: 'Pantai Iboih',
                  location: 'Kota Sabang, Aceh',
                ),
                DestinationItem(
                  assetPath: 'assets/pulau rubiah.png',
                  name: 'Pantai Iboih',
                  location: 'Kota Sabang, Aceh',
                ),
                DestinationItem(
                  assetPath: 'assets/pulau rubiah.png',
                  name: 'Pantai Iboih',
                  location: 'Kota Sabang, Aceh',
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            sliver: SliverToBoxAdapter(
              child: SectionTitle(title: 'Kuliner Populer'),
            ),
          ),
          SliverToBoxAdapter(
            child: HorizontalListView(
              items: [
                CulinaryItem(
                  assetPath: 'assets/montana.png',
                  name: 'Montana Nasi Goreng',
                  rating: 4.3,
                ),
                CulinaryItem(
                  assetPath: 'assets/montana.png',
                  name: 'RM Murah Raya',
                  rating: 4.3,
                ),
                CulinaryItem(
                  assetPath: 'assets/montana.png',
                  name: 'RM Murah Raya',
                  rating: 4.3,
                ),
                CulinaryItem(
                  assetPath: 'assets/montana.png',
                  name: 'RM Murah Raya',
                  rating: 4.3,
                ),
                CulinaryItem(
                  assetPath: 'assets/montana.png',
                  name: 'RM Murah Raya',
                  rating: 4.3,
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            sliver: SliverToBoxAdapter(
              child: SectionTitle(title: 'Penginapan Populer'),
            ),
          ),
          SliverToBoxAdapter(
            child: HorizontalListView(
              items: [
                AccommodationItem(
                  assetPath: 'assets/hawk.png',
                  name: 'The Hawk\'s Nest Resort',
                  rating: 4.6,
                  price: 'Rp 700.000',
                ),
                AccommodationItem(
                  assetPath: 'assets/hawk.png',
                  name: 'Weh Ocean Resort',
                  rating: 4.7,
                  price: 'Rp 1.910.000',
                ),
                AccommodationItem(
                  assetPath: 'assets/hawk.png',
                  name: 'Weh Ocean Resort',
                  rating: 4.7,
                  price: 'Rp 1.910.000',
                ),
                AccommodationItem(
                  assetPath: 'assets/hawk.png',
                  name: 'Weh Ocean Resort',
                  rating: 4.7,
                  price: 'Rp 1.910.000',
                ),
                AccommodationItem(
                  assetPath: 'assets/hawk.png',
                  name: 'Weh Ocean Resort',
                  rating: 4.7,
                  price: 'Rp 1.910.000',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final ImageProvider icon;
  final String label;

  CategoryItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () {
      //   // Aksi yang diambil saat tombol ditekan
      //   if (label == 'Jadwal \nKapal') {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => JadwalKapal()),
      //     );
      //   } else if (label == 'Penginapan') {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => Penginapan()),
      //     );
      //   } else if (label == 'Wisata') {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => Wisata()),
      //     );
      //   } else if (label == 'Paket \nPerjalanan') {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => PaketPerjalanan()),
      //     );
      //   } else if (label == 'Kuliner') {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => Kuliner()),
      //     );
      //   }
      // },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
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
                child: Image(
                  image: icon,
                  fit: BoxFit.contain, // Mengubah fit gambar menjadi contain
                ),
              ),
            ),
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
  final String assetPath;
  final String name;
  final String location;

  DestinationItem({
    required this.assetPath,
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
        // onTap: () {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => DetailWisataPage(
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
              Image.asset(assetPath,
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
  final String assetPath;
  final String name;
  final double rating;

  CulinaryItem({
    required this.assetPath,
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
              Image.asset(assetPath,
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
  final String assetPath;
  final String name;
  final double rating;
  final String price;

  AccommodationItem({
    required this.assetPath,
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
              Image.asset(assetPath,
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
