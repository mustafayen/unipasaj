import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unipasaj/widgets/home/home_card.dart';
import 'widgets/cards.dart';
import 'class/markaClass.dart';
import 'lists/markaList.dart';

class TumMarkalar extends StatefulWidget {
  final List<Marka> markalar; // markalar isimli parametre eklendi
  TumMarkalar({required this.markalar}); // Yapılandırıcı metot güncellendi
  @override
  _TumMarkalarState createState() => _TumMarkalarState();
}

class _TumMarkalarState extends State<TumMarkalar> {
  TextEditingController searchController = TextEditingController();
  List<Marka> markaList = []; // markaList, widget.markalar ile güncellenecek
  String searchText = "";
  Set<String> kategoriler = Set();

  late List<Marka> favoriMarkalar = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? user;
  late String? userId;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    markaList = widget.markalar; // markaList, widget.markalar ile güncellendi
    for (Marka marka in widget.markalar) {
      kategoriler.add('Hepsi');
      kategoriler.add(marka.kategori);
    }
  }

  void fetchUserData() async {
    user = _auth.currentUser;
    if (user != null) {
      // Mevcut kullanıcının UID'sini al
      userId = user!.uid;
    }
  }

  Future<List<Marka>> fetchFavoriMarkalarFromFirestore(String userId) async {
    List<Marka> favoriMarkalar = [];

    try {
      // Firestore kullanıcı favori markaları koleksiyon referansını alın
      CollectionReference userFavoriCollection =
          FirebaseFirestore.instance.collection('favori');
      // Kullanıcının favori markalarını Firestore'dan al
      QuerySnapshot querySnapshot = await userFavoriCollection
          .doc(userId)
          .collection('favori_markalar')
          .get();
      // Her belgeyi döngüye alarak favori marka nesnelerini oluştur
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
        favoriMarkalar.add(marka);
      });

      return favoriMarkalar;
    } catch (e) {
      print("Favori markaları çekerken hata oluştu: $e");
      return favoriMarkalar;
    }
  }

  void addFavoriListToFirestore(String userId, int id) async {
    // Favori markaları Firestore'dan al
    List<Marka> favoriMarkalar = await fetchFavoriMarkalarFromFirestore(userId);
    // Firestore'dan gelen verilerle markaları al
    List<Marka> markalarFromFirestore = await fetchMarkalarFromFirestore();
    List<Marka> allmarkaList = markalarFromFirestore;
    // Firestore kullanıcı favori markaları koleksiyon referansını alın
    CollectionReference userFavoriCollection =
        FirebaseFirestore.instance.collection('favori');
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
      userFavoriCollection
          .doc(userId)
          .collection('favori_markalar')
          .add(markaData)
          .then((value) {
        print("Marka başarıyla eklendi.");
      }).catchError((error) {
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
    for (Marka marka in allmarkaList) {
      kategoriler.add('Hepsi');
      kategoriler.add(marka.kategori);
    }
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
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
    return HomeCard(
      marka.mapurl,
      marka.imagePath,
      marka.name,
      marka.discount,
      marka.description,
      marka.date,
      marka.logoPath,
      marka.kategori,
      marka.id,
      Colors.black,
      (userId, id) {
        addFavoriListToFirestore(userId, id);
      },
    );
  }
}
