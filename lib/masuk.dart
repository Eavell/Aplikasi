import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eavell/beranda.dart';
import 'package:eavell/daftar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> saveLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true); // Simpan status login
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> _getEmailFromName(String name) async {
    try {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('users')
          .where('name', isEqualTo: name)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        return query.docs.first['email'];
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<void> _loginWithEmailPassword() async {
    try {
      // Normalisasi input sebelum login
      String emailOrName = normalizeEmailOrUsername(_emailController.text);
      String? email;

      bool isEmail = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailOrName);

      if (isEmail) {
        email = emailOrName;
      } else {
        email = await _getEmailFromName(emailOrName);

        if (email == null) {
          setState(() {
            _errorMessage = 'Nama pengguna tidak ditemukan.';
          });
          return;
        }
      }

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email!,
        password: _passwordController.text,
      );

      saveLoginStatus();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Beranda()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'wrong-password') {
          _errorMessage = 'Kata sandi yang Anda masukkan salah.';
        } else if (e.code == 'user-not-found') {
          _errorMessage = 'Email atau nama tidak terdaftar.';
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

  String normalizeEmailOrUsername(String input) {
    return input.trim().toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/bg login.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
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
                        'Nama Atau Email',
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
                        labelText: _isemailFocused ? null : 'Masukkan Nama Atau Email Anda',
                        labelStyle: TextStyle(
                          color: Color(0xFFA0A1A8),
                        ),
                        alignLabelWithHint: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 35.0, horizontal: 10),
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
                        labelText: _isPasswordFocused ? null : 'Masukkan Kata Sandi Anda',
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
