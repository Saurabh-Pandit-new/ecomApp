class ProductModel {
  final String productId;
  final String productName;
  final String description;
  final String categoryId;
  final String subcategoryId;


  final double price;
  final double discountPrice;
  final String currency;
  final int stock;
  final String unit;

  final String brand;
  final bool isReturnable;
  final int returnDays;
  final bool isNewArrival;

  final String fabric;
  final String material;
  final List<String> sizeOptions;
  final List<String> colorOptions;
  final List<String> productImages;

  final double ratings;
  final int totalReviews;

  final String addedBy;
  final DateTime createdAt;
  final String offerId;

  ProductModel({
    required this.productId,
    required this.productName,
    required this.description,
    required this.categoryId,
    required this.subcategoryId,
    required this.price,
    required this.discountPrice,
    required this.currency,
    required this.stock,
    required this.unit,
    required this.brand,
    required this.isReturnable,
    required this.returnDays,
    required this.isNewArrival,
    required this.fabric,
    required this.material,
    required this.sizeOptions,
    required this.colorOptions,
    required this.productImages,
    required this.ratings,
    required this.totalReviews,
    required this.addedBy,
    required this.createdAt,
    required this.offerId,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'description': description,
      'categoryId': categoryId,
      'subcategoryId': subcategoryId,

      'price': price,
      'discountPrice': discountPrice,
      'currency': currency,
      'stock': stock,
      'unit': unit,
      'brand': brand,
      'isReturnable': isReturnable,
      'returnDays': returnDays,
      'isNewArrival': isNewArrival,
      'fabric': fabric,
      'material': material,
      'sizeOptions': sizeOptions,
      'colorOptions': colorOptions,
      'productImages': productImages,
      'ratings': ratings,
      'totalReviews': totalReviews,
      'addedBy': addedBy,
      'createdAt': createdAt.toIso8601String(),
      'offerId':offerId
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      description: map['description'] ?? '',
      categoryId: map['categoryId'] ?? '',
      subcategoryId: map['subcategoryId'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      discountPrice: (map['discountPrice'] ?? 0).toDouble(),
      currency: map['currency'] ?? '',
      stock: (map['stock'] ?? 0).toInt(),
      unit: map['unit'] ?? '',
      brand: map['brand'] ?? '',
      isReturnable: map['isReturnable'] ?? false,
      returnDays: (map['returnDays'] ?? 0).toInt(),
      isNewArrival: map['isNewArrival'] ?? false,
      fabric: map['fabric'] ?? '',
      material: map['material'] ?? '',
      sizeOptions: List<String>.from(map['sizeOptions'] ?? []),
      colorOptions: List<String>.from(map['colorOptions'] ?? []),
      productImages: List<String>.from(map['productImages'] ?? []),
      ratings: (map['ratings'] ?? 0).toDouble(),
      totalReviews: (map['totalReviews'] ?? 0).toInt(),
      addedBy: map['addedBy'] ?? '',
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      offerId: map['offerId'] ?? '',
    );
  }

}
