import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unipasaj/class/markaClass.dart';
import 'package:unipasaj/tumMarkalar.dart';
import 'package:unipasaj/widgets/home/home_card.dart';

Future<List<int>> fetchFavoritesFromFirestore(String userId) async {
  try {
    // Get the Firestore user collection reference
    CollectionReference userCollection =
    FirebaseFirestore.instance.collection('users');
    // Get the user's document from Firestore
    DocumentSnapshot userDoc = await userCollection.doc(userId).get();
    if (userDoc.exists) {
      // Extract user data as a Map<String, dynamic>
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

      if (userData != null && userData.containsKey('favoriler')) {
        // Directly cast 'favoriler' field to List<int>
        List<int> favoritesList = List<int>.from(userData['favoriler']);
        return favoritesList;
      }
    }
    // Return an empty list if user data or 'favoriler' field are not found
    return [];
  } catch (e) {
    // Handle any errors that might occur during the process
    print("Error fetching favorites: $e");
    // You might want to handle the error or throw it for higher-level handling
    throw e;
  }
}

void removeFavoriListFromFirestore(String userId, int id) async {
  if (userId.isNotEmpty) {
    // Firestore'dan markaları almak için bir işlev çağırılıyor
    // Markalar listesinde istenilen markayı bulmak için döngü kullanılıyor
    for (int i = 0; i < favoriList.length; i++) {
      if (favoriList[i].id == id) {
        // Kaldırılacak markanın sadece id'sini alıyoruz
        int kaldirilanMarkaId = favoriList[i].id;
        favoriList.removeAt(i);

        // Firebase Firestore'dan marka id'sini kaldırmak için kullanılan kod
        await FirebaseFirestore.instance.collection('users').doc(userId).update({
          'favoriler': FieldValue.arrayRemove([kaldirilanMarkaId])
        });

        print('Marka favorilerden kaldırıldı: $kaldirilanMarkaId');
        return; // İstenilen marka bulunduğunda işlemi sonlandır
      }
    }
    // İstenilen marka bulunamadığında hata mesajı yazdır
    print('Marka bulunamadı: $id');
  } else {
    print('Kullanıcı kimliği boş olamaz');
  }
}

List<Marka> markaList = [];
List<Marka> favoriList = [];

class ExploreTab extends StatefulWidget {
  final List<Marka> markalar;
  ExploreTab({required this.markalar});
  @override
  _ExploreTabState createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {

  late List<Marka> favoriMarkalar = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? user;
  late String? userId;


  @override
  void initState() {
    super.initState();
    fetchUserData();
    markaList = widget.markalar;
  }

  void fetchUserData() async {
    user = _auth.currentUser;
    if (user != null) {
      // Mevcut kullanıcının UID'sini al
      userId = user!.uid;
      // Favori markaları Firestore'dan al
      //fetchFavoriMarkalarFromFirestore(userId!);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.transparent, // Opaklık 0 olarak ayarlandı
          ),
          onPressed: () {
            // Buraya ikonun tıklanma işlemlerini ekleyebilirsiniz
          },
        ),
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
            icon: Icon(Icons.search, color: Colors.transparent),
            onPressed: () {
              //showSearch(context: context, delegate: AramaDelegate());
            },
          ),
        ],
      ),
      body: FutureBuilder<List<int>>(
        future: fetchFavoritesFromFirestore(userId!),
        builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
          // Yükleme durumunu kontrol et
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // Favorilerin listesini al, eğer veri yoksa boş bir liste oluştur
          List<int> favorites = snapshot.data ?? [];

          // Favori markaları temizle
          favoriList.clear();

          // Favoriler listesindeki her bir markayı kontrol et
          for (Marka marka in markaList) {
            // Eğer markanın id'si favoriler listesinde varsa, favoriList'e ekle
            if (favorites.contains(marka.id)) {
              favoriList.add(marka);
            }
          }
          // Eğer favori marka bulunmazsa, hiçbir şey döndürme
          if (favoriList.isEmpty) {
            return SizedBox.shrink();
          }

          // Favori markalar bulunduğunda Column widget'ını döndür
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                MarkaHikaye(markaList: favoriList),
                Column(
                  children: favoriList.map((marka) {
                    return markaCard1(marka);
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  Widget markaCard1(Marka marka) {
    return HomeCard(
      marka,
      marka.mapurl,
      marka.imagePath,
      marka.name,
      marka.discount,
      marka.description,
      marka.date,
      marka.logoPath,
      marka.kategori,
      marka.id,
      Colors.red,
          (userId, id) {
        removeFavoriListFromFirestore(userId, id);
        setState(() {});
      },
    );
  }
}
