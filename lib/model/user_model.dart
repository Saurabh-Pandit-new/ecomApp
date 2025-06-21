import 'package:form_validation/model/product_model.dart';

class UserModel {
  final String userId;
  final String userName;
  final String email;
  final String phone;
  final String profileImageUrl;
  final String address;
  final String role;
  List<dynamic> wishlist;
  List<dynamic> cartlist;
  UserModel({
    required this.userId,
    required this.userName,
    required this.email,
    required this.phone,
    required this.profileImageUrl,
    required this.address,
    required this.role,
    required this.wishlist,
    required this.cartlist,
  });

  Map<String,dynamic> toJson(){
    return{
      'userId':userId,
      'userName':userName,
      'email':email,
      'phone':phone,
      'profileImageUrl':profileImageUrl,
      'address':address,
      'role':role,
      'wishlist':wishlist,
      'cartlist':cartlist,
    };
  }

  factory UserModel.fromMap(Map<String,dynamic> map){
    return UserModel(
      userId:map['userId'] ?? '',
      userName: map['userName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      address: map['address'] ?? '',
      role: map['role'] ?? '',
      wishlist: List<String>.from(map['wishlist'] ?? []),
      cartlist: List<String>.from(map['cartlist'] ?? []),


    );
  }


}
