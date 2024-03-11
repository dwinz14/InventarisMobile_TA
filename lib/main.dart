import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaris/about.dart';
import 'package:inventaris/profil.dart';
import 'package:inventaris/transaksi.dart';
import 'login_screen.dart';
import 'dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'transaksi_keluar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventaris App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: _checkLoginStatus(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == true) {
              return FutureBuilder(
                // Load token from SharedPreferences
                future: _getTokenFromSharedPreferences(),
                builder: (context, AsyncSnapshot<String?> tokenSnapshot) {
                  if (tokenSnapshot.connectionState == ConnectionState.done) {
                    String? token = tokenSnapshot.data;
                    return DashboardScreen(
                      token: token ?? '',
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              );
            } else {
              return LoginScreen();
            }
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
      getPages: [
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/transaksi', page: () => TransaksiPage()),
        GetPage(name: '/transaksi_keluar', page: () => TransaksiKeluarScreen()),
        GetPage(name: '/about', page: () => AboutScreen()),
        GetPage(name: '/profil', page: () => ProfilScreen(token: '')),
        GetPage(name: '/dashboard', page: () => DashboardScreen(token: '')),
      ],
    );
  }

  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return token != null;
  }

  Future<String?> _getTokenFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
