import 'package:flutter/material.dart';

import 'widgets/cards.dart';
import 'class/markaClass.dart';
import 'lists/markaList.dart';

class TumMarkalar extends StatefulWidget {
  @override
  _TumMarkalarState createState() => _TumMarkalarState();
}

class _TumMarkalarState extends State<TumMarkalar> {
  TextEditingController searchController = TextEditingController();
  List<Marka> markaList = allmarkaList;
  String searchText = "";
  Set<String> kategoriler = Set();

  // List<String> kategoriler = [];

  @override
  Widget build(BuildContext context) {
    for (Marka marka in allmarkaList) {
      kategoriler.add('Hepsi');
      kategoriler.add(marka.kategori);
    }

    //kategoriler = kategoriler.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('ÜNİPASAJ',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            )),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
              //showSearch(context: context, delegate: AramaDelegate());
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // TextField(
            //   controller: searchController,
            //   onChanged: (value) {
            //     setState(() {
            //       searchText = value;
            //     });
            //   },
            //   decoration: InputDecoration(labelText: 'Ara'),
            // ),Row(
            Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                      spacing: 8,
                      children: kategoriler.map((kategori) {
                        return FilterChip(
                          label: Text(kategori),
                          onSelected: (isSelected) {
                            setState(() {
                              if (isSelected) {
                                searchText = kategori;
                              } else {
                                searchText = "";
                              }
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Colors.black),
                          ),
                          backgroundColor: Colors.transparent,
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: markaList.where((marka) {
                if (searchText == "Hepsi" || searchText == "") {
                  return true; // Tüm kartları göster
                } else {
                  return marka.kategori
                      .toLowerCase()
                      .contains(searchText.toLowerCase());
                }
              }).map((marka) {
                return markaCard1(marka);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget markaCard1(Marka marka) {
    return markaCard(marka.imagePath, marka.name, marka.discount,
        marka.description, marka.date, marka.logoPath, marka.kategori, context);
  }
}
