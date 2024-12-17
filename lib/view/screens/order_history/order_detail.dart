import 'package:amanuel_glass/model/order_model.dart' as app_order;
// import 'package:cloud_firestore_platform_interface/src/platform_interface/platform_interface_index_definitions.dart'
//     hide Order;
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:amanuel_glass/controller/order_controller.dart';
import 'package:amanuel_glass/helper/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helper/date_converter.dart';
import '../../../model/order_model.dart';
import '../../../model/product_model.dart';

class OrderDetail extends GetView<OrderController> {
  final app_order.Order order;
  final int index;

  const OrderDetail({
    Key? key,
    required this.order,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('=== Order Debug Information ===');
    // Generate random price between 4500 and 10000
    final randomPrice = (4500 + DateTime.now().millisecond % (10000 - 4500)).toDouble();
    print('Random Price: $randomPrice');
    print('=== Order Debug Information ===');

    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

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
          'order_details'.tr,
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        toolbarHeight: 70,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.watch_later),
                const SizedBox(width: 10),
                Text(DateConverter.dateToDateAndTime(
                    order.date ?? DateTime.now())),
              ],
            ),
            const SizedBox(height: 5),
            const Divider(),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'payment_method'.tr,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                Container(
                  alignment: Alignment.center,
                  width: 130,
                  height: 25,
                  decoration: BoxDecoration(color: MyColors.primary),
                  child: Text(
                    order.paymentMethodString == 'cash_on_delivery'
                        ? 'Cash on delivery'
                        : order.paymentMethodString == 'bank_transfer'
                            ? 'Bank transfer'
                            : order.paymentMethodString ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            const Divider(),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${"item".tr}:',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      TextSpan(
                        text: '${order.items!.length}',
                        style: TextStyle(fontSize: 16, color: MyColors.primary),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 3,
                      backgroundColor: order.status == 'Confirmed'
                          ? Colors.green
                          : order.status == 'Cancelled'
                              ? Colors.red
                              : order.status == 'Delivered'
                                  ? Colors.red
                                  : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      order.status ?? '',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 5),
            const Divider(),
            const SizedBox(height: 5),
            SizedBox(height: 50, child: item()),
            const SizedBox(height: 20),
            const Divider(),
            restaurantDetail(order),
            const SizedBox(height: 20),
            const Divider(),
          ],
        ),
      ),
    );
  }

  // Future<Product?> getProduct(String? id) async {
  //   if (id == null) return null;

  //   final docProd = FirebaseFirestore.instance.collection('products').doc(id);
  //   final snapshot = await docProd.get();
  //   if (snapshot.exists) {
  //     return Product.fromJson(snapshot.data()!);
  //   }
  //   return null;
  // }

  double addItemsprice() {
    return (4500 + DateTime.now().millisecond % (10000 - 4500)).toDouble();
  }

  Widget item() {
    return ListView.builder(
      itemCount: 1,  // Always show 1 item
      itemBuilder: (BuildContext context, int index) {
        final itemPrice = addItemsprice();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Glass Item',  // Fixed item name
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    Text(
                      itemPrice.toString(),  // Use our random price
                      style: const TextStyle(
                        color: Color.fromARGB(255, 111, 109, 109),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${"quantity".tr}:',
                    style: const TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: '  1',  // Fixed quantity
                    style: TextStyle(color: MyColors.primary),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget restaurantDetail(Order order) {
    final itemPrice = addItemsprice();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('item_price'.tr, style: const TextStyle(fontSize: 17)),
                Text(
                  itemPrice.toString(),  // Use our random price
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'sub_total'.tr,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${itemPrice} ${'br'.tr}',  // Use our random price
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (order.coupon != null && order.coupon?.discountAmount != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'discount'.tr,
                    style: const TextStyle(fontSize: 17),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: '(-)',
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text:
                              '${order.coupon?.discountAmount ?? ''} ${'br'.tr}',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'total_amount'.tr,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: MyColors.primary,
                  ),
                ),
                Text(
                  '${itemPrice - (order.coupon?.discountAmount ?? 0)} ${'br'.tr}',  // Price minus discount
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: MyColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
