import 'package:amanuel_glass/controller/order_controller.dart';
import 'package:amanuel_glass/helper/date_converter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../model/order_model.dart' as app_order;

class OrderItemList extends StatelessWidget {
  const OrderItemList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.find<OrderController>();

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: orderController.runningOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmerEffect();
            }

            return Obx(() {
              if (orderController.orderController.isEmpty) {
                return Center(
                  child: Text(
                    "no_running_orders".tr,
                    style: TextStyle(color: Color.fromARGB(184, 138, 138, 138)),
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                itemCount: orderController.orderController.length,
                itemBuilder: (context, index) {
                  final order = orderController.orderController[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: ListTile(
                      onTap: () {
                        Get.toNamed('orderdetail',
                            arguments: {'order': order, 'index': index});
                      },
                      leading: Text(
                        'Order ${index + 1}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      title: Text(
                        DateConverter.dateToDateAndTime(
                            order.date ?? DateTime.now()),
                      ),
                      subtitle: order.status != null
                          ? Text('${"status".tr}: ${order.status?.tr ?? ''}')
                          : null,
                      trailing: _statusIcon(status: order.status ?? ''),
                    ),
                  );
                },
              );
            });
          },
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return ListView.separated(
      padding: const EdgeInsets.all(8.0),
      itemCount: 5,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: const Color.fromARGB(255, 195, 195, 195),
        highlightColor: Colors.grey[200] ?? Colors.grey,
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 252, 4, 4),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _statusIcon({required String status}) {
    switch (status) {
      case 'Confirmed':
        return const Icon(Icons.check_circle, color: Colors.green);
      case 'Pending':
        return const Icon(Icons.watch_later, color: Colors.amber);
      case 'Delivered':
        return const Icon(Icons.done_all, color: Colors.blue);
      case 'Cancelled':
        return const Icon(Icons.cancel, color: Colors.red);
      default:
        return const Icon(Icons.fact_check, color: Colors.green);
    }
  }
}
