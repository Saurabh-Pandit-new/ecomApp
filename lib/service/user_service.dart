import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:form_validation/model/user_model.dart';

class UserService {
  final CollectionReference _ref = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(UserModel user) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await _ref.doc(uid).set(user.toJson());
    } else {
      throw Exception('No user is currently logged in');
    }
  }

  Future<List<UserModel>> fetchUsers() async {
    final snapshot = await _ref.get();
    return snapshot.docs.map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<UserModel?> fetchUser(String userId) async {
    final doc = await _ref.doc(userId).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  Future<UserModel?> fetchCurrentUser() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      return fetchUser(uid);
    }
    return null;
  }

  Future<void> updateUserFields(String userId, Map<String, dynamic> data) async {
  try {
    await _ref.doc(userId).update(data);
  } catch (e) {
    throw Exception('Failed to update user fields: $e');
  }
}


Future<void> addToWishlist(String uid, String productId) async {
  await _ref.doc(uid).update({
    'wishlist': FieldValue.arrayUnion([productId]),
  });
}

Future<void> removeFromWishlist(String uid, String productId) async {
  await _ref.doc(uid).update({
    'wishlist': FieldValue.arrayRemove([productId]),
  });
}


}
