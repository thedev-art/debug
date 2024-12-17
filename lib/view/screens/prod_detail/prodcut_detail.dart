import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:amanuel_glass/controller/cart_controller.dart';
import 'package:amanuel_glass/helper/colors.dart';
import 'package:amanuel_glass/model/product_model.dart';
// import 'package:amanuel_glass/view/base/animated_icon_button.dart';
import 'package:amanuel_glass/view/components/product_detail_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:url_launcher/url_launcher.dart';

class ProductDetail extends StatelessWidget {
  final Product productModel;
  final bool fromBanner;

  const ProductDetail({
    Key? key,
    required this.productModel,
    this.fromBanner = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return GetBuilder<CartController>(builder: (controller) {
      int quantity = controller.getQuantity(productModel).toInt();

      return Scaffold(
        appBar: fromBanner
            ? null
            : AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  onPressed: () {
                    try {
                      Navigator.of(context).pop();
                    } catch (e) {
                      print('Error navigating back: $e');
                    }
                  },
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.black,
                ),
                title: Text(
                  'product_details'.tr,
                  style: const TextStyle(color: Colors.black),
                ),
                centerTitle: true,
                toolbarHeight: 70,
                actions: [
                  GestureDetector(
                    onTap: () {
                      print("click");
                      Get.back();
                      //!this was commented
                      controller.navigateToCartScreen();
                    },
                    child: badges.Badge(
                      // position: badges.BadgePosition.topEnd(top: 0, end: -10),
                      position: badges.BadgePosition.topEnd(top: -5, end: -10),
                      badgeContent: Text(
                        quantity.toString(),
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
                  const SizedBox(width: 20),
                ],
              ),
        body: Column(
          children: [
            Stack(
              children: [
                CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: productModel.coverImage ?? '',
                  placeholder: (context, url) =>
                      Image.asset('assets/images/placeholder.jpg'),
                  errorWidget: (context, url, error) =>
                      Image.asset('assets/images/placeholder.jpg'),
                  height: 350,
                  width: double.infinity,
                ),
              ],
            ),
            ProductDetailCard(
              productModel: productModel,
            )
          ],
        ),
        bottomNavigationBar:
            GetBuilder<CartController>(builder: (cartController) {
          int quantity = cartController.getQuantity(productModel).toInt();

          return SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  quantity != 0
                      ? Padding(
                          padding: const EdgeInsets.only(top: 10, left: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () =>
                                    cartController.removeFromCart(productModel),
                                child: Image.asset(
                                  'assets/images/group-25.png',
                                  width: 39 * fem,
                                  height: 39 * fem,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Text(cartController
                                  .getQuantity(productModel)
                                  .toString()),
                              const SizedBox(width: 15),
                              InkWell(
                                onTap: () =>
                                    cartController.addToCart(productModel),
                                child: Image.asset(
                                  'assets/images/group-23.png',
                                  width: 39 * fem,
                                  height: 39 * fem,
                                ),
                              ),
                            ],
                          ),
                        )
                      : OutlinedButton(
                          onPressed: () {
                            cartController.addToCart(productModel);
                            cartController.isInCartFun(productModel);
                          },
                          style: OutlinedButton.styleFrom(
                            elevation: 0,
                            minimumSize: Size(170 * fem, 48 * fem),
                            foregroundColor:
                                const Color.fromARGB(255, 224, 224, 224),
                            backgroundColor: MyColors.primary,
                          ),
                          child: Text(
                            'add_to_cart'.tr,
                            style: TextStyle(
                              fontSize: 18 * ffem,
                              color: Colors.white,
                            ),
                          ),
                        ),
                  OutlinedButton(
                    onPressed: () async {
                      try {
                        await Get.find<CartController>().buyNow(productModel);
                      } catch (e) {
                        print('Error in buy now: $e');
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      elevation: 0,
                      minimumSize: Size(170 * fem, 48 * fem),
                      foregroundColor: const Color.fromARGB(255, 224, 224, 224),
                      backgroundColor: MyColors.primary,
                    ),
                    child: Text(
                      'buy_now'.tr,
                      style: TextStyle(
                        fontSize: 18 * ffem,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      );
    });
  }
}
