import 'package:flutter/material.dart';
import 'package:form_validation/controller/product_controller.dart';
import 'package:form_validation/screens/product_detail_page.dart';
import 'package:get/get.dart';

class NewArrivalsTab extends StatefulWidget {
  const NewArrivalsTab({super.key});

  @override
  State<NewArrivalsTab> createState() => _NewArrivalsTabState();
}

class _NewArrivalsTabState extends State<NewArrivalsTab> {
  final ProductController _productController=Get.find();
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    _productController.fetchNewArrivals();
  });}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Arrivals'),),
      body: Obx((){
        if (_productController.isLoading.value){
          return Center(child: CircularProgressIndicator());
        }
        else if(_productController.newArrivalProductList.isEmpty){
          return Center(child: Text('Failed to load Products'),);
        }
        else{
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              itemCount: _productController.newArrivalProductList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 items per row
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3 / 3, // Adjust height/width
              ),
              itemBuilder: (context, index) {
                final product = _productController.newArrivalProductList[index];
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
