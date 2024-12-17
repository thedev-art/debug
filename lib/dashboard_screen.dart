import 'dart:async';

import 'package:amanuel_glass/controller/auth_controller.dart';
import 'package:amanuel_glass/controller/cart_controller.dart';
import 'package:amanuel_glass/helper/colors.dart';
import 'package:amanuel_glass/view/screens/cart/cart_screen.dart';
import 'package:amanuel_glass/view/screens/homescreens/home_screen.dart';
import 'package:amanuel_glass/view/screens/order_history/order_history_screen.dart';
import 'package:amanuel_glass/view/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'controller/location_controller.dart';
// import 'view/screens/cart/cart_screen.dart';
// import 'view/screens/home/home_screen.dart';
// import 'view/screens/order_history/order_history_screen.dart';
// import 'view/screens/profile/profile_screen.dart';
import 'package:icons_plus/icons_plus.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;

  const DashboardScreen({Key? key, this.pageIndex = 0}) : super(key: key);
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    Home(),
    CartDetailsScreen(),
    OrderHistory(),
    ProfileScreen()
  ];

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    Get.find<LocationController>().getLocation();
    // isUserSignin();

    super.initState();
  }

  // Future<bool> isUserSignin() async {
  //   return await Get.find<AuthController>().isPhoneRegistered();
  // }

  @override
  Widget build(BuildContext context) {
    bool _canExit = false;
    final cartController = Get.put(CartController());
    return WillPopScope(
      onWillPop: () async {
        if (_canExit) {
          SystemNavigator.pop();
          return true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Press back again to exit'.tr,
                style: TextStyle(color: Colors.white)),
            behavior: SnackBarBehavior.floating,
            backgroundColor: MyColors.primary,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.all(3),
          ));
          _canExit = true;
          Timer(Duration(seconds: 2), () {
            _canExit = false;
          });
          return false;
        }
      },
      child: Scaffold(
        body: Obx(
          () =>
              DashboardScreen
                  ._widgetOptions[cartController.selectedIndex.value] ??
              CircularProgressIndicator(),
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    Icon(EvaIcons.shopping_bag),
                    Obx(() {
                      final cartCount =
                          Get.find<CartController>().cartItems.length;
                      return cartCount > 0
                          ? Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  cartCount.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : SizedBox();
                    }),
                  ],
                ),
                label: 'Cart',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.history_toggle_off_outlined),
                activeIcon: Icon(Icons.history_toggle_off),
                label: 'History',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Account',
              ),
            ],
            selectedItemColor: MyColors.primary,
            selectedIconTheme: IconThemeData(color: MyColors.primary),
            showUnselectedLabels: true,
            currentIndex: cartController.selectedIndex.value,
            onTap: (index) {
              cartController.changeIndex(index);
            },
          ),
        ),
      ),
    );
  }
}
