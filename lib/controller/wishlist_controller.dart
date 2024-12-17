// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/product_model.dart';
import '../model/wish_list.dart';
import '../view/components/custom_snackbar.dart';
import 'auth_controller.dart';

class WishListController extends GetxController {
  final RxList<Product> wishlist = RxList<Product>();
  final RxBool isGuest = true.obs;
  final RxBool isInWishList = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkisGuest();
  }

  Future<void> checkisGuest() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    isGuest.value = pref.getBool('isGuest') ?? true;
  }

  void updateWishListStatus(bool value) {
    isInWishList.value = value;
  }

  // Future<void> createWishList(Product productModel, bool isRemoving) async {
  //   final userPhone = Get.find<AuthController>().userPhone;
  //   if (userPhone == null) {
  //     showCustomSnackBar('User not logged in');
  //     return;
  //   }

  //   final DocumentReference docWishlist =
  //       FirebaseFirestore.instance.collection('wishlist').doc(userPhone);

  //   try {
  //     final DocumentSnapshot doc = await docWishlist.get();

  //     if (doc.exists) {
  //       final data = doc.data() as Map<String, dynamic>?;
  //       if (data == null) return;

  //       final List<dynamic> productIds =
  //           data['productId'] as List<dynamic>? ?? [];

  //       if (isRemoving && productIds.contains(productModel.id)) {
  //         await docWishlist.update({
  //           'productId': FieldValue.arrayRemove([productModel.id]),
  //         });
  //         updateWishListStatus(false);
  //         if (productIds.length == 1) {
  //           await docWishlist.delete();
  //         }
  //         showCustomSnackBar('product removed from wishlist'.tr);
  //       } else if (productIds.contains(productModel.id)) {
  //         await docWishlist.update({
  //           'productId': FieldValue.arrayRemove([productModel.id]),
  //         });
  //         updateWishListStatus(false);
  //         showCustomSnackBar('product removed from wishlist'.tr);
  //       } else {
  //         await docWishlist.update({
  //           'productId': FieldValue.arrayUnion([productModel.id]),
  //         });
  //         updateWishListStatus(true);
  //         showCustomSnackBar('added_to_wishlist'.tr, isError: false);
  //       }
  //     } else {
  //       final wishlist = WishList(userId: userPhone);
  //       final json = wishlist.toMap();

  //       await docWishlist.set(json);
  //       await docWishlist.update({
  //         'productId': FieldValue.arrayUnion([productModel.id]),
  //       });
  //       updateWishListStatus(true);
  //       showCustomSnackBar('added_to_wishlist'.tr, isError: false);
  //     }
  //   } catch (e) {
  //     showCustomSnackBar('Error updating wishlist');
  //   }
  // }
}
