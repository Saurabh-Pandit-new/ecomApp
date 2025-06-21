import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_validation/controller/product_controller.dart';
import 'package:form_validation/screens/product_detail_page.dart';
import 'package:form_validation/service/cart_service.dart';
import 'package:get/get.dart';
import 'package:form_validation/controller/cart_controller.dart';
import 'package:form_validation/model/cart_model.dart';
import 'package:form_validation/model/product_model.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartController _cartController = Get.put(CartController());
  final ProductController _productController = Get.find<ProductController>();
  final CartService _cartService = CartService();

  RxList<ProductModel> cartProductsDetails = <ProductModel>[].obs;
  RxBool isProductLoading = false.obs;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _initializeCartData();
  }

  Future<void> _initializeCartData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await _cartController.loadUserCart(uid);
      await _loadCartProductsDetails();
    }
  }

  Future<void> _loadCartProductsDetails() async {
    isProductLoading.value = true;
    final ids = _cartController.cartProducts.map((c) => c.productId).toList();
    final products = await _productController.fetchProductsByIds(ids);
    cartProductsDetails.value = products;
    isProductLoading.value = false;
  }

  Future<void> _removeCartItem(String cartId) async {
    await _cartService.removeFromCart(cartId);
    await _initializeCartData();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item removed from cart')),
    );
  }

  Future<void> _updateQuantity(CartModel cart, int newQty) async {
    if (_isUpdating || newQty < 1) return;
    _isUpdating = true;

    await _cartService.updateQuantity(
      userId: cart.userId,
      productId: cart.productId,
      newQuantity: newQty,
    );

    _cartController.updateQuantityLocally(cart.productId, newQty);
    _isUpdating = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Obx(() {
        if (_cartController.isLoading.value || isProductLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_cartController.cartProducts.isEmpty) {
          return const Center(child: Text('Your cart is empty.'));
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _cartController.cartProducts.length,
                itemBuilder: (context, index) {
                  final cartItem = _cartController.cartProducts[index];
                  final product = cartProductsDetails.firstWhereOrNull(
                    (p) => p.productId == cartItem.productId,
                  );

                  if (product == null) return const SizedBox();

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailPage(product: product),
                        ),
                      );
                    },
                    child: Card(
                      key: ValueKey(cartItem.cartId),
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            product.productImages.isNotEmpty
                                ? product.productImages.first
                                : 'https://via.placeholder.com/150',
                          ),
                        ),
                        title: Text(product.productName,
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent),
                              onPressed: () {
                                if (cartItem.quantity > 1) {
                                  _updateQuantity(cartItem, cartItem.quantity - 1);
                                }
                              },
                            ),
                            Text(cartItem.quantity.toString(),
                                style: const TextStyle(fontSize: 16)),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                              onPressed: () {
                                _updateQuantity(cartItem, cartItem.quantity + 1);
                              },
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '₹${(product.discountPrice * cartItem.quantity).toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _removeCartItem(cartItem.cartId);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom Total Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 6,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() {
                    double total = 0;
                    for (var cart in _cartController.cartProducts) {
                      final product = cartProductsDetails.firstWhereOrNull(
                          (p) => p.productId == cart.productId);
                      if (product != null) {
                        total += product.discountPrice * cart.quantity;
                      }
                    }
                    return Text(
                      'Total: ₹${total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    );
                  }),
                  ElevatedButton(
                    onPressed: () {
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text(
                      'Checkout',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
