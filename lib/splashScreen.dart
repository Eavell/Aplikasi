import 'package:eavell/perkenalan.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Import untuk caching gambar

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String imageUrl = ''; // URL gambar dari Firebase

  @override
  void initState() {
    super.initState();
    _loadImageFromFirebase();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Perkenalan()), // Navigasi ke halaman berikutnya
      );
    });
  }

  // Fungsi untuk mengambil gambar dari Firebase Storage
  Future<void> _loadImageFromFirebase() async {
    try {
      // Referensi ke gambar di Firebase Storage
      final ref = FirebaseStorage.instance.ref().child('Splash.png');

      // Ambil URL gambar
      String url = await ref.getDownloadURL();

      setState(() {
        imageUrl = url; // Set URL gambar
      });
    } catch (e) {
      print('Error fetching image from Firebase: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.85, 0.08),
          end: Alignment(0.09, 0.98),
          colors: [
            Color(0xFFA9DDF3), // Warna hex light blue #B3E5FC
            Color(0xFF5EB2DC), // Warna hex darker blue #0288D1
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          imageUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl:
                      imageUrl, // Menampilkan gambar dari Firebase dengan cache
                  width: 180,
                  height: 180,
                  errorWidget: (context, url, error) =>
                      Icon(Icons.error), // Jika terjadi error
                )
              : CircularProgressIndicator(),
        ],
      ),
    );
  }
}