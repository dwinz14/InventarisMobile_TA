import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'authAPI.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class ProfilScreen extends StatefulWidget {
  final String token;

  ProfilScreen({required this.token});

  @override
  _ProfilScreenState createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  Map<String, dynamic>? userInfo;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    try {
      final response = await AuthAPI.getUserInfo(widget.token);
      setState(() {
        userInfo = response['data']; // Sesuaikan dengan respons API Anda
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching user info: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> logout() async {
    try {
      await AuthAPI.logout();
      // Hapus token dari Shared Preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('token');
      Get.offAllNamed('/login');
    } catch (e) {
      print('Logout error: $e');
    }
  }

  int _pageIndex = 4; // Sesuaikan dengan index halaman profil

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            color: Colors.black,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userInfo != null
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome,',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        userInfo!['name'] ?? '',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Email:',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        userInfo!['email'] ?? '',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 24.0),
                      ElevatedButton(
                        onPressed: logout,
                        child: Text('Logout'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 32.0,
                            vertical: 16.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Text('Failed to fetch user info'),
      bottomNavigationBar: CurvedNavigationBar(
        index: _pageIndex,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.add_shopping_cart_rounded, size: 40),
          Icon(Icons.remove_shopping_cart_rounded, size: 40),
          Icon(Icons.account_circle_outlined, size: 30),
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
              // Do nothing, already on the profile page
            } else if (index == 4) {
              Get.toNamed('/about');
            }
          });
        },
      ),
    );
  }
}
