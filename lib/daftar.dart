import 'package:eavell/masuk.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Impor package Firebase Storage

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

  // Remainder of your code...
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordFocused = !_isPasswordFocused;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gunakan Image.network untuk menampilkan gambar dari Firebase
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
                ), // Tampilkan indikator loading saat mengambil gambar
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topCenter, // Atur posisi vertikal sesuai kebutuhan
                  
                  child: Padding(
                    padding: const EdgeInsets.only(top: 105), // Atur padding sesuai kebutuhan
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
                        alignment: Alignment.topLeft, // Atur posisi vertikal sesuai kebutuhan
                        child: Padding(
                          padding: const EdgeInsets.only(top: 35.0, left: 25), // Atur padding sesuai kebutuhan
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
                        height: 43, // Memastikan TextField mengikuti lebar Container induknya
                        child: TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: _isUsernameFocused ? null : 'Masukkan Nama Anda',
                            labelStyle: TextStyle(
                             color: Color(0xFFA0A1A8), // Warna teks label (placeholder)
                            ),
                            alignLabelWithHint: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 35.0, horizontal: 10),
                            fillColor: Colors.white, // Warna latar belakang kolom username
                            filled: true, // Mengaktifkan latar belakang berwarna
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: BorderSide(color: Colors.white), // Ubah warna border
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: BorderSide(color: Colors.white), // Ubah warna border
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                          ),
                          onChanged: (value) {
                            setState(() {
                              // Ketika ada perubahan teks, perbarui status _isUsernameFocused
                              _isUsernameFocused = value.isNotEmpty;
                            });
                          },
                        ),
                      ),

                      Align(
                        alignment: Alignment.topLeft, // Atur posisi vertikal sesuai kebutuhan
                        child: Padding(
                          padding: const EdgeInsets.only(top: 25.0, left: 25), // Atur padding sesuai kebutuhan
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
                        height: 43, // Memastikan TextField mengikuti lebar Container induknya
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: _isemailFocused ? null : 'Masukkan Email Anda',
                            labelStyle: TextStyle(
                             color: Color(0xFFA0A1A8), // Warna teks label (placeholder)
                            ),
                            alignLabelWithHint: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 35.0, horizontal: 10),
                            fillColor: Colors.white, // Warna latar belakang kolom username
                            filled: true, // Mengaktifkan latar belakang berwarna
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: BorderSide(color: Colors.white), // Ubah warna border
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: BorderSide(color: Colors.white), // Ubah warna border
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                          ),
                          onChanged: (value) {
                            setState(() {
                              // Ketika ada perubahan teks, perbarui status _isemailFocused
                              _isemailFocused = value.isNotEmpty;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.topLeft, // Atur posisi vertikal sesuai kebutuhan
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15.0, left: 25), // Atur padding sesuai kebutuhan
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
                  height: 43, // Memastikan TextField mengikuti lebar Container induknya
                  child: TextField(
                    controller: _passwordController,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      labelText: _isPasswordFocused ? null : 'Masukkan Kata Sandi Anda',
                      labelStyle: TextStyle(
                        color: Color(0xFFA0A1A8), // Warna teks label (placeholder)
                      ),
                      alignLabelWithHint: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10), // Disesuaikan padding vertical
                      fillColor: Colors.white, // Warna latar belakang kolom username
                      filled: true, // Mengaktifkan latar belakang berwarna
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: BorderSide(color: Colors.white), // Ubah warna border
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: BorderSide(color: Colors.white), // Ubah warna border
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure; // Mengubah nilai _isObscure
                          });
                        },
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        // Ketika ada perubahan teks, perbarui status _isPasswordFocused
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
                              offset: Offset(0, 4), // Mengatur offset bayangan (x, y)
                              blurRadius: 5, // Mengatur blur radius dari bayangan
                              spreadRadius: 1, // Mengatur penyebaran bayangan
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Masuk()),);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // Warna latar belakang tombol
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.all(10), // Padding di dalam tombol
                          ),
                          child: Text('Daftar',
                          style: TextStyle(
                            color: Color(0xFF1097D0), // Warna teks
                            fontSize:24, // Ukuran font
                            fontWeight: FontWeight.bold
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
        ],
      ),
    );
  }
}
