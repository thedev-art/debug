import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../services/api_services.dart';
import '../model/product_model.dart';

class SearchingController extends GetxController {
  final APIServices _apiServices = Get.find<APIServices>();
  final RxList<Product> searchResults = <Product>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  final logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 75,
      colors: true,
      printEmojis: true,
    ),
  );

  Future<void> searchProducts(String query) async {
    try {
      isLoading.value = true;
      error.value = '';

      logger.i("Searching products with query: $query");
      final response =
          await _apiServices.getRequest('search/', payload: {'q': query});

      logger.i("Search API Response Status Code: ${response.statusCode}");
      logger.d("Search API Response Data: ${response.data}");

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        searchResults.value =
            data.map((json) => Product.fromJson(json)).toList();

        logger.i("Found ${searchResults.length} products matching '$query'");
        logger.d(
            "Search results: ${searchResults.map((p) => p.name).join(', ')}");
      } else {
        error.value = 'Unable to perform search';
        logger.e("Search API Error: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      error.value = 'Something went wrong';
      logger.e("Error searching products", error: e, stackTrace: stackTrace);
    } finally {
      isLoading.value = false;
    }
  }
}
