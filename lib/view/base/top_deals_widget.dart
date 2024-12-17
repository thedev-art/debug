import 'package:amanuel_glass/controller/cart_controller.dart';
import 'package:amanuel_glass/controller/top_deal_controller.dart';
import 'package:amanuel_glass/helper/dimension.dart';
import 'package:amanuel_glass/view/base/product_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class TopDeals extends GetView<CartController> {
  TopDeals({
    super.key,
    required this.fem,
    required this.ffem,
  });

  final double fem;
  final double ffem;

  // Get instance of TopDealController
  final TopDealController topDealController = Get.find<TopDealController>();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Container(
      padding: const EdgeInsets.only(left: 20, right: 17),
      child: SizedBox(
        height: screenHeight * 0.3,
        child: Obx(() {
          if (topDealController.isLoading.value) {
            return SizedBox(
                width: double.infinity,
                height: 300,
                child: buildcatShimmerEfect());
          }

          if (topDealController.error.isNotEmpty) {
            return Center(child: Text(topDealController.error.value));
          }

          if (topDealController.topDeals.isEmpty) {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 100),
                Center(
                  child: Text(
                    "No Product found",
                    style: TextStyle(color: Color.fromARGB(184, 138, 138, 138)),
                  ),
                ),
              ],
            );
          }

          return SizedBox(
            height: 250,
            child: ListView.builder(
                itemCount: topDealController.topDeals.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return ProductItemWidget(
                    fem: fem,
                    product: topDealController.topDeals[index],
                    ffem: ffem,
                    fromwishlist: false,
                  );
                }),
          );
        }),
      ),
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
            padding: const EdgeInsets.all(5),
            child: Shimmer.fromColors(
                baseColor: const Color.fromARGB(255, 195, 195, 195),
                highlightColor: Colors.grey[300] ?? Colors.grey,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      color: const Color.fromARGB(255, 252, 4, 4)),
                  width: 50,
                  height: 50,
                )),
          ),
        ),
      );
}
