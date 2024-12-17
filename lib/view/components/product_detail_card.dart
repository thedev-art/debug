// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:amanuel_glass/controller/auth_controller.dart';
import 'package:amanuel_glass/helper/colors.dart';
import 'package:amanuel_glass/model/product_model.dart';
import 'package:amanuel_glass/model/wish_list.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'custom_snackbar.dart';

class ProductDetailCard extends StatelessWidget {
  final Product productModel;
  const ProductDetailCard({Key? key, required this.productModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: leading(fem, ffem),
            ),
            SizedBox(height: 10 * fem),
          ],
        ),
      ),
    );
  }

  Widget buildWishlistIcon(double fem, Product productModel, String productId) {
    return Container();
    // final FirebaseAuth _auth = FirebaseAuth.instance;

    // return StreamBuilder<bool>(
    //   stream: checkWishlistCollectionExists(),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData && snapshot.data != null) {
    //       return StreamBuilder<DocumentSnapshot>(
    //         stream: FirebaseFirestore.instance
    //             .collection('wishlist')
    //             .doc(Get.find<AuthController>().userPhone)
    //             .snapshots(),
    //         builder: (context, snapshot) {
    //           if (snapshot.hasData) {
    //             Map<String, dynamic> data =
    //                 snapshot.data?.data() as Map<String, dynamic>;

    //             if (data != null && data.containsKey('productId')) {
    //               List productIds = List.from(data['productId']);
    //               if (productIds.contains(productId)) {
    //                 return CircleAvatar(
    //                   radius: 22 * fem,
    //                   backgroundColor: Color.fromRGBO(228, 228, 228, 1),
    //                   child: Image.asset(
    //                     'assets/images/auto-group-ayzo-filed.png',
    //                     width: 28,
    //                     height: 28,
    //                   ),
    //                 );
    //               } else {
    //                 return CircleAvatar(
    //                   radius: 22 * fem,
    //                   backgroundColor: Color.fromRGBO(228, 228, 228, 1),
    //                   child: Image.asset(
    //                     'assets/images/iconly-light-heart.png',
    //                     width: 28,
    //                     height: 28,
    //                     color: Color.fromARGB(255, 178, 176, 176),
    //                   ),
    //                 );
    //               }
    //             } else {
    //               return CircleAvatar(
    //                 radius: 22 * fem,
    //                 backgroundColor: Color.fromRGBO(228, 228, 228, 1),
    //                 child: Image.asset(
    //                   'assets/images/iconly-light-heart.png',
    //                   width: 28,
    //                   height: 28,
    //                   color: Color.fromARGB(255, 178, 176, 176),
    //                 ),
    //               );
    //             }
    //           } else {
    //             return CircularProgressIndicator(
    //               color: MyColors.primary,
    //             );
    //           }
    //         },
    //       );
    //     } else {
    //       return CircleAvatar(
    //         radius: 22 * fem,
    //         backgroundColor: Color.fromRGBO(228, 228, 228, 1),
    //         child: Image.asset(
    //           'assets/images/iconly-light-heart.png',
    //           width: 28,
    //           height: 28,
    //           color: Color.fromARGB(255, 178, 176, 176),
    //         ),
    //       );
    //     }
    //   },
    // );
  }

  // Stream<bool> checkWishlistCollectionExists() async* {
  //   final FirebaseAuth _auth = FirebaseAuth.instance;

  //   try {
  //     Stream<DocumentSnapshot> snapshotStream = FirebaseFirestore.instance
  //         .collection('wishlist')
  //         .doc(Get.find<AuthController>().userPhone)
  //         .snapshots();

  //     await for (DocumentSnapshot snapshot in snapshotStream) {
  //       yield snapshot.exists;
  //     }
  //   } catch (e) {
  //     yield false;
  //   }
  // }

  Widget leading(double fem, double ffem) {
    double discountPrice = 0;
    if ((productModel.discount ?? 0) > 0) {
      if (productModel.discountType == 'amount') {
        discountPrice = (productModel.discount ?? 0).toDouble();
      } else if (productModel.discountType == 'percent') {
        discountPrice =
            ((productModel.price ?? 0) * (productModel.discount ?? 0)) / 100;
      }
    }
    double totalPrice = (productModel.price ?? 0) - discountPrice;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productModel.name ?? '',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20 * ffem,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 7),
                  Row(
                    children: [
                      (productModel.discount ?? 0) > 0
                          ? Text(
                              '${productModel.price} ${'br'.tr}',
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 16 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.2125 * ffem / fem,
                                color: Color(0xff393f42),
                              ),
                            )
                          : Text(
                              '${productModel.price} ${'br'.tr}',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 18 * ffem,
                                color: Color.fromARGB(201, 0, 0, 0),
                              ),
                            ),
                      SizedBox(width: 10),
                      if ((productModel.discount ?? 0) != 0)
                        Text(
                          productModel.discountType == 'amount'
                              ? ' ${totalPrice.toInt()} ${'br'.tr}'
                              : '$totalPrice %',
                          style: TextStyle(
                            fontSize: 18 * ffem,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 48, 48, 48),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            InkResponse(
                radius: 30,
                splashColor: MyColors.primary.withAlpha(8),
                onTap: () async {
                  try {
                    if (Get.find<AuthController>().userPhone == null) {
                      showCustomSnackBar('please login to add item to wishlit');
                    } else {
                      //!firebase
                      // createWishList();
                    }
                  } catch (e) {
                    print('Error in wishlist tap: $e');
                  }
                },
                child: Container()
                //!fireabse
                // buildWishlistIcon(fem, productModel, productModel.id ?? ''),
                ),
          ],
        ),
        SizedBox(height: 40 * fem),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'description'.tr,
                  style: TextStyle(
                    color: Color.fromARGB(255, 73, 73, 73),
                    fontSize: 18 * ffem,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10 * fem),
            if ((productModel.description ?? '').isEmpty)
              Text(
                'No description found for this product',
                style: TextStyle(color: Colors.red),
              )
            else
              Text(
                productModel.description ?? '',
                style: TextStyle(
                  color: Color.fromARGB(255, 114, 114, 114),
                  fontSize: 18 * ffem,
                  wordSpacing: 3,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget pikColor(double fem, double ffem) {
    List<Color> myColor = [
      Color.fromARGB(255, 245, 219, 139),
      Color.fromARGB(255, 255, 169, 198),
      Color.fromARGB(255, 185, 251, 187),
      Color.fromARGB(255, 181, 222, 255),
      Color.fromARGB(255, 135, 135, 135),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Choose the color',
            style: TextStyle(
                color: Color.fromARGB(255, 148, 148, 148),
                fontSize: 18 * ffem,
                fontWeight: FontWeight.w600)),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          width: double.infinity,
          height: 40 * fem,
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  width: 65 * fem,
                  height: 8 * fem,
                  decoration: BoxDecoration(
                      color: myColor[index],
                      borderRadius: BorderRadius.circular(8)),
                );
              },
              separatorBuilder: (_, index) {
                return SizedBox(
                  width: 10,
                );
              }),
        ),
      ],
    );
  }

  // void createWishList() async {
  //   DocumentReference docWishlist = FirebaseFirestore.instance
  //       .collection('wishlist')
  //       .doc(Get.find<AuthController>().userPhone);
  //   DocumentSnapshot doc = await docWishlist.get();

  //   if (doc.exists) {
  //     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  //     if (data.containsKey('productId')) {
  //       List productIds = List.from(data['productId']);

  //       if (productIds.contains(productModel.id)) {
  //         await docWishlist.update({
  //           'productId': FieldValue.arrayRemove([productModel.id]),
  //         });
  //         if (productIds.length == 1) {
  //           await docWishlist.delete();
  //         }
  //         showCustomSnackBar('product removed from wishlist'.tr);
  //       } else {
  //         await docWishlist.update({
  //           'productId': FieldValue.arrayUnion([productModel.id]),
  //         });
  //         showCustomSnackBar('added_to_wishlist'.tr, isError: false);
  //       }
  //     } else {
  //       await docWishlist.update({
  //         'productId': [productModel.id],
  //       });
  //       showCustomSnackBar('added_to_wishlist'.tr, isError: false);
  //     }
  //   } else {
  //     final wishlist = WishList(userId: Get.find<AuthController>().userPhone);
  //     final json = wishlist.toMap();

  //     json['productId'] = [productModel.id];

  //     await docWishlist.set(json);

  //     showCustomSnackBar('added_to_wishlist'.tr, isError: false);
  //   }
  // }
}
