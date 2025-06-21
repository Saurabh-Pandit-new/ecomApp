import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/product_model.dart';

class ProductController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<ProductModel> productList = <ProductModel>[].obs;
  RxList<ProductModel> filteredProductList = <ProductModel>[].obs;
  RxList<ProductModel> newArrivalProductList = <ProductModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    fetchAllProducts();
  }

  void fetchAllProducts() async {
    try {
      isLoading.value = true;

      final QuerySnapshot snapshot =
      await _firestore.collection('products').get();

      productList.value = snapshot.docs.map((doc) {
        return ProductModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print("Error fetching products: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void fetchByCategory(String categoryId) async {
    try {
      isLoading.value = true;

      final QuerySnapshot snapshot = await _firestore
          .collection('products')
          .where('subcategoryId', isEqualTo: categoryId)
          .get();

      filteredProductList.value = snapshot.docs.map((doc) {
        return ProductModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print("Error fetching category products: $e");
    } finally {
      isLoading.value = false;
    }
  }
  
  
  void fetchNewArrivals() async{
    try {
      isLoading.value=true;
      
      final QuerySnapshot snapshot= await _firestore
      .collection('products')
      .where('isNewArrival', isEqualTo: true)
      .get();

      newArrivalProductList.value = snapshot.docs.map((doc) {
        return ProductModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    }catch(e){
      print("Error fetching category products: $e");

    }finally{
      isLoading.value=false;
    }
  }

  Future<List<ProductModel>> fetchProductsByIds(List<dynamic> productIds) async {
  if (productIds.isEmpty) return [];

  final snapshot = await _firestore
      .collection('products')
      .where(FieldPath.documentId, whereIn: productIds)
      .get();

  return snapshot.docs.map((doc) => ProductModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
}
}


