import 'package:amanuel_glass/controller/cart_controller.dart';
import 'package:amanuel_glass/controller/new_arrival_controller.dart';
import 'package:amanuel_glass/helper/dimension.dart';
import 'package:amanuel_glass/model/product_model.dart';
import 'package:amanuel_glass/view/base/product_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class LatestProductWidget extends GetView<CartController> {
  LatestProductWidget({
    Key? key,
    required this.fem,
    required this.ffem,
  }) : super(key: key);

  final double fem;
  final double ffem;

  // Get instance of NewArrivalController
  final NewArrivalController newArrivalController =
      Get.find<NewArrivalController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 17),
      child: SizedBox(
        height: 270,
        child: Obx(() {
          if (newArrivalController.isLoading.value) {
            return SizedBox(
                width: double.infinity,
                height: 300,
                child: buildcatShimmerEfect());
          }

          if (newArrivalController.error.isNotEmpty) {
            return Center(child: Text(newArrivalController.error.value));
          }

          if (newArrivalController.newArrivals.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 100),
                const Center(
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
                itemCount: newArrivalController.newArrivals.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return ProductItemWidget(
                    fem: fem,
                    product: newArrivalController.newArrivals[index],
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
}
