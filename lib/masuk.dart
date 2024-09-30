import 'package:eavell/beranda.dart';
import 'package:eavell/daftar.dart';
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

  // Variable untuk menyimpan URL gambar latar
  String? bgImageUrl; // Mengubah menjadi nullable

  @override
  void initState() {
    super.initState();
    _loadBackgroundImage();
  }

  // Fungsi untuk memuat gambar latar dari Firebase Storage
  Future<void> _loadBackgroundImage() async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('bg login.png'); // Pastikan path sesuai
      String url = await ref.getDownloadURL();
      setState(() {
        bgImageUrl = url; // Mengatur URL gambar yang diambil
      });
    } catch (e) {
      print('Error loading background image: $e');
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure; // Toggle visibility of password
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          bgImageUrl == null // Memastikan bgImageUrl sudah dimuat
              ? Center(
                  child:
                      CircularProgressIndicator()) // Menampilkan loader saat loading
              : Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          bgImageUrl!), // Gunakan URL dari Firebase Storage
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 105),
                    child: Text(
                      'Masuk',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 25.0, left: 25),
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
                            _isemailFocused =
                                value.isNotEmpty; // Update focus state
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 10),
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
                            onPressed: _togglePasswordVisibility,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _isPasswordFocused =
                                value.isNotEmpty; // Update focus state
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 313),
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Beranda()),
                          );
                        },
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
                    Align(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '  Belum punya akun? ',
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
                                MaterialPageRoute(
                                    builder: (context) => Daftar()),
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
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
