import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final ValueChanged<int> onTabSelected;

  CustomBottomNavigationBar({required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      items: [
        Icon(Icons.home, size: 30),
        Icon(Icons.search, size: 30),
        Icon(Icons.add, size: 30),
        Icon(Icons.favorite, size: 30),
        Icon(Icons.person, size: 30),
      ],
      onTap: (index) {
        // Handle navigation based on the selected index
        // For example:
        // if (index == 0) {
        //   Get.offAllNamed('/home');
        // } else if (index == 1) {
        //   Get.offAllNamed('/search');
        // } else if (index == 2) {
        //   Get.offAllNamed('/add');
        // } else if (index == 3) {
        //   Get.offAllNamed('/favorite');
        // } else if (index == 4) {
        //   Get.offAllNamed('/profile');
        // }
      },
      height: 50,
      index: 0,
      color: Colors.blue,
      buttonBackgroundColor: Colors.blue,
      backgroundColor: Colors.white,
      animationCurve: Curves.easeInOut,
      animationDuration: Duration(milliseconds: 600),
    );
  }
}
