import 'package:flutter/material.dart';
import 'package:form_validation/model/product_model.dart';
import 'package:form_validation/screens/product_detail_page.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import '../controller/product_controller.dart';

class CategoryProducts extends StatefulWidget {
  final String subCategoryId;
  final String subCategoryName;
  const CategoryProducts({super.key,required this.subCategoryId,required this.subCategoryName});

  @override
  State<CategoryProducts> createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
  final ProductController _productController=Get.find();
  @override
void initState() {
  super.initState();
   WidgetsBinding.instance.addPostFrameCallback((_) {
    _productController.fetchByCategory(widget.subCategoryId);
  });}



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('${widget.subCategoryName}')),
      body: Obx(() {
        if (_productController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (_productController.filteredProductList.isEmpty) {
          return const Center(child: Text("No products found"));
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              itemCount: _productController.filteredProductList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3 / 3,
              ),
              itemBuilder: (context, index) {
                final product = _productController.filteredProductList[index];
                return InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetailPage(product: product)));
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (product.productImages.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                product.productImages[0],
                                height: 100,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          const SizedBox(height: 8),
                          Text(
                            product.productName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text('${product.currency} ${product.price.toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      }),
    );

  }
}
