import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:form_validation/model/cart_model.dart';

class CartService {
  final CollectionReference _ref = FirebaseFirestore.instance.collection('carts');

  /// Adds a new item or increases quantity if it already exists
  Future<void> addToCart(CartModel cartItem) async {
    try {
      final querySnapshot = await _ref
          .where('userId', isEqualTo: cartItem.userId)
          .where('productId', isEqualTo: cartItem.productId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final existingDoc = querySnapshot.docs.first;
        final existingData = existingDoc.data() as Map<String, dynamic>;
        final existingQuantity = existingData['quantity'] ?? 1;

        await _ref.doc(existingDoc.id).update({
          'quantity': existingQuantity + cartItem.quantity,
        });
      } else {
        final docRef = _ref.doc();
        final cartWithId = CartModel(
          cartId: docRef.id,
          userId: cartItem.userId,
          productId: cartItem.productId,
          quantity: cartItem.quantity,
        );
        await docRef.set(cartWithId.toJson());
      }
    } catch (e) {
      print('Error in addToCart: $e');
    }
  }

  Future<void> updateQuantity({
    required String userId,
    required String productId,
    required int newQuantity,
  }) async {
    try {
      final querySnapshot = await _ref
          .where('userId', isEqualTo: userId)
          .where('productId', isEqualTo: productId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs.first.id;
        await _ref.doc(docId).update({'quantity': newQuantity});
      }
    } catch (e) {
      print('Error in updateQuantity: $e');
    }
  }

  Future<List<CartModel>> fetchUserCarts(String userId) async {
    final querySnapshot = await _ref.where('userId', isEqualTo: userId).get();

    return querySnapshot.docs
        .map((doc) => CartModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> removeFromCart(String cartId) async {
    try {
      await _ref.doc(cartId).delete();
    } catch (e) {
      print('Error removing item from cart: $e');
      rethrow;
    }
  }
}
