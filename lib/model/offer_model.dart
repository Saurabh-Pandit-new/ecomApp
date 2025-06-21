class OfferModel {
  final String offerId;
  final String offername;
  final String imageUrl;
  final double discountPercent;

  OfferModel({
    required this.offerId,
    required this.offername,
    required this.imageUrl,
    required this.discountPercent,
  });

  Map<String, dynamic> toMap() {
    return {
      'offerId': offerId,
      'offername': offername,
      'imageUrl': imageUrl,
      'discountPercent': discountPercent, // 👈 Add here
    };
  }

  factory OfferModel.fromMap(Map<String, dynamic> map) {
    return OfferModel(
      offerId: map['offerId'] ?? '',
      offername: map['offername'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      discountPercent: (map['discountPercent'] ?? 0).toDouble(), // 👈 Parse as double
    );
  }
}
