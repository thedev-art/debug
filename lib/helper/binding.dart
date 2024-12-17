// import 'package:amanuel_glass/controller/auth_controller.dart';
import 'package:amanuel_glass/controller/auth_controller.dart';
import 'package:amanuel_glass/controller/banner_controller.dart';
import 'package:amanuel_glass/controller/cart_controller.dart';
import 'package:amanuel_glass/controller/category_controller.dart';
import 'package:amanuel_glass/controller/location_controller.dart';
import 'package:amanuel_glass/controller/new_arrival_controller.dart';
import 'package:amanuel_glass/controller/payment_controller.dart';
import 'package:amanuel_glass/controller/product_controller.dart';
import 'package:amanuel_glass/controller/top_deal_controller.dart';
import 'package:amanuel_glass/controller/search_controller.dart';
import 'package:amanuel_glass/services/api_services.dart';
// import 'package:amanuel_glass/controller/user_controller.dart';
import 'package:get/get.dart';

class MyBindings extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<UserController>(() => UserController()
    // Get.lazyPut<AuthController>(() => AuthController());
    Get.put(APIServices(), permanent: true);
    Get.put(AuthController(), permanent: true);

    Get.lazyPut<CartController>(() => CartController());
    Get.lazyPut<LocationController>(() => LocationController());
    Get.lazyPut<NewArrivalController>(() => NewArrivalController(),
        fenix: true);
    // Get.lazyPut<CategoryController>(() => CategoryController(), fenix: true);
    Get.lazyPut<ProductController>(() => ProductController());
    Get.lazyPut<TopDealController>(() => TopDealController(), fenix: true);
    //
    Get.lazyPut<PaymentController>(() => PaymentController());

    Get.put(ProductController(), permanent: true);
    Get.put(CategoryController());
    Get.put(BannerController());
    Get.lazyPut<SearchingController>(() => SearchingController(), fenix: true);
  }
}
