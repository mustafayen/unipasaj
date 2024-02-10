import 'package:cloud_firestore/cloud_firestore.dart';

import '../class/markaClass.dart';

/*
List<Marka> allmarkaList = [
  Marka(
      1,
      "images/adidasReklam.jpg",
      "Adidas",
      "15",
      "adidas, spor giyim ve antrenman kıyafetlerinden daha fazlasıdır.",
      "01.01.2024",
      "images/adidas.png",
      "Giyim"),
  Marka(
      2,
      "images/appleReklam.jpeg",
      "Apple",
      "10",
      "Eğitime özel Apple fiyatları ile yeni bir Mac veya iPad satın alırken indirimden yararlanın.",
      "01.01.2024",
      "images/apple.png",
      "Teknoloji"),
  Marka(
      3,
      "images/dunyagoz.jpg",
      "Dünya Göz",
      "10",
      "Sınıflarda arkada oturuyorum göremiyorum diyen öğrencilere kontrollerde geçerli indirimler",
      "01.01.2024",
      "images/dunyagoz.jpg",
      "Sağlık"),
  Marka(
      4,
      "images/nike.png",
      "Nike",
      "20",
      "Spor öğrencilere güzel, Spor NİKE ile güzel",
      "01.01.2024",
      "images/nike.png",
      "Giyim"),
  Marka(
      5,
      "images/macfit.jpg",
      "Mac Fit",
      "20",
      "Finallerde başarılı olmanın yolu dinç bir vücuttan geçer",
      "01.01.2024",
      "images/macfit.jpg",
      "Spor"),
  // Diğer markaları eklemeye devam edin
];
*/


List<Marka> allmarkaList = [

  // Diğer markaları eklemeye devam edin
];


Future<List<Marka>> fetchMarkalarFromFirestore() async {
  List<Marka> markalar = [];

  // Firestore veritabanı referansını alın
  CollectionReference markalarCollection = FirebaseFirestore.instance.collection('markalar');

  // Markalar koleksiyonundaki belgeleri alın
  QuerySnapshot querySnapshot = await markalarCollection.get();

  // Her belgeyi döngüye alarak Marka nesnelerini oluşturun
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

  return markalar;
}

// Firestore'dan verileri al ve allmarkaList'i güncelle
void updateAllMarkaListFromFirestore() async {
  List<Marka> markalarFromFirestore = await fetchMarkalarFromFirestore();
  // Firestore'dan gelen verilerle allmarkaList'i güncelle
  allmarkaList = markalarFromFirestore;
}

