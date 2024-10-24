import 'package:eavell/beranda.dart';
import 'package:eavell/perkenalan.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CheckLogin()), // Navigasi ke halaman berikutnya
      );
    });
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
          Image.asset(
            'assets/Splash.png', // Menampilkan gambar lokal dari folder assets
            width: 180,
            height: 180,
          ),
        ],
      ),
    );
  }
}


class CheckLogin extends StatefulWidget {
  @override
  _CheckLoginState createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Navigasi ke halaman berbeda berdasarkan status login
    return _isLoggedIn ? Beranda() : Perkenalan();
  }
}