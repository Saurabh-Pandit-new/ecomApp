import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryService {
  final _ref = FirebaseFirestore.instance.collection('categories');

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final snapshot = await _ref.get();
    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'name': doc['name'] ?? 'No name',
        'imageUrl': doc['imageUrl'] ?? '',
      };
    }).toList();
  }
}
