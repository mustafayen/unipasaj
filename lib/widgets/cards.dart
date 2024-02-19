import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'paddings.dart';
import 'package:firebase_auth/firebase_auth.dart';

String imagePath = 'ae.jpg';

// FirebaseAuth nesnesini oluşturun
final FirebaseAuth _auth = FirebaseAuth.instance;
// FirebaseAuth kullanarak mevcut kullanıcıyı alın
final User? user = _auth.currentUser;
// Mevcut kullanıcının UID'sini alın
final String? userId = user?.uid;

final String url = "https://maps.app.goo.gl/x5yjQvFWSPZuGvP29";
final Uri uri = Uri.parse(url);

Future<String> fetchNameFromFirestore(String userId) async {
  try {
    // Firestore kullanıcı koleksiyon referansını alın
    CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
    // Kullanıcının belgesini Firestore'dan al
    DocumentSnapshot userDoc = await userCollection.doc(userId).get();

    if (userDoc.exists) {
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

      if (userData != null) {
        String? name = userData['name'];
        String? surname = userData['surname'];

        if (name != null && surname != null) {
          String adSoyad = '$name $surname';
          return adSoyad;
        } else {
          print('Kullanıcı belgesinde ad veya soyad bulunamadı');
          return ''; // veya istediğiniz bir varsayılan değer
        }
      } else {
        print('Kullanıcı belgesi veri içermiyor');
        return ''; // veya istediğiniz bir varsayılan değer
      }
    } else {
      print('Kullanıcı belgesi bulunamadı');
      return ''; // veya istediğiniz bir varsayılan değer
    }
  } catch (e) {
    print("Kullanıcı bilgilerini çekerken hata oluştu: $e");
    return ''; // veya istediğiniz bir varsayılan değer
  }
}

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
            FutureBuilder<String>(
              future: getImageUrl(imageurl), // Resim URL'sini getir
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Veri yüklenene kadar bekleyen durum
                  return CircularProgressIndicator();
                } else {
                  if (snapshot.hasError) {
                    // Hata durumu
                    return Text('Resim yüklenirken bir hata oluştu: ${snapshot.error}');
                  } else {
                    // Veri başarıyla yüklendiği durum
                    return snapshot.data != null ? Image.network(snapshot.data!) : SizedBox(); // Resim mevcutsa göster, değilse boş bir SizedBox göster
                  }
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black54, // Arka plan rengi
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Kenar yarıçapı
                    ),
                    textStyle: TextStyle(
                      fontSize: 16, // Yazı tipi boyutu
                    ),
                  ),
                  onPressed: () {
                    print("Kupon Kodu Al");
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return FutureBuilder<String>(
                          future: fetchNameFromFirestore(userId!), // Firestore'dan diğer verileri getir
                          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              // Veri yüklenene kadar bekleyen durum
                              return Container(
                                height: MediaQuery.of(context).size.height * 0.5,
                                child: Center(
                                  child: CircularProgressIndicator(), // veya başka bir yükleme göstergesi
                                ),
                              );
                            } else {
                              if (snapshot.hasError) {
                                // Hata durumu
                                return Container(
                                  height: MediaQuery.of(context).size.height * 0.5,
                                  child: Center(
                                    child: Text('Veri yüklenirken bir hata oluştu: ${snapshot.error}'),
                                  ),
                                );
                              } else {
                                // Veri başarıyla yüklendiği durum
                                return Container(
                                  height: MediaQuery.of(context).size.height * 0.5,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        // Resmi göstermek için Image.network widget'ını kullanın
                                        SizedBox(height: 20),
                                        Text("İndirimi almak için telefonu görevliye gösterin."),
                                        FutureBuilder<String>(
                                          future: getImageUrl(imagePath), // Resim URL'sini getir
                                          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              // Veri yüklenene kadar bekleyen durum
                                              return CircularProgressIndicator();
                                            } else {
                                              if (snapshot.hasError) {
                                                // Hata durumu
                                                return Text('Resim yüklenirken bir hata oluştu: ${snapshot.error}');
                                              } else {
                                                // Veri başarıyla yüklendiği durum
                                                return snapshot.data != null ? Image.network(snapshot.data!) : SizedBox(); // Resim mevcutsa göster, değilse boş bir SizedBox göster
                                              }
                                            }
                                          },
                                        ),
                                        Text(user!.uid),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                        );
                      },
                    );
                  },

                  child: Text(
                    'Kupon Kodu Al',
                    style: TextStyle(color: Colors.white), // Yazı rengi
                  ),
                ),

                IconButton(
                  onPressed: () {
                    // Harita butonunun işlevselliği buraya gelecek
                    _launchURL(uri);
                  },
                  icon: Icon(Icons.location_on),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

void _launchURL(Uri url) async {
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<String> getImageUrl(String imagePath) async {
  try {
    // Firebase Storage referansını oluşturun
    Reference ref = FirebaseStorage.instance.ref(imagePath);

    // Resmin indirme URL'sini alın
    String imageUrl = await ref.getDownloadURL();

    // İndirme URL'sini döndürün
    return imageUrl;
  } catch (e) {
    // Hata durumunda bir hata mesajı döndürün
    print('Hata oluştu: $e');
    return Future.error('Resim yüklenirken bir hata oluştu: $e');
  }
}