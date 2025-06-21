import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:form_validation/model/cart_model.dart';
import 'package:form_validation/service/cart_service.dart';

class CartController extends GetxController {
  final CartService _cartService = CartService();

  RxList<CartModel> cartProducts = <CartModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      loadUserCart(uid);
    }
  }

  Future<void> loadUserCart(String userId) async {
    try {
      isLoading.value = true;
      final List<CartModel> items = await _cartService.fetchUserCarts(userId);
      cartProducts.assignAll(items);
    } catch (e) {
      print("Error loading cart: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void updateQuantityLocally(String productId, int newQuantity) {
    final index = cartProducts.indexWhere((item) => item.productId == productId);
    if (index != -1) {
      cartProducts[index] = cartProducts[index].copyWith(quantity: newQuantity);
      cartProducts.refresh();
    }
  }
}