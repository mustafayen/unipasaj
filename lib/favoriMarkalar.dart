import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unipasaj/class/markaClass.dart';
import 'package:unipasaj/tumMarkalar.dart';
import 'package:unipasaj/widgets/cards.dart';
import 'package:unipasaj/widgets/future_image.dart';
import 'package:unipasaj/widgets/home/home_card.dart';

class ExploreTab extends StatefulWidget {
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
  }

  void fetchUserData() async {
    user = _auth.currentUser;
    if (user != null) {
      // Mevcut kullanıcının UID'sini al
      userId = user!.uid;
      // Favori markaları Firestore'dan al
      fetchFavoriMarkalarFromFirestore(userId!);
    }
  }

  Future<void> fetchFavoriMarkalarFromFirestore(String userId) async {
    try {
      // Firestore kullanıcı favori markaları koleksiyon referansını al
      CollectionReference userFavoriCollection =
          FirebaseFirestore.instance.collection('favori');
      // Kullanıcının favori markalarını Firestore'dan al
      QuerySnapshot querySnapshot = await userFavoriCollection
          .doc(userId)
          .collection('favori_markalar')
          .get();
      // Her belgeyi döngüye alarak favori marka nesnelerini oluştur
      List<Marka> markalar = [];
      querySnapshot.docs.forEach((doc) {
        Marka marka = Marka(
          doc['mapurl'],
          doc['id'],
          doc['imagePath'],
          doc['name'],
          doc['discount'],
          doc['description'],
          doc['date'],
          doc['logoPath'],
          doc['kategori'],
        );
        markalar.add(marka);
      });
      // setState ile favori markalar listesini güncelle
      setState(() {
        favoriMarkalar = markalar;
      });
    } catch (e) {
      print("Favori markaları çekerken hata oluştu: $e");
      // Hata durumunda gerekli işlemleri yapabilirsiniz
    }
  }

  Future removeFavoriListFromFirestore(String userId, int id) async {
    try {
      // Firestore kullanıcı favori markaları koleksiyon referansını alın
      CollectionReference userFavoriCollection =
          FirebaseFirestore.instance.collection('favori');
      // Koleksiyondan markayı kaldır
      await userFavoriCollection
          .doc(userId)
          .collection('favori_markalar')
          .where('id', isEqualTo: id)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
          print("Marka favorilerden kaldırıldı.");
        });
      }).catchError((error) {
        print("Marka kaldırılırken hata oluştu: $error");
      });

      // Favori markalar listesinden markayı kaldır
      setState(() {
        favoriMarkalar.removeWhere((marka) => marka.id == id);
      });
    } catch (e) {
      print("Favori markaları kaldırırken hata oluştu: $e");
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
          onPressed: () {},
        ),
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
            MarkaHikaye(
              markaList: favoriMarkalar,
            ),
            Column(
              children: favoriMarkalar.map((marka) {
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
                    // Favori ekleme işlevini tanımla
                    removeFavoriListFromFirestore(userId, id);
                  },
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
