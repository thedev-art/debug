import 'package:amanuel_glass/dashboard_screen.dart';
import 'package:amanuel_glass/view/components/custom_appbar.dart';
import 'package:amanuel_glass/view/screens/order_history/order_history_tab_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderHistory extends StatelessWidget {
  final bool fromSuccess;
  const OrderHistory({Key? key, this.fromSuccess = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onBackPressed: () => Get.back(),
        title: 'order'.tr,
        isBackButtonExist: false,
      ),
      body: OrderHistoryTabBar(),
    );
  }
}
