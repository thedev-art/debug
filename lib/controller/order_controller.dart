// import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'dart:math';

import 'package:amanuel_glass/controller/auth_controller.dart';
import 'package:amanuel_glass/controller/location_controller.dart';
import 'package:amanuel_glass/model/order_model.dart';
import 'package:amanuel_glass/model/product_model.dart';
import 'package:amanuel_glass/services/api_services.dart';
import 'package:amanuel_glass/view/components/custom_snackbar.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderController extends GetxController {
  final LocationController locationController = Get.find<LocationController>();
  final RxList<Order> orderController = RxList<Order>();
  final RxList<Order> orderhistoryController = RxList<Order>();
  final RxList<Order> _allOrders = RxList<Order>();
  final RxBool isLoading = false.obs;

  var logger = Logger();

  @override
  void onInit() {
    super.onInit();
    ever(orderController, (_) {
      update();
    });
    _fetchAllOrders();
  }

  Future<void> _fetchAllOrders() async {
    try {
      isLoading.value = true;
      final userPhone = Get.find<AuthController>().userPhone;

      final response = await Get.find<APIServices>()
          .getRequest('orders/?customer=$userPhone');

      if (response.statusCode == 200) {
        List<dynamic> ordersData;
        if (response.data is Map) {
          ordersData = response.data['data'] ?? response.data['orders'] ?? [];
          logger.d('ordersData: $ordersData');
        } else if (response.data is List) {
          ordersData = response.data;
        } else {
          throw Exception('Unexpected response format');
        }
        _allOrders.value = ordersData
            .map((item) => Order(
                  id: item['id'],
                  orderid: item['id']?.toString(),
                  date: item['created_at'] != null
                      ? DateTime.parse(item['created_at'])
                      : null,
                  totalPrice: item['order_amount'],
                  status: item['order_status']?.toString(),
                  items: item['order_items'] != null
                      ? (item['order_items'] as List)
                          .map((i) => Product.fromJson(i['product']))
                          .toList()
                      : null,
                  discount: item['price_before_discount'] != null
                      ? item['price_before_discount'] - item['order_amount']
                      : 0,
                  userPhone: item['customer']?['phone_number']?.toString(),
                  paymentMethodString: item['payment_method']?.toString(),
                ))
            .toList();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> placeOrder(Order order) async {
    try {
      logger.d("Starting order placement..."); 
      logger.d("Delivery Address Model: ${order.deliveryAddress?.toJson()}"); // Log the address model

      Map<String, dynamic> payload = {
        "name": order.user?.name ?? '',
        "phone": order.userPhone ?? '',
        "products": order.items?.map((item) => {
              "id": item.id,
              "quantity": item.quantity,
            }).toList(),
        "coupon_title": order.coupon?.code ?? '',
        "payment_method": order.paymentMethodString ?? 'cash_on_delivery',
        "payment_method_details": {
          "payment_type": order.paymentMethod?.paymentType ?? 'cash_on_delivery',
          "receipt_photo": order.paymentMethod?.receiptPhoto ?? '',
        },
        "delivery_address": order.deliveryAddress?.toJson() ?? {}, // Use the model's toJson method
        "additional_address": order.additionalLocation ?? '',
      };

      logger.i("Sending order with payload: $payload");

      final response = await Get.find<APIServices>().postRequest(
        'orders/',
        payload: payload,
      );

      logger.i("Order API Response Status: ${response.statusCode}");
      logger.d("Order API Response Data: ${response.data}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        logger.i('Order placed successfully');
      } else {
        logger.e('Failed to place order. Status code: ${response.statusCode}');
        throw Exception('Failed to place order');
      }
    } catch (e) {
      logger.e('Error placing order: $e', error: e, stackTrace: StackTrace.current);
      rethrow;
    }
  }

  Future<void> runningOrders() async {
    if (_allOrders.isEmpty) await _fetchAllOrders();
    orderController.value = _allOrders
        .where((order) => order.status?.toLowerCase() == 'pending')
        .toList();
    update();
  }

  Future<void> deliveredOrders() async {
    if (_allOrders.isEmpty) await _fetchAllOrders();
    orderhistoryController.value = _allOrders
        .where((order) =>
            order.status?.toLowerCase() == 'delivered' ||
            order.status?.toLowerCase() == 'cancelled')
        .toList();
    update();
  }
}
