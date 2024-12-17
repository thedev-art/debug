// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:amanuel_glass/model/coupon_model.dart';
import 'package:get/get.dart';

class CouponsController extends GetxController {
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxList<Coupon> coupons = RxList<Coupon>([]);
  final RxBool isLoading = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    // fetchCoupons();
  }

  // Future<void> fetchCoupons() async {
  //   isLoading.value = true;
  //   try {
  //     final snapshot = await _firestore
  //         .collection('coupons')
  //         .where('expiration_date', isGreaterThan: DateTime.now())
  //         .where('isActive', isEqualTo: true)
  //         .get();
  //     final List<Coupon> fetchedCoupons =
  //         snapshot.docs.map((doc) => Coupon.fromSnapshot(doc)).toList();
  //     coupons.assignAll(fetchedCoupons);
  //   } catch (e) {
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
}
