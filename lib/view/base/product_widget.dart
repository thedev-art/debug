import 'package:amanuel_glass/controller/product_controller.dart';
import 'package:amanuel_glass/helper/dimension.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:amanuel_glass/controller/cart_controller.dart';
import 'package:amanuel_glass/helper/colors.dart';
// import 'package:amanuel_glass/helper/dimensions.dart';
import 'package:amanuel_glass/model/product_model.dart';
import 'package:amanuel_glass/view/base/product_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:logger/logger.dart';

import '../components/custom_snackbar.dart';

class ProductWidget extends StatelessWidget {
  final double fem;
  final double ffem;
  final logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 75,
      colors: true,
      printEmojis: true,
    ),
  );

  ProductWidget({
    Key? key,
    required this.fem,
    required this.ffem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (cartController) {
      checkInternetConnection();

      if (Get.find<ProductController>().isLoading.value) {
        return SizedBox(
            width: double.infinity, height: 300, child: buildcatShimmerEfect());
      }

      final allProducts = cartController.filteredProducts.isEmpty
          ? Get.find<ProductController>().products
          : cartController.filteredProducts;

      logger.i("📦 Starting product filtering process...");
      logger.d("Total products before filtering: ${allProducts.length}");

      // Log details of each product's active status
      allProducts.forEach((product) {
        logger.d("Product: ${product.name} - Active: ${product.isActive}");
      });

      final activeProducts =
          allProducts.where((product) => product.isActive == true).toList();

      logger.i("🎯 Filtering results:");
      logger.i("Total products: ${allProducts.length}");
      logger.i("Active products: ${activeProducts.length}");
      logger.i(
          "Inactive products: ${allProducts.length - activeProducts.length}");

      // Log active products details
      logger.d("Active products list:");
      activeProducts.forEach((product) {
        logger.d("✓ ${product.name} (ID: ${product.id})");
      });

      if (activeProducts.isEmpty) {
        logger.w("⚠️ No active products found to display");
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            const Center(
              child: Text(
                "No active products found",
                style: TextStyle(color: Color.fromARGB(184, 138, 138, 138)),
              ),
            ),
          ],
        );
      }

      logger.i(
          "✨ Successfully filtered and displaying ${activeProducts.length} active products");

      return GridView.builder(
          itemCount: activeProducts.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 10 / 13,
            crossAxisCount: 2,
          ),
          itemBuilder: (context, index) {
            final product = activeProducts[index];
            logger.d("Building product widget for: ${product.name}");
            return ProductItemWidget(
              product: product,
              fem: fem,
              ffem: ffem,
              fromwishlist: false,
            );
          });
    });
  }

  Widget buildcatShimmerEfect() => SizedBox(
        child: GridView.builder(
          itemCount: 6,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 10 / 13,
            crossAxisCount: 2,
          ),
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(5),
            child: Shimmer.fromColors(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      color: const Color.fromARGB(255, 252, 4, 4)),
                  width: 50,
                  height: 50,
                ),
                baseColor: const Color.fromARGB(255, 195, 195, 195),
                highlightColor: Colors.grey[300]!),
          ),
        ),
      );

  void checkInternetConnection() async {
    if (await InternetConnectionChecker().hasConnection) {
    } else {
      showCustomSnackBar('please check your internet connection!');
    }
  }
}
