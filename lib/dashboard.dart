import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'authAPI.dart';

class BarangDetail {
  final String namaBarang;
  final int merekId;
  final int kategoriId;
  final String keterangan;
  final int stok;

  BarangDetail({
    required this.namaBarang,
    required this.merekId,
    required this.kategoriId,
    required this.keterangan,
    required this.stok,
  });
}

class DashboardScreen extends StatefulWidget {
  final String token;

  DashboardScreen({required this.token});
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _pageIndex = 0;
  late Future<List<Barang>> daftarBarang;

  @override
  void initState() {
    super.initState();
    daftarBarang = AuthAPI().getDaftarBarang();
  }

  Future<void> _refresh() async {
    setState(() {
      daftarBarang = AuthAPI().getDaftarBarang();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 24.0,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: FutureBuilder(
            future: daftarBarang,
            builder: (context, AsyncSnapshot<List<Barang>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Tidak ada data barang'));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        _showBarangDetail(snapshot.data![index]);
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        color: _getColorBasedOnStok(snapshot.data![index].stok),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data![index].namaBarang,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                'Stok: ${snapshot.data![index].stok}',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return CurvedNavigationBar(
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
    );
  }

  Color _getColorBasedOnStok(int stok) {
    if (stok > 10) {
      return Colors.indigoAccent; // Warna hijau jika stok mencukupi
    } else {
      return Colors.red; // Warna merah jika stok habis
    }
  }

  void _showBarangDetail(Barang barang) {
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                barang.namaBarang,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 30.0),
              Text(
                'Keterangan: ${barang.keterangan}',
                style: TextStyle(color: Colors.black87),
              ),
              Text(
                'Stok: ${barang.stok}',
                style: TextStyle(color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
