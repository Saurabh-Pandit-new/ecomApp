import 'package:flutter/material.dart';
import 'package:form_validation/controller/offerimg_controller.dart';
import 'package:form_validation/controller/user_controller.dart';
import 'package:form_validation/model/cart_model.dart';
import 'package:form_validation/model/offer_model.dart';
import 'package:form_validation/model/user_model.dart';
import 'package:form_validation/screens/cart_page.dart';
import 'package:form_validation/screens/login_screen.dart';
import 'package:form_validation/service/cart_service.dart';
import 'package:get/get.dart';
import '../../../model/product_model.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;

  ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final UserController _userController = Get.put(UserController());
  final OfferimgController offerController = Get.put(OfferimgController());
  final CartService _cartService=CartService();

  Future addCart(String userId,String productId) async{
   final cartItem=CartModel(
    cartId:'',
    userId: userId,
    productId: productId,
    quantity: 1,
   );

   await _cartService.addToCart(cartItem);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Product added to cart')),
  );

   }
  

  @override
  Widget build(BuildContext context) {
    UserModel? user = _userController.currentuser.value;
    return Scaffold(
      appBar: AppBar(title: Text(widget.product.productName)),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.product.productImages.isNotEmpty)
                  SizedBox(
                    height: 330,
                    child: PageView.builder(
                      itemCount: widget.product.productImages.length,
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Stack(
                            children: [
                              Image.network(
                                widget.product.productImages[index],
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                const SizedBox(height: 16),

                Text(
                  widget.product.productName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (widget.product.brand.isNotEmpty)
                  Text(
                    'Brand: ${widget.product.brand}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Special price ',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          TextSpan(
                            text:
                                '\n₹ ${widget.product.discountPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 30),
                    if (widget.product.price > widget.product.discountPrice)
                      Text(
                        '₹ ${widget.product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      ),

                    const SizedBox(width: 10),
                    Obx(() {
                      OfferModel? offer = offerController.offerList
                          .firstWhereOrNull(
                            (o) => o.offerId == widget.product.offerId,
                          );

                      return offer != null
                          ? Text(
                              ' ${offer.discountPercent}% Off',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.green,
                              ),
                            )
                          : SizedBox.shrink();
                    }),
                  ],
                ),

                const SizedBox(height: 4),

                if (widget.product.ratings > 0)
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber.shade600),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.product.ratings.toStringAsFixed(1)} (${widget.product.totalReviews} reviews)',
                      ),
                    ],
                  ),

                const SizedBox(height: 12),

                if (widget.product.description.isNotEmpty)
                  Text(
                    widget.product.description,
                    style: const TextStyle(fontSize: 16),
                  ),

                const Divider(height: 30),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    if (widget.product.stock > 0 &&
                        widget.product.unit.isNotEmpty)
                      Text(
                        'Stock: ${widget.product.stock} ${widget.product.unit}',
                      ),
                    if (widget.product.categoryId.isNotEmpty)
                      Text('Category: ${widget.product.categoryId}'),
                    if (widget.product.subcategoryId.isNotEmpty)
                      Text('Subcategory: ${widget.product.subcategoryId}'),
                  ],
                ),

                const SizedBox(height: 16),

                if (widget.product.material.trim().isNotEmpty ||
                    widget.product.fabric.trim().isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.product.material.trim().isNotEmpty)
                        Text(
                          'Material: ${widget.product.material}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      if (widget.product.fabric.trim().isNotEmpty)
                        Text(
                          'Fabric: ${widget.product.fabric}',
                          style: const TextStyle(fontSize: 16),
                        ),
                    ],
                  ),

                const SizedBox(height: 16),

                if (widget.product.sizeOptions
                    .where((s) => s.trim().isNotEmpty)
                    .isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Available Sizes:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Wrap(
                        spacing: 8,
                        children: widget.product.sizeOptions
                            .where((s) => s.trim().isNotEmpty)
                            .map((s) => Chip(label: Text(s)))
                            .toList(),
                      ),
                    ],
                  ),

                if (widget.product.colorOptions
                    .where((c) => c.trim().isNotEmpty)
                    .isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Available Colors:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Wrap(
                        spacing: 8,
                        children: widget.product.colorOptions
                            .where((c) => c.trim().isNotEmpty)
                            .map((c) => Chip(label: Text(c)))
                            .toList(),
                      ),
                    ],
                  ),

                const SizedBox(height: 16),

                if (widget.product.isReturnable)
                  Text(
                    'Returnable within ${widget.product.returnDays} days',
                    style: const TextStyle(color: Colors.green),
                  ),

                if (widget.product.isNewArrival)
                  const Text(
                    '🌟 New Arrival!',
                    style: TextStyle(color: Colors.blueAccent),
                  ),

                const SizedBox(height: 20),

                Text(
                  'Added by: ${widget.product.addedBy}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  'Created at: ${widget.product.createdAt.toLocal().toString().split(' ')[0]}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () {
                (_userController.isLogin.value)?
                addCart(user!.userId, widget.product.productId):Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Add to Cart',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            top: 30,
            left: 340,
            child: Obx(() {
              final user = _userController.currentuser.value;

              return IconButton(
                icon: Icon(
                  Icons.favorite,
                  color:
                      (user != null &&
                          user.wishlist?.contains(widget.product.productId) ==
                              true)
                      ? Colors.red
                      : Colors.black38,
                ),
                onPressed: () async {
                  if (user == null) return;

                  bool isWishlisted =
                      user.wishlist?.contains(widget.product.productId) ??
                      false;
                  List<String> updatedWishlist = List<String>.from(
                    user.wishlist ?? [],
                  );

                  isWishlisted
                      ? updatedWishlist.remove(widget.product.productId)
                      : updatedWishlist.add(widget.product.productId);

                  await _userController.updateUserField(
                    'wishlist',
                    updatedWishlist,
                  );

                  _userController.currentuser.update((val) {
                    val?.wishlist = updatedWishlist;
                  });
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
