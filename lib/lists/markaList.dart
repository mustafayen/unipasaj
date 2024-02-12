import 'package:cloud_firestore/cloud_firestore.dart';
import '../class/markaClass.dart';

List<Marka> allmarkaList = [
  // Firebase den gelen veri burayı dolduruyor
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