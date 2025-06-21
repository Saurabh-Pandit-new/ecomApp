import 'package:flutter/material.dart';
import 'package:form_validation/controller/category_controller.dart';
import 'package:form_validation/screens/subCategories_page.dart';
import 'package:get/get.dart';

class ForyouWidget extends StatefulWidget {
  const ForyouWidget({Key? key}) : super(key: key);

  @override
  _ForyouWidgetState createState() => _ForyouWidgetState();
}

class _ForyouWidgetState extends State<ForyouWidget> {
  final CategoryController _categoryController = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        const SizedBox(height: 2),
        SizedBox(
          height: 150,
          child: Obx(() {
            final categoryList = _categoryController.categories;
            if (_categoryController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (categoryList.isEmpty) {
              return const Center(child: Text('No categories found'));
            }

            final int itemCount = (categoryList.length / 2).ceil();

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: itemCount,
              itemBuilder: (context, index) {
                final first = categoryList[index * 2];
                final second = (index * 2 + 1 < categoryList.length)
                    ? categoryList[index * 2 + 1]
                    : null;

                return Column(
                  children: [
                    _buildCategoryCard(first),
                    const SizedBox(height: 10),
                    if (second != null) _buildCategoryCard(second),
                  ],
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return InkWell(
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
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            elevation: 5,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              width: 45,
              height: 45,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: category['imageUrl'] != null &&
                        category['imageUrl'].toString().isNotEmpty
                    ? Image.network(
                        category['imageUrl'],
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.category),
              ),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 60,
            child: Text(
              category['name'],
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
