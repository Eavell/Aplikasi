import 'package:eavell/JadwalKapal.dart';
import 'package:flutter/material.dart';

class Tiket extends StatefulWidget {
  final String date;      // Parameter untuk tanggal
  final String schedule;  // Parameter untuk jadwal/trip

  const Tiket({super.key, required this.date, required this.schedule});  

  @override
  State<Tiket> createState() => _TiketState();
}

class _TiketState extends State<Tiket> {
  List<Widget> passengers = [];
  double screenWidth = 0;
  double screenHeight = 0;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Mengambil ukuran layar dari MediaQuery di sini
    final mediaQuery = MediaQuery.of(context);
    screenWidth = mediaQuery.size.width;
    screenHeight = mediaQuery.size.height;

    if (passengers.isEmpty) {
      addPassenger(); // Tambahkan penumpang pertama jika list kosong
    }
  }

  void addPassenger() {
    int passengerNumber = passengers.length + 1;
    setState(() {
      passengers.add(_buildPassengerContainer(passengerNumber));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(58.0),
        child: Container(
          height: screenHeight * 0.1,
          width: double.infinity,
          color: Color(0xFF4BBAE9),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: screenWidth * 0.04, top: screenHeight * 0.030),
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: Colors.white,
                  iconSize: screenWidth * 0.07,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => JadwalKapal()),
                    );
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.030),
                  child: Center(
                    child: Text(
                      'Isi Data Tiket',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.1),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.01),
            Container(
              width: screenWidth * 0.95,
              height: screenHeight * 0.1,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFF4BBAE9),
                    width: 1.0,
                  ),
                ),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.date,
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      widget.schedule,
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(children: passengers),
            Align(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: addPassenger,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: Color(0xFF4BBAE9),
                          size: 24.0,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'Tambah Penumpang',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4BBAE9),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            Container(
              width: screenWidth * 0.95,
              height: screenHeight * 0.06,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4BBAE9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  padding: EdgeInsets.all(10),
                ),
                child: Text(
                  'Kirim',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }

  Widget _buildPassengerContainer(int passengerNumber) {
    return Center(
      child: Container(
        width: screenWidth * 0.95,
        height: screenHeight * 0.59,
        margin: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.02,
          horizontal: screenWidth * 0.01,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 20,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '    Penumpang $passengerNumber',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            _buildInputField('Nama', 'Masukkan Nama Anda', screenWidth),
            _buildInputField('Umur', 'Masukkan Umur Anda', screenWidth),
            _buildInputField('Alamat', 'Masukkan Alamat Anda', screenWidth),
            _buildDropdownField(screenWidth),
            _buildInputField('Plat Kendaraan (Opsional)',
                'Masukkan Plat Kendaraan Anda', screenWidth),
            SizedBox(height: screenHeight * 0.01),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    passengers.removeAt(passengerNumber - 1);
                  });
                },
                child: Text(
                  'Hapus',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String hint, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: screenWidth * 0.01,
            left: screenWidth * 0.06,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(height: screenWidth * 0.02),
        Container(
          width: screenWidth * 0.86,
          height: 43,
          child: TextField(
            decoration: InputDecoration(
              labelText: hint,
              labelStyle: TextStyle(
                color: Color(0xFFA0A1A8),
              ),
              contentPadding: EdgeInsets.symmetric(
                  vertical: 40.0, horizontal: screenWidth * 0.05),
              fillColor: Colors.white,
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Color(0xFF7F7F7F)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Color(0xFF7F7F7F)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: screenWidth * 0.01,
            left: screenWidth * 0.06,
          ),
          child: Text(
            'Jenis Kendaraan (Opsional)',
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(height: screenWidth * 0.02),
        Container(
          width: screenWidth * 0.86,
          height: 43,
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFF7F7F7F)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButton<String>(
            hint: Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Text('Pilih jenis kendaraan'),
          ),
            underline: SizedBox(),
            isExpanded: true,
            onChanged: (String? newValue) {
              setState(() {
                // Perbarui state dropdown jika diperlukan
              });
            },
            items: <String>[
              'Roda 2',
              'Roda 4',
              'Roda 6',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(value),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
