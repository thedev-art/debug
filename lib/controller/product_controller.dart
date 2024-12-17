import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:logger/logger.dart';
import '../services/api_services.dart';
import '../model/product_model.dart';

class ProductController extends GetxController {
  final APIServices _apiServices = Get.find<APIServices>();
  final logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 75,
      colors: true,
      printEmojis: true,
    ),
  );

  final RxBool isLoading = false.obs;
  final RxList<Product> products = <Product>[].obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    logger.i("ProductController initialized");
    getAppProducts();
  }

  Future<void> getAppProducts() async {
    try {
      isLoading.value = true;
      error.value = '';

      logger.i("Fetching products from API...");
      final dio.Response response = await _apiServices.getRequest('/products');

      logger.i("API Response Status Code: ${response.statusCode}");
      logger.d("API Response Headers: ${response.headers}");
      logger.i("API Response Data: ${response.data}");

      if (response.statusCode == 200) {
        final dynamic responseData = response.data;
        List<dynamic> productList;

        if (responseData is Map<String, dynamic>) {
          productList = responseData['data'] ?? responseData['products'] ?? [];
        } else if (responseData is List) {
          productList = responseData;
        } else {
          throw Exception('Unexpected response format');
        }

        logger.i("Number of products received: ${productList.length}");

        products.value = productList.map((json) {
          logger.d("Processing product: $json");
          return Product.fromJson(json);
        }).toList();

        logger.i("Successfully loaded ${products.length} products");
      } else {
        error.value = 'Failed to load products. Status: ${response.statusCode}';
        logger.e("API Error: ${response.statusCode}", error: error.value);
      }
    } catch (e, stackTrace) {
      error.value = 'Error fetching products: ${e.toString()}';
      logger.e("Exception occurred while fetching products",
          error: e, stackTrace: stackTrace);
    } finally {
      isLoading.value = false;
      logger
          .i("Product fetching completed. Loading status: ${isLoading.value}");
    }
  }

  // Refresh products
  Future<void> refreshProducts() async {
    logger.i("Refreshing products...");
    products.clear();
    await getAppProducts();
  }

  // Get products by page (for pagination)
  // Future<void> getProductsByPage(int page) async {
  //   try {
  //     isLoading.value = true;
  //     error.value = '';

  //     logger.i("Fetching products for page: $page");
  //     final dio.Response response = await _apiServices.getRequest(
  //       'products/',
  //       payload: {'page': page},
  //     );

  //     logger.i("Page $page API Response: ${response.data}");

  //     if (response.statusCode == 200) {
  //       final List<dynamic> newProducts = response.data as List<dynamic>;
  //       logger.i("Received ${newProducts.length} new products for page $page");

  //       products.addAll(
  //         newProducts.map((json) => Product.fromJson(json)).toList(),
  //       );
  //       logger.i(
  //           "Successfully added page $page products. Total: ${products.length}");
  //     } else {
  //       error.value = 'Failed to load more products';
  //       logger.e("Failed to load page $page", error: error.value);
  //     }
  //   } catch (e, stackTrace) {
  //     error.value = 'Error loading more products: ${e.toString()}';
  //     logger.e("Exception loading page products",
  //         error: e, stackTrace: stackTrace);
  //   } finally {
  //     isLoading.value = false;
  //     logger.i("Page loading completed. Loading status: ${isLoading.value}");
  //   }
  // }
}
