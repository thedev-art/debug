// import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:amanuel_glass/controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:logger/logger.dart';
import 'package:dio/dio.dart' as dio;

import '../model/coupon_model.dart';
import '../model/product_model.dart';
import '../view/components/custom_snackbar.dart';
import '../services/api_services.dart';

class CartController extends GetxController {
  var logger = Logger();
  bool isInCart = false;
  Rx<RangeValues> costRangeValues =
      Rx<RangeValues>(const RangeValues(0, 20000));
  RangeValues? currentRangevalue;
  RxList<Product> cartItems = RxList<Product>();
  RxBool isCartIconTaped = false.obs;
  RxBool isCouponbtnTaped = false.obs;
  Coupon? coupon;
  RxString isAscOrd = ''.obs;
  bool? Asc;
  RxInt groupValuAsc = 10.obs;
  RxBool isLoading = true.obs;
  var selectedIndex = 0.obs;

  // Add new observable for filtered products
  RxList<Product> filteredProducts = RxList<Product>();

  @override
  void onInit() {
    super.onInit();
    currentRangevalue = costRangeValues.value;
    ever(cartItems, (_) {
      print('Cart updated: ${cartItems.length} items');
      print(
          'Cart contents: ${cartItems.map((p) => '${p.name}: ${p.quantity}').join(', ')}');
      update();
    });
    loadCartFromStorage();
  }

  void checkInternetConnection2() async {
    if (await InternetConnectionChecker().hasConnection) {
    } else {}
  }

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  void clearAllFilters() {
    costRangeValues.value = const RangeValues(0, 20000);
    isAscOrd.value = '';
    groupValuAsc.value = 10;
    currentRangevalue = costRangeValues.value;
    applyFilters();
    update();
  }

  void orderBy(bool isAsc) {
    if (isAsc) {
      isAscOrd.value = 'true';
      groupValuAsc.value = 1;
    } else {
      isAscOrd.value = 'false';
      groupValuAsc.value = 2;
    }
    // Trigger filter update
    applyFilters();
    update();
  }

  void navigateToCartScreen({int index = 1}) {
    changeIndex(index);
  }

  void incrementQuantity(Product product) {
    try {
      int index = getIndex(product);
      if (index != -1) {
        var existingProduct = cartItems[index];
        existingProduct.quantity = (existingProduct.quantity ?? 0) + 1;
        cartItems[index] = existingProduct;
        cartItems.refresh();

        logger.d(
            'Incremented quantity for ${existingProduct.name} to ${existingProduct.quantity}');
      } else {
        // If product not in cart, add it
        addToCart(product);
      }
    } catch (e, stackTrace) {
      logger.e('Error incrementing quantity', error: e, stackTrace: stackTrace);
    }
  }

  void decrementQuantity(Product product) {
    try {
      int index = getIndex(product);
      if (index != -1) {
        var existingProduct = cartItems[index];
        if ((existingProduct.quantity ?? 0) <= 1) {
          cartItems.removeAt(index);
          if (cartItems.isEmpty) {
            isCouponbtnTaped.value = false;
            coupon = null;
          }
        } else {
          existingProduct.quantity = (existingProduct.quantity ?? 0) - 1;
          cartItems[index] = existingProduct;
        }
        cartItems.refresh();

        logger.d(
            'Decremented quantity for ${existingProduct.name} to ${existingProduct.quantity}');
      }
    } catch (e, stackTrace) {
      logger.e('Error decrementing quantity', error: e, stackTrace: stackTrace);
    }
  }

  void addToCart(Product product) {
    try {
      int index = getIndex(product);
      if (index == -1) {
        // Create new product instance for cart
        Product cartProduct = Product(
          id: product.id,
          name: product.name,
          price: product.price,
          coverImage: product.coverImage,
          description: product.description,
          quantity: 1,
          discount: product.discount,
          discountType: product.discountType,
          isActive: true,
        );
        cartItems.add(cartProduct);
        showCustomSnackBar('Item added to cart'.tr, isError: false);
        logger.d('Added new product ${cartProduct.name} to cart');
      } else {
        incrementQuantity(cartItems[index]);
        logger.d('Increased quantity for existing product ${product.name}');
      }
    } catch (e, stackTrace) {
      logger.e('Error adding to cart', error: e, stackTrace: stackTrace);
    }
  }

  void removeFromCart(Product product) {
    decrementQuantity(product);
  }

  bool isInCartFun(Product product) {
    return cartItems.any((item) => item.id == product.id);
  }

  double getQuantity(Product product) {
    int index = getIndex(product);
    return index != -1 ? cartItems[index].quantity?.toDouble() ?? 0 : 0;
  }

  int getIndex(Product product) {
    return cartItems.indexWhere((item) => item.id == product.id);
  }

  void clearCartList() {
    cartItems.clear();
    coupon = null;
  }

  void clearCouponData() {
    coupon = null;
    isCouponbtnTaped.value = false;
    update();
  }

  int get itemCount => cartItems.length;
  List<Product> get cartItemsList => cartItems;

  Future<void> applyforCoupon(String couponCode, double totalAmount) async {
    try {
      final response = await Get.find<APIServices>().postRequest(
        'apply_coupon/',
        payload: {
          'coupon_title': couponCode,
          'order_amount': totalAmount,
        },
      );
      
      if (response.statusCode == 200) {
        var responseData = response.data;
        if (responseData['response'] is num) {
          // Valid coupon case
          coupon = Coupon(
            discountAmount: double.parse(responseData['response'].toString()),
            discountType: 'amount',
          );
          isCouponbtnTaped.value = true;
          update();
        }
      } else if (response.statusCode == 400) {
        throw '400: Invalid coupon code';
      } else {
        throw 'Failed to apply coupon';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // Add persistence
  void saveCartToStorage() {
    // Add SharedPreferences logic to persist cart
  }

  void loadCartFromStorage() {
    // Add SharedPreferences logic to load cart
  }

  void updateRangeValues(RangeValues values) {
    currentRangevalue = values;
    costRangeValues.value = values;
    // Trigger filter update
    applyFilters();
    update();
  }

  // New method to apply filters
  void applyFilters() {
    final productController = Get.find<ProductController>();

    // Filter by price range
    var filtered = productController.products.where((product) {
      final price = product.price ?? 0;
      return price >= costRangeValues.value.start &&
          price <= costRangeValues.value.end;
    }).toList();

    // Apply sorting
    if (isAscOrd.value == 'true') {
      filtered.sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
    } else if (isAscOrd.value == 'false') {
      filtered.sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));
    }

    filteredProducts.value = filtered;
    update();
  }

  Future<void> buyNow(Product product) async {
    try {
      // Add to cart
      addToCart(product);
      isInCartFun(product);

      // Navigate directly to cart screen
      await Get.offNamed(
          '/cart'); // Use offNamed instead of multiple navigations
    } catch (e) {
      print('Error in buyNow: $e');
      showCustomSnackBar('Error processing your request');
    }
  }
}
