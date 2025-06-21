import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:form_validation/controller/offerimg_controller.dart';
import 'package:form_validation/widgets/foryou_widget.dart';
import 'package:get/get.dart';
import '../../../controller/product_controller.dart';
import '../../../widgets/horizontal_deals_scroller.dart';
import '../../product_detail_page.dart';

class ExplorenowTab extends StatelessWidget {
  const ExplorenowTab({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.put(ProductController());

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText(
                      'Spotlight Deals...',
                      textStyle: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrangeAccent,
                      ),
                      speed: const Duration(milliseconds: 200),
                    ),
                  ],
                  repeatForever: true,
                ),
              ),
              const Icon(Icons.local_fire_department, color: Colors.orange),
            ],
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: const HorizontalDealsScroller()),
          const SizedBox(height: 10),
          const ForyouWidget(),
          const SizedBox(height: 2),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimatedTextKit(
                  animatedTexts: [
                    ColorizeAnimatedText(
                      'Our Products...',
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      speed: const Duration(milliseconds: 100),
                      colors: [Colors.deepOrange, Colors.tealAccent, Colors.blue, Colors.red],
                    ),
                  ],
                  repeatForever: true,
                ),
                Row(
                  children: const [
                    Text(
                      'View more',
                      style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 15),
                    ),
                    SizedBox(width: 2),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 1),

          Obx(() {
            if (productController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (productController.productList.isEmpty) {
              return const Center(child: Text("No products available"));
            }

            return Container(
              margin: const EdgeInsets.only(left: 10,right: 10,bottom: 10,top: 5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange),
                borderRadius: BorderRadius.circular(12),
                gradient: const RadialGradient(
                  colors: [Colors.white, Colors.white60, Colors.white54],
                ),
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: productController.productList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 3 / 4,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemBuilder: (context, index) {
                  final product = productController.productList[index];
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetailPage(product: product))) ;
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.20),
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              child: Image.network(
                                product.productImages.isNotEmpty
                                    ? product.productImages.first
                                    : 'https://via.placeholder.com/150',
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              product.productName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
