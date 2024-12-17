import 'package:amanuel_glass/model/product_model.dart';
import 'package:amanuel_glass/services/api_services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../model/category.dart';

class CategoryController extends GetxController {
  final APIServices _apiServices = Get.find<APIServices>();
  final RxList<Category> categories = <Category>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  final RxList<Product> categorizedProducts = <Product>[].obs;
  final RxBool isLoadingProducts = false.obs;
  final RxString productError = ''.obs;

  final logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 75,
      colors: true,
      printEmojis: true,
    ),
  );

  @override
  void onInit() {
    super.onInit();
    logger.i("CategoryController initialized");
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      error.value = '';

      logger.i("Fetching categories from API...");
      final response = await _apiServices.getRequest('category/');

      logger.i("API Response Status Code: ${response.statusCode}");
      logger.d("API Response Headers: ${response.headers}");
      logger.d("API Response Data: ${response.data}");

      if (response.statusCode == 200) {
        final dynamic responseData = response.data;
        List<dynamic> categoryList;

        if (responseData is Map<String, dynamic>) {
          // Handle wrapped response
          categoryList =
              responseData['data'] ?? responseData['categories'] ?? [];
        } else if (responseData is List) {
          // Handle direct list response
          categoryList = responseData;
        } else {
          throw Exception('Unexpected response format');
        }

        logger.i("Number of categories received: ${categoryList.length}");

        categories.value = categoryList.map((json) {
          logger.d("Processing category: $json");
          return Category(
            category_id: json['id']?.toString(),
            name: json['name'],
            img: json['image'],
            status: json['status'] ?? true,
          );
        }).toList();

        logger.i("Successfully loaded ${categories.length} categories");
        logger.d(
            "Categories after mapping: ${categories.value.map((c) => c.toMap()).toList()}");
      } else {
        error.value =
            'Failed to load categories. Status: ${response.statusCode}';
        logger.e("API Error: ${response.statusCode}", error: error.value);
      }
    } catch (e, stackTrace) {
      error.value = 'Error fetching categories: ${e.toString()}';
      logger.e("Exception occurred while fetching categories",
          error: e, stackTrace: stackTrace);
    } finally {
      isLoading.value = false;
      logger
          .i("Category fetching completed. Loading status: ${isLoading.value}");
    }
  }

  Future<void> refreshCategories() async {
    logger.i("Refreshing categories...");
    categories.clear();
    await fetchCategories();
  }

  Future<void> fetchCategorizedProducts(String categoryId) async {
    try {
      isLoadingProducts.value = true;
      productError.value = '';

      logger.i("Fetching products for category ID: $categoryId");
      final response = await _apiServices
          .getRequest('categorized-products/?category=$categoryId');

      if (response.statusCode == 200) {
        final List<dynamic> productsData = response.data;
        logger.i("Number of products received: ${productsData.length}");

        categorizedProducts.value = productsData.map((json) {
          // Construct full image URL
          String? imageUrl = json['cover_image'] != null
              ? 'http://amanuelglass.com${json['cover_image']}'
              : null;

          logger.d("Processing product with image: $imageUrl");

          return Product.fromJson({
            ...json,
            'cover_image': imageUrl, // Use the full URL
          });
        }).toList();

        logger.i(
            "Successfully loaded ${categorizedProducts.length} products for category $categoryId");
      } else {
        productError.value = 'Unable to load products. Please try again later.';
        logger.e("API Error: ${response.statusCode}", error: response.data);
      }
    } catch (e, stackTrace) {
      productError.value = 'Something went wrong. Please try again later.';
      logger.e("Exception occurred while fetching categorized products",
          error: e, stackTrace: stackTrace);
    } finally {
      isLoadingProducts.value = false;
    }
  }
}
