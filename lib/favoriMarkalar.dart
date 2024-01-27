import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'widgets/cards.dart';
import 'main.dart';

class ExploreTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Favorilerim',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Column(
                children: [
                  markaCard(
                      "images/adidasReklam.jpg",
                      "Adidas",
                      "15",
                      "adidas, spor giyim ve antrenman kıyafetlerinden daha fazlasıdır.",
                      "01.01.2024",
                      "images/adidas.png",
                      "Giyim",
                      context),
                  markaCard(
                      "images/appleReklam.jpeg",
                      "Apple",
                      "10",
                      "Eğitime özel Apple fiyatları ile yeni bir Mac veya iPad satın alırken indirimden yararlanın.",
                      "01.01.2024",
                      "images/apple.png",
                      "Teknoloji",
                      context),
                ],
              )
            ],
          ),
        ));
  }
}
