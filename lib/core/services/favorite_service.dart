import 'package:coffee_appv2/core/services/firestore_service.dart';
import 'package:coffee_appv2/models/favorite_item.dart';
import 'package:flutter/foundation.dart';

class FavoriteService {
  FavoriteService._() {
    _initCloudListener();
  }
  static final FavoriteService instance = FavoriteService._();

  /// ValueNotifier holding the current list of favorite items
  final ValueNotifier<List<FavoriteItem>> favoritesNotifier =
      ValueNotifier<List<FavoriteItem>>([]);

  List<FavoriteItem> get items => favoritesNotifier.value;

  /// Listen to user's private favorites subcollection in Firestore
  void _initCloudListener() {
    FirestoreService.instance.getFavoritesStream()?.listen((snapshot) {
      final cloudItems = snapshot.docs.map((doc) {
        final data = doc.data();
        return FavoriteItem(
          title: data['title'] as String? ?? doc.id,
          imgurl: data['imgurl'] as String? ?? '',
          subtitle: data['subtitle'] as String? ?? '',
          price: data['price'] as String? ?? '0.00',
        );
      }).toList();
      favoritesNotifier.value = cloudItems;
    });
  }

  /// Reload favorites when user logs in
  void reloadForCurrentUser() {
    _initCloudListener();
  }

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

    // Sync to Firestore in user's isolated subcollection
    FirestoreService.instance.toggleFavorite(
      title: title,
      imgurl: imgurl,
      price: price,
      subtitle: subtitle,
    );

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

    FirestoreService.instance.toggleFavorite(
      title: title,
      imgurl: '',
      price: '',
      subtitle: '',
    );
  }
}
