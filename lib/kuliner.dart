import 'package:eavell/beranda.dart';
import 'package:flutter/material.dart';

class Kuliner extends StatefulWidget {
  const Kuliner({Key? key}) : super(key: key);

  @override
  _KulinerState createState() => _KulinerState();
}

class _KulinerState extends State<Kuliner> {
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
                      'Kuliner',
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
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: VerticalGridView(
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
                  name: 'Nasi Gulai Kambing Yah Tad',
                  rating: 4.3,
                ),
              ],
            ),
          ),
        ],
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
    return GestureDetector(
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
              child: Image.asset(assetPath,
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
