import 'package:coffee_appv2/models/favorite_item.dart';
import 'package:flutter/foundation.dart';

class FavoriteService {
  FavoriteService._();
  static final FavoriteService instance = FavoriteService._();

  /// ValueNotifier holding the current list of favorite items
  final ValueNotifier<List<FavoriteItem>> favoritesNotifier =
      ValueNotifier<List<FavoriteItem>>([]);

  List<FavoriteItem> get items => favoritesNotifier.value;

  /// Check if an item is favorited by title
  bool isFavorite(String title) {
    return favoritesNotifier.value.any((item) => item.title == title);
  }

  /// Toggle favorite status. Returns true if added, false if removed.
  bool toggleFavorite({
    required String title,
    required String imgurl,
    required String subtitle,
    required String price,
    String rating = "4.8",
  }) {
    final currentList = List<FavoriteItem>.from(favoritesNotifier.value);
    final existingIndex = currentList.indexWhere((item) => item.title == title);

    if (existingIndex != -1) {
      currentList.removeAt(existingIndex);
      favoritesNotifier.value = currentList;
      return false; // Removed
    } else {
      currentList.add(
        FavoriteItem(
          title: title,
          imgurl: imgurl,
          subtitle: subtitle,
          price: price,
          rating: rating,
        ),
      );
      favoritesNotifier.value = currentList;
      return true; // Added
    }
  }

  /// Remove item from favorites
  void removeFavorite(String title) {
    final currentList = List<FavoriteItem>.from(favoritesNotifier.value);
    currentList.removeWhere((item) => item.title == title);
    favoritesNotifier.value = currentList;
  }
}
