// import 'package:cloud_firestore/cloud_firestore.dart';

class Coupon {
  String? id;
  String? code;
  dynamic discountAmount;
  String? discountType;
  String? expirationDate;
  int? maxUser;
  int? minCartList;
  int? minOrderAmount;
  int? usage;
  List<Map<String, dynamic>>? users;

  Coupon({
    this.id,
    this.code,
    this.discountAmount,
    this.discountType,
    this.expirationDate,
    this.maxUser,
    this.minCartList,
    this.minOrderAmount,
    this.users,
    this.usage,
  });

  factory Coupon.fromSnapshot(dynamic snapshot) {
    if (snapshot == null) return Coupon();

    final data = snapshot
        ? snapshot.data() as Map<String, dynamic>
        : snapshot as Map<String, dynamic>;

    return Coupon(
      id: data['coupon_id'] as String?,
      code: data['code'] as String?,
      discountAmount: data['discount_amount'],
      discountType: data['discount_type'] as String?,
      expirationDate: data['expiration_date']?.toString(),
      maxUser: data['max_user'] as int?,
      minCartList: data['min_cart_list'] as int?,
      minOrderAmount: data['min_order_amount'] as int?,
      usage: data['usage'] as int?,
    );
  }
}
