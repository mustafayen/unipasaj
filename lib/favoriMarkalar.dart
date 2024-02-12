import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unipasaj/class/markaClass.dart';
import 'package:unipasaj/lists/markaList.dart';
import 'package:unipasaj/widgets/cards.dart';

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

  void addFavoriListToFirestore(String userId, int id) async {
    // Firestore'dan gelen verilerle markaları al
    List<Marka> markalarFromFirestore = await fetchMarkalarFromFirestore();
    List<Marka> allmarkaList = markalarFromFirestore;

    // Firestore kullanıcı favori markaları koleksiyon referansını alın
    CollectionReference userFavoriCollection = FirebaseFirestore.instance.collection('favori');

    // Marka zaten favorilere eklenmişse işlemi sonlandır
    if (isMarkaAlreadyFavorited(favoriMarkalar, id)) {
      print('Bu marka zaten favorilere eklenmiş.');
      return;
    }

    // Favorilere eklemek için marka verilerini bul
    Marka? markaToAdd;
    for (var marka in allmarkaList) {
      if (marka.id == id) {
        markaToAdd = marka;
        break;
      }
    }

    if (markaToAdd != null) {
      // Marka verilerini bir belgeye dönüştürün
      Map<String, dynamic> markaData = {
        'id': markaToAdd.id,
        'imagePath': markaToAdd.imagePath,
        'name': markaToAdd.name,
        'discount': markaToAdd.discount,
        'description': markaToAdd.description,
        'date': markaToAdd.date,
        'logoPath': markaToAdd.logoPath,
        'kategori': markaToAdd.kategori,
      };

      // Kullanıcının favori markaları koleksiyonuna yeni bir belge ekleyin
      userFavoriCollection.doc(userId).collection('favori_markalar').add(markaData)
          .then((value) {
        print("Marka başarıyla eklendi.");
      })
          .catchError((error) {
        print("Marka eklenirken hata oluştu: $error");
      });
    } else {
      print('Marka bulunamadı.');
    }
  }

  bool isMarkaAlreadyFavorited(List<Marka> favoriMarkalar, int id) {
    return favoriMarkalar.any((marka) => marka.id == id);
  }

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
              children: favoriMarkalar.map((marka) {
                return markaCard(
                  marka.imagePath,
                  marka.name,
                  marka.discount,
                  marka.description,
                  marka.date,
                  marka.logoPath,
                  marka.kategori,
                  marka.id,
                  context,
                      (userId, id) {
                    // Favori ekleme işlevini tanımla
                    addFavoriListToFirestore(userId, id);
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