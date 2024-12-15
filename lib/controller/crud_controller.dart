import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class Crud {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  addReport(String userId, String title, String desc) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('reports')
          .add({
        'title': title,
        'description': desc,
        'dateReported': FieldValue.serverTimestamp(),
      });
      log('Report added Successfully, thank you');
    } catch (e) {
      log('Error adding report: $e');
    }
  }

  Future<void> addToFav(String userId, String itemName, String itemDescription,
      String itemUrl) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .add({
        'movieName': itemName,
        'movieDescription': itemDescription,
        'itemUrl': itemUrl,
        'addedAt': FieldValue.serverTimestamp(),
      });
      log('Item added to wishlist');
    } catch (e) {
      log('Error adding item to wishlist: $e');
      rethrow;
    }
  }

  getFavorites(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return doc.data();
      }).toList();
    });
  }

  Future<void> removeFromFav(String userId, String itemId) async {
    try {
      log('Attempting to remove item from wishlist - User ID: $userId, Item ID: $itemId');

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .doc(itemId)
          .delete();
      log('Item removed from wishlist');
    } catch (e) {
      log('Error removing item from wishlist: $e');
      rethrow;
    }
  }
}
