class CartModel{
  final String cartId;
  final String userId;
  final String productId;
  final int quantity;

  CartModel({
    required this.cartId,
    required this.userId,
    required this.productId,
    required this.quantity,
  });

  Map<String,dynamic> toJson(){
    return{
      'cartId':cartId,
      'userId':userId,
      'productId':productId,
      'quantity':quantity,
    };
  } 

  factory CartModel.fromMap(Map<String,dynamic> map){
    return CartModel(
      cartId: map['cartId'] ?? '',
      userId: map['userId'] ?? '',
      productId: map['productId'] ?? '',
      quantity: map['quantity'] ?? '',
    );
  }
  CartModel copyWith({
    String? cartId,
    String? userId,
    String? productId,
    int? quantity,
  }) {
    return CartModel(
      cartId: cartId ?? this.cartId,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
    );
}}