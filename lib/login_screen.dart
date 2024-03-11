import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'authAPI.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void showSnackBar(String message) {
    Get.snackbar(
      'Login Failed',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  Future<void> login() async {
    try {
      final response =
          await AuthAPI.login(emailController.text, passwordController.text);

      print('Response from server: $response');

      if (response != null &&
          response['success'] == true &&
          response['data'] != null) {
        final String token = response['data']['token']['name'];

        // Simpan token di Shared Preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token);

        Get.offAllNamed('/dashboard', arguments: {'token': token});
      } else {
        showSnackBar('Invalid email or password');
        print('Login error: Invalid response format');
      }
    } catch (e) {
      showSnackBar('An error occurred while logging in');
      print('Login error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Inventaris App',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 50.0),
            Image.asset('assets/images/logo.png', height: 150.0),
            SizedBox(height: 24.0),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: login,
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
