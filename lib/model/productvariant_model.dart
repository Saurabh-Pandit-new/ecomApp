class ProductVariant {
  final double price;
  final double discountPrice;
  final int stock;
  final List<String> images;

  final Map<String, dynamic> attributes;

  ProductVariant({
    required this.price,
    required this.discountPrice,
    required this.stock,
    required this.images,
    required this.attributes,
  });

  Map<String, dynamic> toMap() {
    return {
      'price': price,
      'discountPrice': discountPrice,
      'stock': stock,
      'images': images,
      'attributes': attributes,
    };
  }

  factory ProductVariant.fromMap(Map<String, dynamic> map) {
    return ProductVariant(
      price: (map['price'] ?? 0).toDouble(),
      discountPrice: (map['discountPrice'] ?? 0).toDouble(),
      stock: (map['stock'] ?? 0).toInt(),
      images: List<String>.from(map['images'] ?? []),
      attributes: Map<String, dynamic>.from(map['attributes'] ?? {}),
    );
  }
}
