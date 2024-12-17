// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:amanuel_glass/controller/order_controller.dart';
import 'package:amanuel_glass/helper/colors.dart';
import 'package:amanuel_glass/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helper/date_converter.dart';
import '../../../model/order_model.dart' as app_order;
import '../../../model/product_model.dart';

class OrderHistoryDetail extends GetView<OrderController> {
  final app_order.Order order;
  final int index;

  const OrderHistoryDetail({
    Key? key,
    required this.order,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  'delivery'.tr,
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
                    'cash_on_delivery'.tr,
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
                        text: 'Item:',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      TextSpan(
                        text: '  ${order.items?.length ?? 0}',
                        style: TextStyle(fontSize: 16, color: MyColors.primary),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 3,
                      backgroundColor: Color.fromARGB(255, 18, 83, 20),
                    ),
                    const SizedBox(width: 8),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: order.status == 'Pending'
                                ? order.status
                                : order.status == 'Delivered'
                                    ? 'Delivered at '
                                    : '',
                            style: const TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: order.status == 'Pending'
                                ? ''
                                : order.status == 'Delivered'
                                    ? DateConverter.dateToDateAndTime(
                                        order.date ?? DateTime.now())
                                    : order.status,
                            style: TextStyle(
                              color: order.status == 'Delivered'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
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
            restaurantDetail(),
            const SizedBox(height: 20),
            const Divider(),
          ],
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: order.status != 'Cancelled',
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 60,
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (order.status == 'Pending')
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: SizedBox(
                            height: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('cancel_order'.tr),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        shadowColor: Colors.transparent,
                                        minimumSize: Size(100, 40),
                                        // primary: MyColors.primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4 * fem),
                                        ),
                                      ),
                                      child: Text('no'.tr),
                                    ),
                                    // ElevatedButton(
                                    //   onPressed: () async {
                                    //     final docUser = FirebaseFirestore
                                    //         .instance
                                    //         .collection('orders')
                                    //         .doc(order.orderId);

                                    //     await docUser
                                    //         .update({'status': 'Cancelled'});
                                    //     controller.orderController
                                    //         .removeAt(index);
                                    //     Navigator.pop(context);
                                    //     Get.back();
                                    //   },
                                    //   style: ElevatedButton.styleFrom(
                                    //     elevation: 0,
                                    //     shadowColor: Colors.transparent,
                                    //     minimumSize: Size(100, 40),
                                    //     // primary: MyColors.primary,
                                    //     shape: RoundedRectangleBorder(
                                    //       borderRadius:
                                    //           BorderRadius.circular(4 * fem),
                                    //     ),
                                    //   ),
                                    //   child: Text('yes'.tr),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      minimumSize: Size(320, 50),
                      // primary: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4 * fem),
                      ),
                    ),
                    child: Text('Cancel Order'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget item() {
    return ListView.builder(
      itemCount: order.items?.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        final item = order.items?[index];
        if (item == null) return const SizedBox();

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    if (item.coverImage != null) ...[
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(item.coverImage!),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name ?? '',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${item.price?.toStringAsFixed(2) ?? '0.00'} ${'br'.tr}',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 111, 109, 109),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'x${item.quantity ?? 1}',
                style: TextStyle(
                  color: MyColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget restaurantDetail() {
    final itemsTotal = addItemsPrice();
    final discount = order.discount ?? 0;
    final total = order.totalPrice ?? itemsTotal;

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
                  '${itemsTotal.toStringAsFixed(2)} ${'br'.tr}',
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
                  '${total.toStringAsFixed(2)} ${'br'.tr}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (discount > 0) ...[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'discount'.tr,
                    style: const TextStyle(fontSize: 17),
                  ),
                  Text(
                    '${discount.toStringAsFixed(2)} ${'br'.tr}',
                    style: const TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ],
          ],
        ),
      ],
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

  double addItemsPrice() {
    if (order.items == null) return 0;

    return order.items!.fold(0.0, (total, item) {
      final price = item.price ?? 0;
      final quantity = item.quantity ?? 1;
      return total + (price * quantity);
    });
  }
}
