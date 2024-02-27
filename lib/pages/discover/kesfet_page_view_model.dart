import 'package:flutter/material.dart';
import 'package:unipasaj/pages/discover/models/discover_category.dart';

class KesfetPageViewModel extends ChangeNotifier {
  //TODO: Kategoriler remote'dan gelecek
  List<DiscoverCategory> fakeCategories = [
    DiscoverCategory(name: "Moda", imageUrl: "https://picsum.photos/200/200"),
    DiscoverCategory(
        name: "Fitness", imageUrl: "https://picsum.photos/200/200"),
    DiscoverCategory(
        name: "Yaşam Tarzı", imageUrl: "https://picsum.photos/200/200"),
    DiscoverCategory(name: "Makyaj", imageUrl: "https://picsum.photos/200/200"),
    DiscoverCategory(
        name: "Teknoloji", imageUrl: "https://picsum.photos/200/200"),
  ];

  List<DiscoverCategory> categories = [];

  bool isLoading = false;

  Future<List<DiscoverCategory>> getCategories({String? searchParams}) async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));
    var elements = fakeCategories.where((element) {
      if (searchParams == null) {
        return true;
      }
      return element.name.toLowerCase().contains(searchParams.toLowerCase());
    }).toList();
    categories = elements;
    isLoading = false;
    notifyListeners();
    return elements;
  }
}
