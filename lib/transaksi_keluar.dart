import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:get/get.dart';
import 'authAPI.dart';

class TransaksiKeluarScreen extends StatefulWidget {
  @override
  _TransaksiKeluarScreenState createState() => _TransaksiKeluarScreenState();
}

class _TransaksiKeluarScreenState extends State<TransaksiKeluarScreen> {
  int _pageIndex = 2; // Sesuaikan dengan index halaman transaksi keluar
  TextEditingController tanggalController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String selectedBarang = '-- Pilih Barang --';
  TextEditingController jumlahController = TextEditingController();
  TextEditingController keteranganController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Barang Keluar',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 24.0,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        InkWell(
                          onTap: () {
                            _selectDate(context);
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Tanggal',
                              icon: Icon(Icons.calendar_today),
                            ),
                            child: Text(
                              "${selectedDate.toLocal()}".split(' ')[0],
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        FutureBuilder<List<Barang>>(
                          future: AuthAPI().getDaftarBarang(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Text('Tidak ada data barang keluar');
                            } else {
                              return DropdownButtonFormField<String>(
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedBarang =
                                        value ?? '-- Pilih Barang --';
                                  });
                                },
                                value: selectedBarang,
                                items: [
                                  DropdownMenuItem<String>(
                                    value: '-- Pilih Barang --',
                                    child: Text('-- Pilih Barang --'),
                                  ),
                                  for (var barang in snapshot.data!)
                                    DropdownMenuItem<String>(
                                      value: barang.id.toString(),
                                      child: Text('${barang.namaBarang}'),
                                    ),
                                ],
                                decoration: InputDecoration(
                                  labelText: 'Pilih Barang',
                                  hintText: 'Pilih barang yang keluar',
                                  icon: Icon(Icons.shopping_cart),
                                  border: OutlineInputBorder(),
                                ),
                              );
                            }
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: jumlahController,
                          decoration: InputDecoration(
                            labelText: 'Jumlah',
                            icon: Icon(Icons.format_list_numbered),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: keteranganController,
                          decoration: InputDecoration(
                            labelText: 'Keterangan',
                            icon: Icon(Icons.description),
                          ),
                          maxLines: 5,
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // handle cancel button press
                              },
                              child: Text('Batal'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // handle submit button press
                                AuthAPI()
                                    .storeBarangKeluar(
                                  selectedBarang,
                                  "${selectedDate.toLocal()}".split(' ')[0],
                                  jumlahController.text,
                                  keteranganController.text,
                                )
                                    .then((response) {
                                  // handle the response
                                  if (response['message'] ==
                                      'Data berhasil ditambahkan') {
                                    // show success message
                                    showSnackBar(
                                        'Success',
                                        'Data berhasil ditambahkan',
                                        Colors.green);
                                  } else {
                                    // show error message
                                    showSnackBar(
                                        'Error',
                                        'Gagal menambahkan data: ${response['message']}',
                                        Colors.red);
                                  }
                                }).catchError((error) {
                                  // handle error
                                  showSnackBar('Error',
                                      'Terjadi kesalahan: $error', Colors.red);
                                });
                              },
                              child: Text('Tambah'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _pageIndex,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.add_shopping_cart_rounded, size: 40),
          Icon(Icons.remove_shopping_cart_rounded, size: 40),
          Icon(Icons.info_outline, size: 30),
        ],
        color: Color.fromARGB(255, 167, 201, 252),
        buttonBackgroundColor: Colors.blue[50],
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _pageIndex = index;
            // handle bottom navigation tap
            if (index == 0) {
              Get.toNamed('/dashboard');
            } else if (index == 1) {
              Get.toNamed('/transaksi');
            } else if (index == 2) {
              Get.toNamed('/transaksi_keluar');
            } else if (index == 3) {
              Get.toNamed('/about');
            }
          });
        },
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        tanggalController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
  }

  void showSnackBar(String title, String message, Color color) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: color,
      colorText: Colors.white,
    );
  }
}
