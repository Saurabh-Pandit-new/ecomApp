// lib/screens/categories_tab.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:form_validation/controller/category_controller.dart';
import 'package:form_validation/screens/subCategories_page.dart';

class CategoriesTab extends StatelessWidget {
  CategoriesTab({super.key});
  final CategoryController _categoryController = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_categoryController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (_categoryController.categories.isEmpty) {
        return const Center(child: Text('No categories found'));
      }

      return GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: _categoryController.categories.length,
        itemBuilder: (context, index) {
          final category = _categoryController.categories[index];

          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            elevation: 3,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubcategoriesPage(
                      categoryId: category['id'],
                      categoryName: category['name'],
                    ),
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (category['imageUrl'].isNotEmpty)
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(category['imageUrl']),
                    ),
                  const SizedBox(height: 10),
                  Text(
                    category['name'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
