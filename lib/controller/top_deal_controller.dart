import 'package:get/get.dart';
import '../model/product_model.dart';
import './product_controller.dart';

class TopDealController extends GetxController {
  final ProductController _productController = Get.find<ProductController>();

  final RxBool isLoading = false.obs;
  final RxList<Product> topDeals = <Product>[].obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to changes in ProductController's products list
    ever(_productController.products, updateTopDeals);
    // Initial load if products already exist
    if (_productController.products.isNotEmpty) {
      updateTopDeals(_productController.products);
    }
  }

  void updateTopDeals(List<Product> allProducts) {
    try {
      isLoading.value = true;
      error.value = '';

      // Create a copy to avoid modifying the original list
      final List<Product> sortedProducts = List<Product>.from(allProducts);

      // Filter out products with no price
      sortedProducts.removeWhere((product) => product.price == null);

      // Sort products by price (lowest first)
      sortedProducts.sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));

      // Take only the 10 cheapest products
      topDeals.value = sortedProducts.take(10).toList();
    } catch (e) {
      error.value = 'Error processing top deals: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh by triggering ProductController refresh
  Future<void> refreshTopDeals() async {
    await _productController.refreshProducts();
  }

  // Get discounted price if available
  double? calculateDiscountedPrice(Product product) {
    if (product.price == null) return null;
    
    if (product.discount == null) {
      return product.price;
    }
    
    // If it's percentage discount
    if (product.discountType == 'percentage') {
      return product.price! - (product.price! * ((product.discount ?? 0) / 100));
    }
    
    // If it's fixed amount discount
    return product.price! - (product.discount ?? 0);
  }

  // Sort by final price (including discounts)
  void updateTopDealsByFinalPrice(List<Product> allProducts) {
    try {
      isLoading.value = true;
      error.value = '';

      final List<Product> sortedProducts = List<Product>.from(allProducts);

      // Filter out products with no price
      sortedProducts.removeWhere((product) => product.price == null);

      // Sort by final price including discounts
      sortedProducts.sort((a, b) {
        final priceA = calculateDiscountedPrice(a) ?? double.infinity;
        final priceB = calculateDiscountedPrice(b) ?? double.infinity;
        return priceA.compareTo(priceB);
      });

      // Take only the 10 best deals
      topDeals.value = sortedProducts.take(10).toList();
    } catch (e) {
      error.value = 'Error processing top deals: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }
}
