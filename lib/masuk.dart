import 'package:eavell/beranda.dart';
import 'package:eavell/daftar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Masuk extends StatefulWidget {
  const Masuk({super.key});

  @override
  State<Masuk> createState() => _MasukState();
}

class _MasukState extends State<Masuk> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;
  bool _isemailFocused = false;
  bool _isPasswordFocused = false;
  String _errorMessage = '';
  String? bgImageUrl; // Variable untuk menyimpan URL gambar latar

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadBackgroundImage(); // Memuat gambar latar saat inisialisasi
  }

  // Fungsi untuk memuat gambar latar dari Firebase Storage
  Future<void> _loadBackgroundImage() async {
    try {
      final ref = FirebaseStorage.instance.ref().child('bg login.png'); // Sesuaikan path gambar
      String url = await ref.getDownloadURL();
      setState(() {
        bgImageUrl = url; // Mengatur URL gambar yang diambil
      });
    } catch (e) {
      print('Error loading background image: $e');
    }
  }

  Future<void> _loginWithEmailPassword() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Jika login berhasil, navigasi ke halaman Beranda
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Beranda()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        // Tentukan pesan kesalahan manual berdasarkan kode kesalahan
        if (e.code == 'wrong-password') {
          _errorMessage = 'Kata sandi yang Anda masukkan salah.';
        } else if (e.code == 'user-not-found') {
          _errorMessage = 'Email tidak terdaftar.';
        } else if (e.code == 'invalid-email') {
          _errorMessage = 'Format email tidak valid.';
        } else if (e.code == 'user-disabled') {
          _errorMessage = 'Akun ini telah dinonaktifkan.';
        } else {
          _errorMessage = 'Terjadi kesalahan. Silakan coba lagi.';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Memuat latar belakang dari Firebase Storage
          bgImageUrl == null
              ? Center(child: CircularProgressIndicator()) // Loader saat memuat
              : Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(bgImageUrl!), // Gambar dari Firebase Storage
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 100.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      'Masuk',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 35.0, left: 25),
                      child: Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 340,
                    height: 43,
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText:
                            _isemailFocused ? null : 'Masukkan Email Anda',
                        labelStyle: TextStyle(
                          color: Color(0xFFA0A1A8),
                        ),
                        alignLabelWithHint: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 35.0, horizontal: 10),
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _isemailFocused = value.isNotEmpty;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0, left: 25),
                      child: Text(
                        'Kata Sandi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 340,
                    height: 43,
                    child: TextField(
                      controller: _passwordController,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        labelText: _isPasswordFocused
                            ? null
                            : 'Masukkan Kata Sandi Anda',
                        labelStyle: TextStyle(
                          color: Color(0xFFA0A1A8),
                        ),
                        alignLabelWithHint: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10),
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _isPasswordFocused = value.isNotEmpty;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  if (_errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        _errorMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  SizedBox(height: 238),
                  Container(
                    width: 180,
                    height: 62,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 4),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _loginWithEmailPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(10),
                      ),
                      child: Text(
                        'Masuk',
                        style: TextStyle(
                          color: Color(0xFF1097D0),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Belum punya akun?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Daftar()),
                          );
                        },
                        child: Text(
                          'Daftar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
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
    );
  }
}