import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'paddings.dart';
import 'package:firebase_auth/firebase_auth.dart';

// FirebaseAuth nesnesini oluşturun
final FirebaseAuth _auth = FirebaseAuth.instance;

// FirebaseAuth kullanarak mevcut kullanıcıyı alın
final User? user = _auth.currentUser;

// Mevcut kullanıcının UID'sini alın
final String? userId = user?.uid;

Card markaCard(
    String imageurl,
    String marka,
    String indirim,
    String bilgi,
    String tarih,
    String logoUrl,
    String kategori,
    int id,
    Color mycolor,
    context,
    Function(String, int) addFavoriFunction, // Yeni parametre
    ) {
  bool isFavorited = false;
  Icon favIcon = Icon(Icons.favorite_border, color: Colors.black);
  return Card(
    child: Container(
      child: Center(
        child: Column(
          children: [
            verticalPaddingTen(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipOval(
                  child: Container(
                    width: 50,
                    height: 50,
                    color: Colors.blue,
                    child: Center(
                      child: Image.asset(
                        logoUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.fill,
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
                  icon: Icon(Icons.favorite, color: mycolor),
                  onPressed: () {
                    // IconButton'a tıklandığında favori ekleme fonksiyonunu çağır
                    addFavoriFunction(userId!, id); // Yeni fonksiyon kullanımı
                  },
                ),
                Text(id.toString()),
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
                    SizedBox(width: 8.0),
                    Text(
                      indirim,
                      style: TextStyle(
                        fontSize: 16.0,
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
                    SizedBox(width: 8.0),
                    Text(
                      kategori,
                      style: TextStyle(
                        fontSize: 16.0,
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
                    SizedBox(width: 8.0),
                    Text(
                      tarih,
                      style: TextStyle(
                        fontSize: 16.0,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () {
                    print("Kupon Kodu Al");
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                // Buraya QR kodu widget'i eklenebilir
                                SizedBox(height: 20),
                                Text("Yukarıdaki QR Kodu Tarat"),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Text('Kupon Kodu Al'),
                ),
                IconButton(
                  onPressed: () {
                    // Harita butonunun işlevselliği buraya gelecek
                  },
                  icon: Icon(Icons.map),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
