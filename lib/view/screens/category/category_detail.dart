import 'package:amanuel_glass/controller/category_controller.dart';
import 'package:amanuel_glass/helper/app_constants.dart';
import 'package:badges/badges.dart' as badges;
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:amanuel_glass/controller/cart_controller.dart';
import 'package:amanuel_glass/model/category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../helper/colors.dart';
import '../../../model/product_model.dart';
import '../../base/product_item_widget.dart';
// import '../../base/product_widget.dart';

class CategoryDetail extends StatefulWidget {
  final String? cat_id;
  final String? cat_name;

  const CategoryDetail({
    Key? key,
    this.cat_id,
    this.cat_name,
  }) : super(key: key);

  @override
  State<CategoryDetail> createState() => _CategoryDetailState();
}

class _CategoryDetailState extends State<CategoryDetail> {
  final CategoryController categoryController = Get.find<CategoryController>();

  @override
  void initState() {
    super.initState();
    if (widget.cat_id != null) {
      categoryController.fetchCategorizedProducts(widget.cat_id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back),
            color: Colors.black),
        title: Text(
          widget.cat_name ?? '',
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        toolbarHeight: 70,
        actions: [
          Obx(
            () => InkWell(
              onTap: () {
                Get.back();
                Get.find<CartController>().navigateToCartScreen();
              },
              child: badges.Badge(
                position: badges.BadgePosition.topEnd(top: -5, end: -10),
                badgeContent: Text(
                  Get.find<CartController>().cartItems.length.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
                child: Image.asset(
                  'assets/icons/iconly-light-buy-9hK.png',
                  width: 30,
                  height: 30,
                  color: MyColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Obx(() {
        // Loading State
        if (categoryController.isLoadingProducts.value) {
          return buildcatShimmerEfect();
        }

        // Error State
        if (categoryController.productError.value.isNotEmpty) {
          return Center(
            child: Text(categoryController.productError.value),
          );
        }

        // Empty State
        if (categoryController.categorizedProducts.isEmpty) {
          return const Scaffold(
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  "No product found for this category",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        // Success State
        return GridView.builder(
            itemCount: categoryController.categorizedProducts.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 10 / 13,
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 20, right: 17),
                child: ProductItemWidget(
                  fem: fem,
                  product: categoryController.categorizedProducts[index],
                  ffem: ffem,
                  fromwishlist: false,
                ),
              );
            });
      }),
    );
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
            padding: const EdgeInsets.all(8.0),
            child: Shimmer.fromColors(
              child: Container(
                width: 50,
                height: 50,
                color: const Color.fromARGB(255, 252, 4, 4),
              ),
              baseColor: const Color.fromARGB(255, 195, 195, 195),
              highlightColor: Colors.grey[300] ?? Colors.grey,
            ),
          ),
        ),
      );
}
