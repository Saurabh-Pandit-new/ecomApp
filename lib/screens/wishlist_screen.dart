// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:form_validation/controller/product_controller.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import '../model/product_model.dart';
// import '../service/user_service.dart';
// import '../model/user_model.dart';

// class WishlistScreen extends StatefulWidget {
//   const WishlistScreen({Key? key}) : super(key: key);

//   @override
//   _WishlistScreenState createState() => _WishlistScreenState();
// }

// class _WishlistScreenState extends State<WishlistScreen> {
//   final UserService _userService = UserService();
//   final ProductController _productController=Get.put(ProductController());
//   List<ProductModel> wishlistProducts = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchWishlistProducts();
//   }

//   Future<void> fetchWishlistProducts() async {
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid != null) {
//       final user = await _userService.fetchUser(uid);
//       if (user != null && user.wishlist.isNotEmpty) {
//         final products = await _productController.fetchProductsByIds(user.wishlist);
//         setState(() {
//           wishlistProducts = products;
//           isLoading = false;
//         });
//       } else {
//         setState(() => isLoading = false);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Wishlist")),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : wishlistProducts.isEmpty
//               ? const Center(child: Text("No items in wishlist"))
//               : ListView.builder(
//                   itemCount: wishlistProducts.length,
//                   itemBuilder: (context, index) {
//                     final product = wishlistProducts[index];
//                     return ListTile(
//                       title: Text(product.productName),
//                       subtitle: Text('₹${product.price}'),
//                       leading: Image.network(product.productImages[0], width: 50),
//                     );
//                   },
//                 ),
//     );
//   }
// }
