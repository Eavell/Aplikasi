import 'package:flutter/material.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({Key? key}) : super(key: key);

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  
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
                padding: EdgeInsets.only(left: screenWidth * 0.04, top: 35.0), // Mengatur posisi x dan y
                child: IconButton(
                  icon: Icon(Icons.arrow_back), // Ikon kembali bawaan Flutter
                  color: Colors.white, // Mengubah warna ikon menjadi putih
                  iconSize: screenWidth * 0.07, // Ukuran ikon
                  onPressed: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => Beranda()),);
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 35.0), // Menyamakan posisi y dengan ikon kembali
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
              SizedBox(width: screenWidth * 0.1), // Spacer untuk mengimbangi tombol kembali di kanan
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
                          'Ucok',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'ucok69@gmail.com',
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
                          radius: 48, // Slightly smaller radius for the image
                          backgroundImage: AssetImage('assets/images/profil.png'),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
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