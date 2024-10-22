import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eavell/beranda.dart';
import 'package:flutter/material.dart';
import 'deskripsi_penginapan.dart';

class Penginapan extends StatefulWidget {
  const Penginapan({Key? key}) : super(key: key);

  @override
  _PenginapanState createState() => _PenginapanState();
}

class _PenginapanState extends State<Penginapan> {
  // Firestore instance
  final CollectionReference _accommodationCollection =
      FirebaseFirestore.instance.collection('deskripsi_penginapan');

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
                      'Penginapan',
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
      body: StreamBuilder<QuerySnapshot>(
        stream: _accommodationCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Tidak ada data penginapan yang tersedia."));
          }

          // Convert the query snapshot into a list of widgets
          List<Widget> accommodationItems = snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return AccommodationItem(
              assetPath: data['imageUrl'] ?? '',
              name: data['nama'] ?? 'Unknown',
              rating: (data['rating'] is String) ? double.parse(data['rating']) : data['rating'].toDouble(),
              price: data['harga'] ?? 'Unknown',
              // price: (data['harga'] is String) ? double.parse(data['harga']) : data['harga'].toDouble(),
            );
          }).toList();

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: VerticalGridView(items: accommodationItems),
              ),
            ],
          );
        },
      ),
    );
  }
}

class VerticalGridView extends StatelessWidget {
  final List<Widget> items;

  VerticalGridView({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(), // Disable GridView scrolling
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Jumlah kolom
          childAspectRatio: 142 / 230, // Rasio lebar dan tinggi dari grid item
          crossAxisSpacing: 16.0, // Spasi antara kolom
          mainAxisSpacing: 24.0, // Spasi antara baris
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return items[index];
        },
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
    return GestureDetector(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
              child: Image.network(assetPath,
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
    );
  }
}
