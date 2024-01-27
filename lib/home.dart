import 'package:flutter/material.dart';

import 'favoriMarkalar.dart';
import 'profil.dart';
import 'tumMarkalar.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 1;

  // Define the pages or tabs for your app
  final List<Widget> _pages = [
    //HomeTab(),
    ExploreTab(),
    TumMarkalar(),
    AyarlarEkrani(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.school_outlined, color: Colors.black),
          //   label: 'Eğitim',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border, color: Colors.black),
            label: 'Favorilerim',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.all_inclusive, color: Colors.black),
            label: 'Tüm Markalar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, color: Colors.black),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
        showSelectedLabels: true, // Seçili öğenin labelını göster
        showUnselectedLabels: true, // Seçili olmayan öğelerin labelını göster
      ),
    );
  }
}
