import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CatService extends ChangeNotifier {
  List<String> catImages = [];
  List<String> favoriteCatImage = [];
  SharedPreferences prefs;

  CatService(this.prefs) {
    loadFavoriteCatImages();
    getRandomCatImages();
  }

  void getRandomCatImages() async {
    String path =
        "https://api.thecatapi.com/v1/images/search?limit=10&mime_types=jpg";
    var result = await Dio().get(path);
    for (int i = 0; i < result.data.length; i++) {
      var map = result.data[i];
      catImages.add(map['url']);
    }
    notifyListeners();
  }

  void toggleFavoriteImage(String catImage) {
    if (favoriteCatImage.contains(catImage)) {
      favoriteCatImage.remove(catImage);
    } else {
      favoriteCatImage.add(catImage);
    }
    saveFavoriteCatImages();
    notifyListeners();
  }

  void saveFavoriteCatImages() {
    prefs.setStringList('favoriteCatImages', favoriteCatImage);
  }

  void loadFavoriteCatImages() {
    favoriteCatImage = prefs.getStringList('favoriteCatImages') ?? [];
    notifyListeners();
  }
}
