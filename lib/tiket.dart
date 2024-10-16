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
  List<Map<String, dynamic>> passengerData = [];
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
      passengerData.add({
        'name': '',
        'age': '',
        'address': '',
        'vehicleType': '',
        'vehiclePlate': ''
      });
      passengers.add(_buildPassengerContainer(passengerNumber));
    });
  }

  void _showDialog() {
    String allData = 'Tanggal: ${widget.date}\nTrip: ${widget.schedule}\n\n';
    
    for (int i = 0; i < passengerData.length; i++) {
      allData += 'Penumpang ${i + 1}:\n';
      allData += 'Nama: ${passengerData[i]['name']}\n';
      allData += 'Umur: ${passengerData[i]['age']}\n';
      allData += 'Alamat: ${passengerData[i]['address']}\n';
      allData += 'Jenis Kendaraan: ${passengerData[i]['vehicleType']}\n';
      allData += 'Plat Kendaraan: ${passengerData[i]['vehiclePlate']}\n\n';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Center(
            child: Text(
              'Data Tiket',
              style: TextStyle(
                color: Color(0xFF4BBAE9),
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.05,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Text(
              allData,
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Colors.black87,
              ),
            ),
          ),
          actions: <Widget>[
            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFF4BBAE9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                ),
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
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
            SizedBox(height: screenHeight * 0.02),
            Container(
              width: screenWidth * 0.90,
              height: screenHeight * 0.05,
              child: ElevatedButton(
                onPressed: _showDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4BBAE9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  padding: EdgeInsets.all(10),
                ),
                child: Text(
                  'Selesai',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.04,
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
            _buildInputField('Nama', 'Masukkan Nama Anda', screenWidth, passengerNumber, 'name'),
            _buildInputField('Umur', 'Masukkan Umur Anda', screenWidth, passengerNumber, 'age'),
            _buildInputField('Alamat', 'Masukkan Alamat Anda', screenWidth, passengerNumber, 'address'),
            _buildDropdownField(screenWidth, passengerNumber),
            _buildInputField('Plat Kendaraan (Opsional)', 'Masukkan Plat Kendaraan Anda', screenWidth, passengerNumber, 'vehiclePlate'),
            SizedBox(height: screenHeight * 0.01),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    passengers.removeAt(passengerNumber - 1);
                    passengerData.removeAt(passengerNumber - 1);
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

  Widget _buildInputField(String label, String hintText, double screenWidth, int passengerNumber, String fieldKey) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
        ),
        onChanged: (value) {
          setState(() {
            passengerData[passengerNumber - 1][fieldKey] = value;
          });
        },
      ),
    );
  }

Widget _buildDropdownField(double screenWidth, int passengerNumber) {
  return Column(
    children: [
      SizedBox(height: 5),
      Container(
        width: screenWidth * 0.85,
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 8), // Sesuaikan padding agar lebih rapi
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue), // Warna garis saat dropdown difokuskan
            ),
          ),
          isExpanded: true,
          value: passengerData[passengerNumber - 1]['vehicleType'].isEmpty
              ? null
              : passengerData[passengerNumber - 1]['vehicleType'],
          hint: Text(
            'Pilih Jenis Kendaraan (Opsional)',
            style: TextStyle(fontSize: screenWidth * 0.045,fontWeight: FontWeight.w400),
          ),
          items: <String>[
            'Motor',
            'Mobil',
            'Bus',
            'Truk',
            'Lainnya'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              passengerData[passengerNumber - 1]['vehicleType'] = value!;
            });
          },
        ),
      ),
      SizedBox(height: 10),
    ],
  );
}

}