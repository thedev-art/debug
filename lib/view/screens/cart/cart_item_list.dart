// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:amanuel_glass/helper/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:amanuel_glass/controller/cart_controller.dart';
import 'package:amanuel_glass/model/coupon_model.dart';
import 'package:amanuel_glass/model/product_model.dart';

import '../../../helper/colors.dart';
import '../../base/custom_button.dart';

// class CartItem {
//   final String name;
//   final double price;
//   final int quantity;
//   final String imageUrl;

//   CartItem(
//       {@required this.name,
//       @required this.price,
//       @required this.quantity,
//       @required this.imageUrl});
// }

class CartItemListWidget extends StatefulWidget {
  final List<Product> cartItems;

  const CartItemListWidget({
    Key? key,
    required this.cartItems,
  }) : super(key: key);

  @override
  _CartItemListWidgetState createState() => _CartItemListWidgetState();
}

class _CartItemListWidgetState extends State<CartItemListWidget> {
  final TextEditingController coupontxtcontroller = TextEditingController();

  MyDisc? myDiscount(double? initialPrice) {
    if (initialPrice == null) return null;

    Coupon? coupon = Get.find<CartController>().coupon;
    if (coupon == null) return null;

    double discPrice = 0;
    String amount = '';

    if (coupon.discountType == 'percent') {
      double amo = (initialPrice * coupon.discountAmount) / 100;
      discPrice = initialPrice - amo;
      amount = '${coupon.discountAmount} %';
    } else if (coupon.discountType == 'amount') {
      amount = '${coupon.discountAmount} birr';
      discPrice = initialPrice - coupon.discountAmount.toDouble();
    }

    return MyDisc(
      iniprice: initialPrice,
      discAmount: amount,
      discPrice: discPrice,
      total: initialPrice - discPrice,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (cartController) {
      return ListView.builder(
        itemCount: widget.cartItems.length,
        padding: EdgeInsets.zero,
        itemBuilder: (BuildContext context, int index) {
          Product item = widget.cartItems[index];
          // MyDisc? discount = myDiscount(item.initialPrice?.toDouble());

          return ListTile(
            leading: CachedNetworkImage(
              fit: BoxFit.contain,
              imageUrl: 'https://picsum.photos/500/500',
              placeholder: (context, url) => Image.asset(
                Images.placeholder,
              ),
              errorWidget: (context, url, error) => Image.asset(
                Images.placeholder,
              ),
            ),
            title: Text(item.name ?? ''),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Price: ${item.price ?? 0} ${'br'.tr}'),
                const SizedBox(height: 5),
                Text('${"quantity".tr}: ${item.quantity}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    cartController.removeFromCart(item);
                  },
                  icon: const Icon(Icons.remove),
                ),
                Text('${item.quantity}'),
                IconButton(
                  onPressed: () {
                    cartController.addToCart(item);
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}

class MyDisc {
  final double iniprice;
  final String discAmount;
  final double discPrice;
  final double total;
  final bool applied;

  const MyDisc({
    required this.iniprice,
    required this.discAmount,
    required this.discPrice,
    required this.total,
    this.applied = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'iniprice': iniprice,
      'discAmount': discAmount,
      'discPrice': discPrice,
      'total': total,
      'applied': applied,
    };
  }

  factory MyDisc.fromMap(Map<String, dynamic> map) {
    return MyDisc(
      iniprice: map['iniprice'] as double,
      discAmount: map['discAmount'] as String,
      discPrice: map['discPrice'] as double,
      total: map['total'] as double,
      applied: map['applied'] as bool,
    );
  }
}

/*class ApplyCoupon extends GetView<CartController> {
  final String text;
  final int index;
  const ApplyCoupon({Key key, this.text, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('coupons')
          .where('code', isEqualTo: text)
          .get(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text("Unable to get the data"),
          );
        }
        if (snapshot.data == null || snapshot.data.docs.isEmpty) {}

        Coupon coupon;

        if (snapshot.data.size > 0) {
          final doc = snapshot
              .data.docs.first; 

          final data = doc.data();
          coupon = Coupon(
            id: data['category_id'],
            discountAmount: data['discount_amount'],
            discountType: data['discount_type'],
            maxUser: data['max_user'],
            minCartList: data['min_cart_list'],
          );
        }
        if (coupon != null) {
          controller.coupon = coupon;
        }
        return Container();
      },
    );
  }
}
*/