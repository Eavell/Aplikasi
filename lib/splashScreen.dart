import 'package:eavell/perkenalan.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Hanya import firebase_storage

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String imageUrl = 'https://firebasestorage.googleapis.com/v0/b/trip-nest-d599a.appspot.com/o/Splash.png?alt=media&token=86509ca2-efa2-46b2-8df6-79bb48cdcccb'; // URL gambar dari Firebase

  @override
  void initState() {
    super.initState();
    _loadImageFromFirebase();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Perkenalan()), // Navigasi ke halaman berikutnya
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
          colors: [Colors.lightBlue[100]!, Colors.lightBlue[300]!],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl, // Menampilkan gambar dari Firebase Storage
                  width: 180,
                  height: 180,
                )
              : CircularProgressIndicator(), // Menampilkan loading jika gambar belum diambil
        ],
      ),
    );
  }
}
