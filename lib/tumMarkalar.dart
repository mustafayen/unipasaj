import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unipasaj/widgets/home/home_card.dart';
import 'package:unipasaj/widgets/marka_image.dart';
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

  //late List<Marka> favoriMarkalar = [];
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


  void addFavoriListToFirestore(String userId, int id) async {
    if (userId.isNotEmpty) {
      // Firestore'dan markaları almak için bir işlev çağırılıyor
      List<Marka> markalarFromFirestore = await fetchMarkalarFromFirestore();

      // Markalar listesinde istenilen markayı bulmak için döngü kullanılıyor
      for (int i = 0; i < markalarFromFirestore.length; i++) {
        if (markalarFromFirestore[i].id == id) {
          // Eklenen markanın sadece id'sini alıyoruz
          int eklenenMarkaId = markalarFromFirestore[i].id;

          // Firebase Firestore'a marka id'sini eklemek için kullanılan kod
          await FirebaseFirestore.instance.collection('users').doc(userId).update({
            'favoriler': FieldValue.arrayUnion([eklenenMarkaId])
          });
          print('Marka favorilere eklendi: $eklenenMarkaId');
          return; // İstenilen marka bulunduğunda işlemi sonlandır
        }
      }
      // İstenilen marka bulunamadığında hata mesajı yazdır
      print('Marka bulunamadı: $id');
    } else {
      print('Kullanıcı kimliği boş olamaz');
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
            MarkaHikaye(markaList: markaList),
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
      Colors.black,
      (userId, id) {
        addFavoriListToFirestore(userId, id);
      },
    );
  }
}

class MarkaHikaye extends StatelessWidget {
  const MarkaHikaye({
    super.key,
    required this.markaList,
  });

  final List<Marka> markaList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        itemCount: markaList.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            child: SizedBox(
              width: 60,
              child: MarkaImage(
                marka: markaList[index],
                isCircular: true,
                future: getImageUrl(markaList[index].imagePath),
              ),
            ),
          );
        },
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
