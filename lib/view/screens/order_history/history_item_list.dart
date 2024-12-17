import 'package:amanuel_glass/helper/date_converter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../controller/order_controller.dart';
import '../../../model/order_model.dart' as app_order;

class HistoryItemList extends StatelessWidget {
  const HistoryItemList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.find<OrderController>();

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: orderController.deliveredOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmerEffect();
            }

            return Obx(() {
              if (orderController.orderhistoryController.isEmpty) {
                return const Center(
                  child: Text(
                    "no_history_orders",
                    style: TextStyle(color: Color.fromARGB(184, 138, 138, 138)),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: orderController.orderhistoryController.length,
                itemBuilder: (context, index) {
                  final order = orderController.orderhistoryController[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: ListTile(
                      onTap: () {
                        Get.toNamed('orderhistorydetail',
                            arguments: {'order': order, 'index': index});
                      },
                      leading: Text(
                        '${"order".tr} ${index + 1}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      title: Text(
                        DateConverter.dateToDateAndTime(
                            order.date ?? DateTime.now()),
                      ),
                      subtitle: order.status != null
                          ? Text('${"status".tr}: ${(order.status ?? '').tr}')
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
      case 'Confiurmed':
        return const Icon(Icons.check_circle, color: Colors.green);
      case 'Pending':
        return const Icon(Icons.watch_later, color: Colors.amber);
      case 'Delivered':
        return const Icon(Icons.done_all, color: Colors.blue);
      case 'Cancelled':
        return const Icon(Icons.cancel, color: Colors.red);
      default:
        return const Icon(Icons.info_outline);
    }
  }
}
