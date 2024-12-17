// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:amanuel_glass/controller/auth_controller.dart';
import 'package:amanuel_glass/view/base/custom_button.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../../helper/colors.dart';
import '../../../model/product_model.dart';
import '../../../model/wish_list.dart';
import '../../base/product_item_widget.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({Key? key}) : super(key: key);

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  bool isGuest = true;
  SharedPreferences? sharedPreferences;
  // final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    isUserSignin();
  }

  Future<void> isUserSignin() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      isGuest = sharedPreferences?.getBool('isGuest') ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double baseHeight = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    double hfem = MediaQuery.of(context).size.height / baseHeight;
    double hffem = hfem * 0.97;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
        ),
        title: Text(
          'wish_list'.tr,
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        toolbarHeight: 70,
      ),

      body: Center(child: Text('wishlist')),
      // body: Get.find<AuthController>().userPhone == null
      // ? Center(
      //     child: SizedBox(
      //       width: 300,
      //       child: CustomButton(
      //         fem: 1.2 * fem,
      //         ffem: 0.8 * ffem,
      //         title: 'sign_in'.tr,
      //         onPressed: () {
      //           Get.back();
      //           Get.back();
      //         },
      //       ),
      //     ),
      //   )
      // : Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: StreamBuilder<WishList?>(
      //       stream: readWishList(),
      //       builder: (context, snap) {
      //         if (snap.connectionState == ConnectionState.waiting) {
      //           return Center(
      //             child: CircularProgressIndicator(
      //               color: MyColors.primary,
      //             ),
      //           );
      //         }

      //         if (!snap.hasData) {
      //           return Center(
      //             child: Text(
      //               "empty_wishlist".tr,
      //               style: const TextStyle(
      //                 color: Color.fromARGB(184, 138, 138, 138),
      //               ),
      //             ),
      //           );
      //         }

      //         final wishlist = snap.data;
      //         if (wishlist == null || wishlist.productId.isEmpty) {
      //           return Center(
      //             child: Text(
      //               "empty_wishlist".tr,
      //               style: const TextStyle(
      //                 color: Color.fromARGB(184, 138, 138, 138),
      //               ),
      //             ),
      //           );
      //         }

      //         return buildWishList(wishlist, fem, ffem);
      //       },
      //     ),
      //   ),
    );
  }

  // Stream<WishList?> readWishList() {
  //   final docWishlist = FirebaseFirestore.instance
  //       .collection('wishlist')
  //       .doc(Get.find<AuthController>().userPhone);
  //   return docWishlist.snapshots().map((snapshot) {
  //     if (snapshot.exists && snapshot.data() != null) {
  //       return WishList.fromMap(snapshot.data()!);
  //     }
  //     return null;
  //   });
  // }

  // Future<Product?> getProduct(String productId) async {
  //   try {
  //     final docProd =
  //         FirebaseFirestore.instance.collection('products').doc(productId);
  //     final snapshot = await docProd.get();
  //     if (snapshot.exists && snapshot.data() != null) {
  //       return Product.fromJson(snapshot.data()!);
  //     }
  //     return null;
  //   } catch (error) {
  //     return null;
  //   }
  // }

  // Widget buildWishList(WishList wishlist, double fem, double ffem) {
  //   return GridView.builder(
  //     itemCount: wishlist.productId.length,
  //     shrinkWrap: true,
  //     scrollDirection: Axis.vertical,
  //     physics: const BouncingScrollPhysics(),
  //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //       childAspectRatio: 10 / 13,
  //       crossAxisCount: 2,
  //     ),
  //     itemBuilder: (context, index) {
  //       final productId = wishlist.productId[index];
  //       return FutureBuilder<Product?>(
  //         future: getProduct(productId),
  //         builder: (context, snap) {
  //           if (snap.connectionState == ConnectionState.waiting) {
  //             return SizedBox(
  //               width: Get.width * 0.85,
  //               height: Get.height * 0.85,
  //               child: buildShimmerEfect(),
  //             );
  //           }

  //           if (!snap.hasData) {
  //             final docProd = FirebaseFirestore.instance
  //                 .collection('wishlist')
  //                 .doc(Get.find<AuthController>().userPhone);
  //             docProd.update({
  //               'productId': FieldValue.arrayRemove([productId]),
  //             });
  //             return const SizedBox();
  //           }

  //           final product = snap.data!;
  //           return buildProductList(product, fem, ffem);
  //         },
  //       );
  //     },
  //   );
  // }

  Widget buildProductList(Product product, double fem, double ffem) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 17),
      child: ProductItemWidget(
        fem: fem,
        product: product,
        ffem: ffem,
        fromwishlist: true,
      ),
    );
  }

  Widget buildShimmerEfect() => Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 50,
            child: Shimmer.fromColors(
              child: Container(
                width: 300,
                height: 35,
                color: const Color.fromARGB(255, 252, 4, 4),
              ),
              baseColor: const Color.fromARGB(255, 195, 195, 195),
              highlightColor: Colors.grey[300]!,
            ),
          ),
        ),
      );
}
