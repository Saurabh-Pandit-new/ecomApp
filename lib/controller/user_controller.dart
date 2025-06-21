import 'package:firebase_auth/firebase_auth.dart';
import 'package:form_validation/model/user_model.dart';
import 'package:form_validation/service/user_service.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final UserService _userService = UserService();
  Rxn<UserModel> currentuser = Rxn<UserModel>();
  RxBool isLoading = false.obs;
  RxBool isLogin = false.obs;

  void loadCurrentUserData() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      fetchUserById(userId);
      isLogin.value = true;
    } else {
      isLogin.value = false;
      currentuser.value = null;
    }
  }

  Future<void> fetchUserById(String userId) async {
    try {
      isLoading.value = true;
      final user = await _userService.fetchUser(userId);
      if (user != null) {
        currentuser.value = user;
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUserField(String key, dynamic value) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid != null) {
    await _userService.updateUserFields(uid, {key: value});
    await fetchUserById(uid);
  }
}


  
}
