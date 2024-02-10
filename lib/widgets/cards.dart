import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'paddings.dart';

Card markaCard(String imageurl, String marka, String indirim, String bilgi,
    String tarih, String logoUrl, String kategori, context) {
  bool isFavorited = false;
  Icon favIcon = Icon(Icons.favorite_border, color: Colors.black);
  return Card(
    child: Container(
      child: Center(
          child: Column(children: [
        verticalPaddingTen(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipOval(
              child: Container(
                width: 50, // Çemberin çapı
                height: 50, // Çemberin çapı
                color: Colors.blue, // Çember rengi
                child: Center(
                  child: Image.asset(
                    logoUrl, // Kullanmak istediğiniz profil resminin yolunu belirtin.
                    width: 50, // Resmin genişliği
                    height: 50, // Resmin yüksekliği
                    fit: BoxFit
                        .fill, // Resmi çember içine sığdırmak için kullanılan özellik
                  ),
                ),
              ),
            ),
            verhorPadding(),
            Text(
              marka,
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            IconButton(
              icon: isFavorited
                  // ignore: dead_code
                  ? Icon(Icons.favorite, color: Colors.red)
                  : Icon(Icons.favorite_border, color: Colors.black),
              onPressed: () {
                isFavorited = !isFavorited;
              },
            ),
          ],
        ),
        verhorPadding(),
        Text(
          bilgi,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        verticalPaddingTen(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: <Widget>[
                Icon(
                  Icons.percent,
                  color: Colors.black,
                ),
                SizedBox(
                    width:
                        8.0), // İkinci öğe ile aralarında boşluk bırakmak için SizedBox ekleyebilirsiniz.
                Text(
                  indirim, // Metin içeriği
                  style: TextStyle(
                    fontSize: 16.0, // Metin boyutu
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Icon(
                  Icons.tag,
                  color: Colors.black,
                ),
                SizedBox(
                    width:
                        8.0), // İkinci öğe ile aralarında boşluk bırakmak için SizedBox ekleyebilirsiniz.
                Text(
                  kategori, // Metin içeriği
                  style: TextStyle(
                    fontSize: 16.0, // Metin boyutu
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Icon(
                  Icons.date_range,
                  color: Colors.black,
                ),
                SizedBox(
                    width:
                        8.0), // İkinci öğe ile aralarında boşluk bırakmak için SizedBox ekleyebilirsiniz.
                Text(
                  tarih, // Metin içeriği
                  style: TextStyle(
                    fontSize: 16.0, // Metin boyutu
                  ),
                ),
              ],
            ),
          ],
        ),
        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        SizedBox(
          child: Image.asset(
            imageurl,
            width: double.infinity,
          ),
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black, // Burada renk değiştirebilirsiniz
            ),
            onPressed: () {
              print("object");
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          //QrImage(
                            //data: "OZKOC10",
                            //version: QrVersions.auto,
                            //size: 200.0,
                          //),
                          SizedBox(height: 20),
                          Text("Yukarıdaki QR Kodu Tarat"),
                        ],

                      ),
                    ),
                  );
                },
              );
            },
            child: Text('Kupon Kodu Al'))
      ])),
    ),
  );
}
