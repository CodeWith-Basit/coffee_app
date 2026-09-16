import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_appv2/models/cart_item.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Centralized Firestore service to manage separated user data
class FirestoreService {
  FirestoreService._();
  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Helper to get current user UID
  String? get currentUid => FirebaseAuth.instance.currentUser?.uid;

  /// Reference to users collection
  CollectionReference<Map<String, dynamic>> get _usersCol =>
      _firestore.collection('users');

  // ==========================================
  // 1. USER PROFILE MANAGEMENT
  // ==========================================

  /// Save or update user profile document in /users/{uid}
  Future<void> saveUserRecord(User user, {String? customName}) async {
    final docRef = _usersCol.doc(user.uid);
    final docSnap = await docRef.get();

    final data = <String, dynamic>{
      'uid': user.uid,
      'email': user.email ?? '',
      'displayName': (customName != null && customName.isNotEmpty)
          ? customName
          : (user.displayName ?? ''),
      'photoURL': user.photoURL ?? '',
      'lastActive': FieldValue.serverTimestamp(),
    };

    if (!docSnap.exists) {
      data['createdAt'] = FieldValue.serverTimestamp();
      await docRef.set(data);
    } else {
      await docRef.update(data);
    }
  }

  /// Stream of user document
  Stream<DocumentSnapshot<Map<String, dynamic>>>? getUserProfileStream() {
    final uid = currentUid;
    if (uid == null) return null;
    return _usersCol.doc(uid).snapshots();
  }

  // ==========================================
  // 2. USER FAVORITES (Isolated per user)
  // Path: /users/{uid}/favorites/{favoriteId}
  // ==========================================

  CollectionReference<Map<String, dynamic>>? get _userFavoritesCol {
    final uid = currentUid;
    if (uid == null) return null;
    return _usersCol.doc(uid).collection('favorites');
  }

  /// Stream user's favorites from cloud
  Stream<QuerySnapshot<Map<String, dynamic>>>? getFavoritesStream() {
    return _userFavoritesCol?.snapshots();
  }

  /// Toggle or save favorite to Firestore
  Future<void> toggleFavorite({
    required String title,
    required String imgurl,
    required String price,
    required String subtitle,
  }) async {
    final col = _userFavoritesCol;
    if (col == null) return;

    // Use sanitized title as document ID for easy matching
    final docId = title.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '_');
    final docRef = col.doc(docId);
    final doc = await docRef.get();

    if (doc.exists) {
      await docRef.delete();
    } else {
      await docRef.set({
        'title': title,
        'imgurl': imgurl,
        'price': price,
        'subtitle': subtitle,
        'addedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  /// Check if an item is favorite
  Future<bool> isFavorite(String title) async {
    final col = _userFavoritesCol;
    if (col == null) return false;
    final docId = title.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '_');
    final doc = await col.doc(docId).get();
    return doc.exists;
  }

  // ==========================================
  // 3. USER ORDERS (Isolated per user)
  // Path: /users/{uid}/orders/{orderId}
  // ==========================================

  CollectionReference<Map<String, dynamic>>? get _userOrdersCol {
    final uid = currentUid;
    if (uid == null) return null;
    return _usersCol.doc(uid).collection('orders');
  }

  /// Save placed order into this user's private order history
  Future<String> saveOrder({
    required List<CartItem> items,
    required double subtotal,
    required double totalAmount,
    required String deliveryMethod, // 'Delivery' or 'Store Pickup'
    required String address,
    required String paymentMethod,
    String? note,
  }) async {
    final col = _userOrdersCol;
    if (col == null) throw Exception("User must be logged in to place an order");

    final docRef = col.doc(); // Auto ID

    final itemsData = items
        .map((item) => {
              'title': item.title,
              'price': item.price,
              'quantity': item.quantity,
              'totalPrice': item.totalPrice,
              'imgurl': item.imgurl,
              'subtitle': item.subtitle,
            })
        .toList();

    await docRef.set({
      'orderId': docRef.id,
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'Preparing', // Preparing -> Out for Delivery -> Completed
      'items': itemsData,
      'itemCount': items.length,
      'subtotal': subtotal,
      'totalAmount': totalAmount,
      'deliveryMethod': deliveryMethod,
      'address': address,
      'paymentMethod': paymentMethod,
      'note': note ?? '',
    });

    return docRef.id;
  }

  /// Stream of user's orders
  Stream<QuerySnapshot<Map<String, dynamic>>>? getOrdersStream() {
    return _userOrdersCol?.orderBy('createdAt', descending: true).snapshots();
  }
}
