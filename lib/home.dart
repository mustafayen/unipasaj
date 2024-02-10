import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unipasaj/lists/markaList.dart';
import 'favoriMarkalar.dart';
import 'profil.dart';
import 'tumMarkalar.dart';

class MyHomePage extends StatefulWidget {
  final User user;
  MyHomePage({required this.user});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 1;
  late List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    fetchMarkalarFromFirestore().then((markalar) {
      setState(() {
        _pages = [
          ExploreTab(),
          TumMarkalar(markalar: markalar),
          AyarlarEkrani(user: widget.user),
        ];
      });
    });
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.isEmpty ? Center(child: CircularProgressIndicator()) : _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
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