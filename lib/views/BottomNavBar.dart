import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_praktikum/views/HomeNews.dart';

import 'NewsCategories.dart';
import 'ProfilePage.dart';

class BottomNavBar extends StatefulWidget {

  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: Colors.blue,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.category,
            color: Colors.blue,
          ),
          label: 'Kategori',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
            color: Colors.blue,
          ),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeNews()),
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsCategories(),
            ),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Profile()),
          );
        }
      },
    );
  }
}