import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'category_products.dart';

class SubcategoriesPage extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const SubcategoriesPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<SubcategoriesPage> createState() => _SubcategoriesPageState();
}

class _SubcategoriesPageState extends State<SubcategoriesPage> {
  List<Map<String, dynamic>> subcategories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    fetchSubcategories();});
  }

  Future<void> fetchSubcategories() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('subcategories')
          .where('categoryId', isEqualTo: widget.categoryId)
          .get();

      final data = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['name'] ?? 'No name',
          'imageUrl': doc['imageUrl'] ?? '',
        };
      }).toList();

      setState(() {
        subcategories = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching subcategories: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.categoryName} Subcategories')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : subcategories.isEmpty
          ? const Center(child: Text('No subcategories found'))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: subcategories.length,
        itemBuilder: (context, index) {
          final sub = subcategories[index];
          return Card(
            child: ListTile(
              leading: sub['imageUrl'].isNotEmpty
                  ? CircleAvatar(
                backgroundImage: NetworkImage(sub['imageUrl']),
              )
                  : const Icon(Icons.category),
              title: Text(sub['name']),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>CategoryProducts(subCategoryId: sub['id'],subCategoryName: sub['name'],)));
              },
            ),
          );
        },
      ),
    );
  }
}
