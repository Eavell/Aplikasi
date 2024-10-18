import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Tambahkan import Firebase Storage
import 'package:eavell/masuk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase Auth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Daftar(),
    );
  }
}

class Daftar extends StatefulWidget {
  const Daftar({super.key});

  @override
  State<Daftar> createState() => _DaftarState();
}

class _DaftarState extends State<Daftar> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;
  bool _isUsernameFocused = false;
  bool _isemailFocused = false;
  bool _isPasswordFocused = false;
  String _backgroundImageUrl = ''; // Variabel untuk menyimpan URL latar belakang
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadBackgroundImage(); // Memanggil method untuk mengambil gambar latar belakang
  }

  // Method untuk mengambil URL gambar dari Firebase Storage
  Future<void> _loadBackgroundImage() async {
    try {
      // Mengambil URL dari Firebase Storage
      String url = await FirebaseStorage.instance
          .ref('bg login.png')
          .getDownloadURL();

      setState(() {
        _backgroundImageUrl = url;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat gambar latar belakang.';
      });
    }
  }

  // Method untuk registrasi menggunakan Firebase Authentication
  Future<void> _registerWithEmailPassword(String email, String password, String name) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCredential.user;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': email,
        'name': name,
        'createdAt': Timestamp.now(),
        'profileImageUrl': '', // Field profile image dengan nilai kosong
      });
    }
    print('User registered and data saved in Firestore');
  } on FirebaseAuthException catch (e) {
    // Tampilkan pesan kesalahan yang sesuai
    if (e.code == 'email-already-in-use') {
      print('Email sudah digunakan. Silakan coba email lain.');
    } else if (e.code == 'weak-password') {
      print('Password terlalu lemah. Harap gunakan password yang lebih kuat.');
    } else {
      print('Error: ${e.message}');
    }
  } catch (e) {
    print('Error: $e');
  }
}


  void _togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Tampilkan gambar latar jika URL sudah diambil
           if (_backgroundImageUrl.isNotEmpty)
            CachedNetworkImage(
              imageUrl: _backgroundImageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(), // Tampilkan loading jika gambar belum diambil
              ),
              errorWidget: (context, url, error) => Center(
                child: Text('Gagal memuat gambar latar belakang'), // Tampilkan pesan jika gagal memuat gambar
              ),
            ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 100.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        'Daftar',
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
                          padding: const EdgeInsets.only(top: 35.0, left: 25),
                          child: Text(
                            'Nama',
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
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: _isUsernameFocused
                                ? null
                                : 'Masukkan Nama Anda',
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
                              _isUsernameFocused = value.isNotEmpty;
                            });
                          },
                        ),
                      ),
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
                            labelText: _isemailFocused
                                ? null
                                : 'Masukkan Email Anda',
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
                      SizedBox(height: 210),
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
                          onPressed: () async {
                            try {
                              // Daftarkan pengguna dengan email dan password
                              UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );

                              // Setelah berhasil, simpan data ke Firestore
                              await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
                                'email': _emailController.text,
                                'createdAt': Timestamp.now(), // Tanggal pendaftaran
                                'uid': userCredential.user!.uid, // ID pengguna dari Firebase Authentication
                                'name' : _usernameController.text,
                                'profileImageUrl': '', // Field profile image dengan nilai kosong
                                // Tambahkan data lain yang diperlukan di sini, seperti nama pengguna atau peran
                              });

                              // Arahkan ke halaman login setelah berhasil menyimpan data
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => Masuk()), // Ganti LoginPage dengan halaman login kamu
                              );
                            } on FirebaseAuthException catch (e) {
                              setState(() {
                                if (e.code == 'weak-password') {
                                  _errorMessage = 'Kata sandi terlalu lemah.';
                                } else if (e.code == 'email-already-in-use') {
                                  _errorMessage = 'Akun dengan email ini sudah terdaftar.';
                                } else if (e.code == 'invalid-email') {
                                  _errorMessage = 'Format email tidak valid.';
                                } else {
                                  _errorMessage = 'Terjadi kesalahan. Silakan coba lagi.';
                                }
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.all(10),
                          ),
                          child: Text(
                            'Daftar',
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
                              '  Sudah punya akun? ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextButton(
                              onPressed: () { 
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Masuk()),);
                              },
                                child: Text(
                                  'Masuk',
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
          ),
        ],
      ),
    );
  }
}
