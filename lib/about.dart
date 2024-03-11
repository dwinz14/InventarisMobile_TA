import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:get/get.dart';
import 'authAPI.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  int _pageIndex = 3; // Sesuaikan dengan index halaman about

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 24.0,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Inventaris App',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Center(
              child: Text(
                'Aplikasi Sistem Informasi Inventaris',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Center(
              child: Text(
                'Versi: 6.6.6',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Center(
              child: Text(
                'Pengembang: Dowin, Jud, Sul, Ded',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
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
            if (index == 0) {
              // Navigate to dashboard
              Get.toNamed('/dashboard');
            } else if (index == 1) {
              // Navigate to transaksi
              Get.toNamed('/transaksi');
            } else if (index == 2) {
              // Navigate to transaksi_keluar
              Get.toNamed('/transaksi_keluar');
            } else if (index == 3) {
              // Do nothing, already on the about page
            }
          });
        },
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 18.0),
          child: ElevatedButton(
            onPressed: () {
              AuthAPI.logout().then((_) {
                Get.offAllNamed('/login');
              }).catchError((error) {
                print('Logout failed: $error');
              });
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 120.0, vertical: 16.0),
            ),
            child: Text(
              'Logout',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ),
      ),
    );
  }
}
