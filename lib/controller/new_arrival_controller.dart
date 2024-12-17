import 'package:get/get.dart';
import '../model/product_model.dart';
import './product_controller.dart';

class NewArrivalController extends GetxController {
  final ProductController _productController = Get.find<ProductController>();

  final RxBool isLoading = false.obs;
  final RxList<Product> newArrivals = <Product>[].obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to changes in ProductController's products list
    ever(_productController.products, updateNewArrivals);
    // Initial load if products already exist
    if (_productController.products.isNotEmpty) {
      updateNewArrivals(_productController.products);
    }
  }

  void updateNewArrivals(List<Product> allProducts) {
    try {
      isLoading.value = true;
      error.value = '';

      // Create a copy to avoid modifying the original list
      final List<Product> sortedProducts = List<Product>.from(allProducts);

      // Sort products by creation date (newest first)
      sortedProducts.sort(
          (a, b) => b.createdAt!.compareTo(a.createdAt ?? DateTime.now()));

      // Take only the 10 newest products
      newArrivals.value = sortedProducts.take(5).toList();
    } catch (e) {
      error.value = 'Error processing new arrivals: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh by triggering ProductController refresh
  Future<void> refreshNewArrivals() async {
    await _productController.refreshProducts();
  }
}
