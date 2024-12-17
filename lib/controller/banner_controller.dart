import 'package:amanuel_glass/model/product_model.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:logger/logger.dart';
import '../services/api_services.dart';
// import '../model/banner_model.dart';

class BannerController extends GetxController {
  final APIServices _apiServices = Get.find<APIServices>();
  final RxList<Banner> banners = <Banner>[].obs;
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

  @override
  void onInit() {
    super.onInit();
    logger.i("BannerController initialized");
    fetchBanners();
  }

  Future<void> fetchBanners() async {
    try {
      isLoading.value = true;
      error.value = '';

      logger.i("Fetching banners from API...");
      final dio.Response response = await _apiServices.getRequest('/banners/');

      logger.i("API Response Status Code: ${response.statusCode}");
      logger.d("API Response Headers: ${response.headers}");

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        banners.value = data.map((json) => Banner.fromJson(json)).toList();

        // Filter active banners only
        banners.value = banners.where((banner) => banner.isActive).toList();

        logger.i("Successfully fetched ${banners.length} active banners");
        logger.d("Banner data: ${banners.map((b) => b.title).join(', ')}");
      } else {
        error.value = 'Failed to load banners';
        logger.e("Failed to fetch banners: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      error.value = 'Error loading banners';
      logger.e("Error fetching banners", error: e, stackTrace: stackTrace);
    } finally {
      isLoading.value = false;
      update();
    }
  }

  void refreshBanners() {
    logger.i("Refreshing banners...");
    fetchBanners();
  }

  Future<Product?> getProduct(String? id) async {
    try {
      if (id == null) return null;

      logger.i("Fetching product with ID: $id");
      final response = await _apiServices.getRequest('products/$id/');

      if (response.statusCode == 200) {
        logger.d("Product data received: ${response.data}");
        return Product.fromJson(response.data);
      }
      return null;
    } catch (e) {
      logger.e("Error fetching product: $e");
      return null;
    }
  }

  Future<List<Product>> getCategoryProducts(String categoryId) async {
    try {
      logger.i("Fetching products for category: $categoryId");
      final response = await _apiServices
          .getRequest('categorized-products/?category=$categoryId');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        logger.d("Category products received: ${data.length} items");
        return data.map((json) => Product.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      logger.e("Error fetching category products: $e");
      return [];
    }
  }

  void getBanners() {
    // Your banner loading logic here
  }
}

// Banner Model
class Banner {
  final int id;
  final String title;
  final String description;
  final String image;
  final String priority;
  final bool isActive;
  final String createdAt;
  final int category;

  Banner({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.priority,
    required this.isActive,
    required this.createdAt,
    required this.category,
  });

  factory Banner.fromJson(Map<String, dynamic> json) {
    return Banner(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      priority: json['priority'] as String,
      isActive: json['is_active'] as bool,
      createdAt: json['created_at'] as String,
      category: json['category'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'priority': priority,
      'is_active': isActive,
      'created_at': createdAt,
      'category': category,
    };
  }
}
