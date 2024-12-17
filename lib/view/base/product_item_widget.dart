import 'package:amanuel_glass/helper/images.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:amanuel_glass/controller/cart_controller.dart';
import 'package:amanuel_glass/helper/colors.dart';
// import 'package:amanuel_glass/helper/dimensions.dart';
import 'package:amanuel_glass/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

// import '../../controller/wishlist_controller.dart';

class ProductItemWidget extends StatelessWidget {
  const ProductItemWidget({
    Key? key,
    required this.fem,
    required this.product,
    required this.ffem,
    this.fromwishlist = false,
  }) : super(key: key);

  final double fem;
  final Product product;
  final double ffem;
  final bool fromwishlist;

  @override
  Widget build(BuildContext context) {
    if (product == null) {
      return Container();
    }

    final Product productModel = Product(
      id: product.id,
      name: product.name,
      price: product.price,
      isActive: product.isActive,
      coverImage: product.coverImage,
      discount: product.discount ?? 0,
      discountType: product.discountType,
      // categoryId: product.categoryId,
    );

    return InkWell(
      onTap: () {
        Get.toNamed('productdetail', arguments: {'prodmodel': product});
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 10 * fem, 0 * fem),
            // margin: EdgeInsets.fromLTRB(1, 2, 4, 4),
            width: 170 * fem,
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    return AspectRatio(
                      aspectRatio: 1.3,
                      child: Container(
                        width: double.infinity,
                        height: 134 * fem,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(6 * fem),
                            topRight: Radius.circular(6 * fem),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(6 * fem),
                            topRight: Radius.circular(6 * fem),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: product.coverImage != null &&
                                    product.coverImage!.isNotEmpty
                                ? product.coverImage!.startsWith('http')
                                    ? product.coverImage!
                                    : 'https://amanuelglass.com${product.coverImage}'
                                : 'https://picsum.photos/200/300',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            placeholder: (context, url) =>
                                Image.asset(Images.placeholder, fit: BoxFit.cover),
                            errorWidget: (context, url, error) =>
                                Image.asset(Images.placeholder, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                GetBuilder<CartController>(builder: (cartController) {
                  if (cartController == null) {
                    return Container();
                  }

                  final int quantity =
                      cartController.getQuantity(productModel).toInt();
                  double discountPrice = 0;

                  if ((product.discount ?? 0) > 0) {
                    if (product.discountType == 'amount') {
                      discountPrice = (product.discount ?? 0).toDouble();
                    } else if (product.discountType == 'percent') {
                      discountPrice =
                          ((product.price ?? 0) * (product.discount ?? 0)) /
                              100;
                    }
                  }

                  final double totalPrice =
                      (product.price ?? 0) - discountPrice;

                  return Container(
                    padding: const EdgeInsets.only(top: 15),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xfff9f9fb),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(6 * fem),
                        bottomLeft: Radius.circular(6 * fem),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 8 * fem),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name ?? '',
                                style: TextStyle(
                                  fontSize: 12 * ffem,
                                  fontWeight: FontWeight.w400,
                                  height: 1.2125 * ffem / fem,
                                  color: const Color(0xff393f42),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  if ((product.discount ?? 0) > 0) ...[
                                    Text(
                                      '${product.price} ${'br'.tr}',
                                      style: TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        fontSize: 14 * ffem,
                                        fontWeight: FontWeight.w600,
                                        height: 1.2125 * ffem / fem,
                                        color: const Color(0xff393f42),
                                      ),
                                    ),
                                    Text(
                                      '  ${totalPrice.toInt()} ${'br'.tr}',
                                      style: TextStyle(
                                        fontSize: 14 * ffem,
                                        fontWeight: FontWeight.w600,
                                        height: 1.2125 * ffem / fem,
                                        color: const Color(0xff393f42),
                                      ),
                                    ),
                                  ] else
                                    Text(
                                      '${product.price} ${'br'.tr}',
                                      style: TextStyle(
                                        fontSize: 14 * ffem,
                                        fontWeight: FontWeight.w600,
                                        height: 1.2125 * ffem / fem,
                                        color: const Color(0xff393f42),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (quantity != 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 10, left: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: (() => cartController
                                      .removeFromCart(productModel)),
                                  child: Image.asset(
                                    'assets/images/group-25.png',
                                    width: 34 * fem,
                                    height: 34 * fem,
                                  ),
                                ),
                                SizedBox(width: 15),
                                Text(cartController
                                    .getQuantity(productModel)
                                    .toString()),
                                SizedBox(width: 15),
                                InkWell(
                                  onTap: () =>
                                      cartController.addToCart(productModel),
                                  child: Image.asset(
                                    'assets/images/group-23.png',
                                    width: 34 * fem,
                                    height: 34 * fem,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          TextButton(
                            onPressed: () {
                              cartController.addToCart(productModel);
                              cartController.isInCartFun(productModel);
                            },
                            child: Container(
                              width: double.infinity,
                              height: 31 * fem,
                              decoration: BoxDecoration(
                                color: MyColors.primary,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Center(
                                child: Text(
                                  'add_to_cart'.tr,
                                  style: TextStyle(
                                    fontSize: 12 * ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.2125 * ffem / fem,
                                    color: const Color(0xffffffff),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          if (fromwishlist)
            Positioned(
              top: 0,
              right: 0,
              child: InkWell(
                // onTap: () => Get.find<WishListController>()
                // .createWishList(productModel, true),
                child: CircleAvatar(
                  radius: 20 * fem,
                  backgroundColor: const Color.fromARGB(255, 228, 228, 228),
                  child: Image.asset(
                    'assets/images/auto-group-ayzo-filed.png',
                    width: 20,
                    // height: 20,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
