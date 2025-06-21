// lib/controller/category_controller.dart
import 'package:get/get.dart';
import 'package:form_validation/service/category_service.dart';

class CategoryController extends GetxController {
  final CategoryService _service = CategoryService();

  RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      isLoading.value = true;
      final data = await _service.fetchCategories();
      categories.assignAll(data);
    } catch (e) {
      print('Error loading categories: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
