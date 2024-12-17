import 'package:amanuel_glass/controller/auth_controller.dart';
import 'package:amanuel_glass/helper/colors.dart';
import 'package:amanuel_glass/view/base/custom_button.dart';
import 'package:amanuel_glass/view/screens/order_history/order_item_list.dart';
// import 'package:amanuel_glass/view/screens/order_history/order_item_list.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../base/custom_button.dart';
import 'history_item_list.dart';

class OrderHistoryTabBar extends StatefulWidget {
  const OrderHistoryTabBar({Key? key}) : super(key: key);

  @override
  _OrderHistoryTabBarState createState() => _OrderHistoryTabBarState();
}

class _OrderHistoryTabBarState extends State<OrderHistoryTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late SharedPreferences sharedPreferences;
  // final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double baseHeight = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      // body: Center(
      //   child: SizedBox(
      //     height: 50,
      //     width: 300,
      //     child: CustomButton(
      //       fem: 1 * 0.6,
      //       ffem: 1 * 0.2,
      //       title: 'sign_in'.tr,
      //       onPressed: () {
      //         Get.back();
      //       },
      //     ),
      //   ),
      // ),
      body: FutureBuilder<bool>(
        future: Get.find<AuthController>().isPhoneRegistered(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(
                color: MyColors.primary,
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final bool isPhoneRegistered = snapshot.data ?? false;

            if (isPhoneRegistered) {
              return Column(
                children: [
                  Container(
                    child: TabBar(
                      controller: _tabController,
                      indicatorWeight: 3,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: MyColors.primary,
                      tabs: <Tab>[
                        Tab(
                          child: Text(
                            'running'.tr,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'history'.tr,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        OrderItemList(),
                        HistoryItemList(),
                      ],
                    ),
                  ),
                ],
              );
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "sign_in_to_continue".tr,
                  style: const TextStyle(fontSize: 17),
                ),
                const SizedBox(height: 30),
                Center(
                  child: SizedBox(
                    height: 50,
                    width: 300,
                    child: CustomButton(
                      fem: 1 * 0.6,
                      ffem: 1 * 0.2,
                      title: 'sign_in'.tr,
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
