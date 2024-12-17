import 'dart:convert';

import 'package:amanuel_glass/view/screens/cart/cart_item_list.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:amanuel_glass/controller/auth_controller.dart';
import 'package:amanuel_glass/controller/cart_controller.dart';
import 'package:amanuel_glass/view/base/custom_button.dart';
// import 'package:amanuel_glass/view/base/not_logged_in_screen.dart';
import 'package:amanuel_glass/view/components/custom_appbar.dart';
import 'package:amanuel_glass/view/components/custom_snackbar.dart';
import 'package:amanuel_glass/view/screens/cart/payment_dialog.dart';
import 'package:amanuel_glass/view/screens/sign_up/sign_up_screen.dart';
// import 'package:amanuel_glass/view/screens/cart/cart_list_item.dart';
// import 'package:amanuel_glass/view/screens/cart/payment_metod_dialog.dart';
// import 'package:amanuel_glass/view/screens/sign_in/components/sign_in_body.dart';
// import 'package:amanuel_glass/view/screens/sign_in/sign_in_screen.dart';
// import 'package:amanuel_glass/view/screens/sign_up/sign_up_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controller/location_controller.dart';
import '../../../helper/colors.dart';
import '../../../model/coupon_model.dart';

class CartDetailsScreen extends StatefulWidget {
  @override
  State<CartDetailsScreen> createState() => _CartDetailsScreenState();
}

class _CartDetailsScreenState extends State<CartDetailsScreen> {
  final TextEditingController coupontxtcontroller = TextEditingController();
  bool isGuest = true;
  final locationTextFieldController = TextEditingController();
  // final FirebaseAuth auth = FirebaseAuth.instance;
  late SharedPreferences sharedPreferences;
  GlobalKey<FormState> couponKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    isUserSignin();
  }

  Future<void> isUserSignin() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      isGuest = sharedPreferences.getBool('isGuest') ?? true;
    });
  }

  Future<bool> checkUserIsActive(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    final userPhone = prefs.getString("PHONE");

    if (userPhone != null && userPhone.isNotEmpty) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double baseHeight = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    double hfem = MediaQuery.of(context).size.height / baseHeight;
    double hffem = hfem * 0.97;

    return GetBuilder<CartController>(builder: (cartController) {
      double totalAmount = 0.00;
      double itemPrice = 0.00;
      int productDiscount = 0;
      int totalPrductQuantity = 0;
      //!
      // if (cartController.cartItems.isNotEmpty) {
      //   cartController.cartItems.forEach((product) {
      //     itemPrice += (product.price ?? 0) * product.price;
      //     totalPrductQuantity += product.quantity;
      //     if ((product.discount ?? 0) > 0) {
      //       if ((product.discount ?? 0) > 0) {
      //         if (product.discountType == 'amount') {
      //           productDiscount +=
      //               ((product.discount ?? 0) * product.quantity).toInt();
      //         } else if (product.discountType == 'percent') {
      //           productDiscount +=
      //               ((product.price ?? 0) * (product.discount ?? 0) / 100)
      //                   .toInt();
      //         }
      //       }
      //     }
      //   });
      //   totalAmount += itemPrice;
      // }
      if (cartController.cartItems.isNotEmpty) {
        cartController.cartItems.forEach((product) {
          // Convert all values to double for price calculations
          double productPrice = (product.price ?? 0).toDouble();
          double productQuantity = (product.quantity ?? 0).toDouble();

          // Calculate item price correctly
          itemPrice += productPrice * productQuantity;

          // Convert quantity to int for count
          totalPrductQuantity += productQuantity.toInt();

          if ((product.discount ?? 0) > 0) {
            double discountValue = (product.discount ?? 0).toDouble();

            if (product.discountType == 'amount') {
              productDiscount += (discountValue * productQuantity).toInt();
            } else if (product.discountType == 'percent') {
              productDiscount +=
                  ((productPrice * discountValue / 100) * productQuantity)
                      .toInt();
            }
          }
        });
        totalAmount += itemPrice;
      }

      MyDisc? discount = myDiscount(totalAmount);

      return Scaffold(
          appBar: CustomAppBar(
            title: 'your_cart'.tr,
            isBackButtonExist: true,
            onBackPressed: () => Get.back(),
          ),
          body: cartController.cartItems.length == 0
              ? Center(child: Text('your_cart_is_empty'.tr))
              : Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          children: [
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Text(
                                      'deliver_to'.tr,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 10),
                                              title: Center(
                                                  child: Text(
                                                      'Your current location')),
                                              content: SizedBox(
                                                height: 190,
                                                width: 1.2 * fem,
                                                child: Column(children: [
                                                  ListTile(
                                                    onTap: () async {
                                                      SharedPreferences
                                                          sharedPreferences =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      sharedPreferences.setString(
                                                          'myAddress',
                                                          Get.find<
                                                                  LocationController>()
                                                              .address
                                                              .value);
                                                      Navigator.pop(context);
                                                    },
                                                    leading: CircleAvatar(
                                                        radius: 20,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        child: Icon(
                                                          Icons.location_on,
                                                          color:
                                                              MyColors.primary,
                                                        )),
                                                    subtitle: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8.0,
                                                              top: 0,
                                                              bottom: 0),
                                                      child: Text(Get.find<
                                                              LocationController>()
                                                          .address
                                                          .value),
                                                    ),
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            1.0),
                                                  ),
                                                  Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 25,
                                                      ),
                                                      Text(
                                                        'Isn\'t your current location accurate?',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: TextFormField(
                                                          controller:
                                                              locationTextFieldController,
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                'Enter additional address',
                                                            border: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                                borderSide:
                                                                    BorderSide()),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              borderSide:
                                                                  BorderSide(
                                                                color: MyColors
                                                                    .primary,
                                                              ),
                                                            ),
                                                            filled: true,
                                                            fillColor: Colors
                                                                .grey[200],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ]),
                                              ),
                                              actions: [
                                                CustomButton(
                                                    fem: 0.8 * fem,
                                                    ffem: ffem,
                                                    title: 'Set',
                                                    onPressed: () async {
                                                      if (locationTextFieldController
                                                              .text !=
                                                          null) {
                                                        SharedPreferences
                                                            sharedPreferences =
                                                            await SharedPreferences
                                                                .getInstance();
                                                        sharedPreferences.setString(
                                                            'myAddress',
                                                            locationTextFieldController
                                                                .text);
                                                        Navigator.pop(context);
                                                      } else {
                                                        SharedPreferences
                                                            sharedPreferences =
                                                            await SharedPreferences
                                                                .getInstance();
                                                        sharedPreferences.setString(
                                                            'myAddress',
                                                            Get.find<
                                                                    LocationController>()
                                                                .address
                                                                .value);
                                                        Navigator.pop(context);
                                                      }
                                                    })
                                              ],
                                            );
                                          });
                                    },
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Obx(() => Text(
                                              Get.find<LocationController>()
                                                  .address
                                                  .value,
                                              style: TextStyle(
                                                fontSize: 12 * ffem,
                                                fontWeight: FontWeight.w500,
                                                height: 1.2125 * ffem / fem,
                                                color: Color(0xff393f42),
                                              ),
                                            )),
                                        Container(
                                          width: 12 * fem,
                                          height: 12 * fem,
                                          child: Image.asset(
                                            'assets/icons/iconly-light-arrow-down-2-fCD.png',
                                            width: 12 * fem,
                                            height: 12 * fem,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                            Divider(),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                Text('Products'.tr,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Expanded(
                              flex: cartController.cartItems.length * 2,
                              child: CartItemListWidget(
                                cartItems: cartController.cartItems,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            cartController.cartItems.length > 1
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Icon(Icons.arrow_downward)],
                                  )
                                : SizedBox(),
                            SizedBox(
                              height: 15,
                            ),
                            Flexible(
                              flex: 5,
                              child: Form(
                                key: couponKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('coupon'.tr,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                        )),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: TextFormField(
                                            controller: coupontxtcontroller,
                                            decoration: InputDecoration(
                                              hintText: 'enter_coupon'.tr,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 228, 228, 228))),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 228, 228, 228))),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                  color: MyColors.primary,
                                                ),
                                              ),
                                              filled: true,
                                              fillColor: Colors.grey[200],
                                            ),
                                            validator: (value) {
                                              String? msg;
                                              if (value?.isEmpty ?? true) {
                                                msg =
                                                    'enter coupon code please';
                                              }
                                              return msg;
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Obx(
                                          () => ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                minimumSize: Size(70, 45),
                                                textStyle:
                                                    TextStyle(fontSize: 18),
                                                backgroundColor:
                                                    MyColors.primary,
                                                foregroundColor: Colors.white,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 10),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                              onPressed: () async {
                                                if (Get.find<CartController>().isCouponbtnTaped == true) {
                                                  Get.find<CartController>().clearCouponData();
                                                  coupontxtcontroller.clear();
                                                  showCustomSnackBar('coupon removed', isError: true);
                                                } else {
                                                  if (couponKey.currentState!.validate()) {
                                                    double totalAmountValue = discount?.total == null
                                                        ? totalAmount - productDiscount
                                                        : (discount!.total - productDiscount);

                                                    try {
                                                      await Get.find<CartController>().applyforCoupon(
                                                        coupontxtcontroller.text,
                                                        totalAmountValue,
                                                      );
                                                      // If successful, the UI will update through GetX state management
                                                    } catch (e) {
                                                      // Show error message if coupon application fails
                                                      showCustomSnackBar(
                                                        e.toString().contains('400') 
                                                          ? 'Invalid coupon code' 
                                                          : 'Failed to apply coupon. Please try again.',
                                                        isError: true
                                                      );
                                                    }
                                                  }
                                                }
                                              },
                                              child: Get.find<CartController>()
                                                          .isCouponbtnTaped ==
                                                      true
                                                  ? Text('X')
                                                  : Text('apply'.tr)),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
          bottomNavigationBar: cartController.cartItems.isNotEmpty
              ? Container(
                  height: 155,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        productDiscount > 0
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                    Container(
                                      child: Text(
                                        'Product Discount',
                                        style: TextStyle(
                                          fontSize: 14 * ffem,
                                          fontWeight: FontWeight.w400,
                                          height: 1.2125 * ffem / fem,
                                          color:
                                              Color.fromARGB(255, 49, 53, 55),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${productDiscount}' + ' ' + "br".tr,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontSize: 14 * ffem,
                                        fontWeight: FontWeight.w500,
                                        height: 1.2125 * ffem / fem,
                                        color: Color(0xff393f42),
                                      ),
                                    ),
                                  ])
                            : Container(),
                        SizedBox(
                          height: 5,
                        ),
                        discount?.discPrice != null
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                    Container(
                                      child: Text(
                                        'Coupon Discount',
                                        style: TextStyle(
                                          fontSize: 14 * ffem,
                                          fontWeight: FontWeight.w400,
                                          height: 1.2125 * ffem / fem,
                                          color:
                                              Color.fromARGB(255, 49, 53, 55),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${discount?.discPrice}' + ' ' + "br".tr,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontSize: 14 * ffem,
                                        fontWeight: FontWeight.w500,
                                        height: 1.2125 * ffem / fem,
                                        color: Color(0xff393f42),
                                      ),
                                    ),
                                  ])
                            : Container(),
                        SizedBox(height: 10),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text(
                                  'total_price'.tr,
                                  style: TextStyle(
                                    fontSize: 18 * ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.2125 * ffem / fem,
                                    color: Color.fromARGB(255, 49, 53, 55),
                                  ),
                                ),
                              ),
                              Text(
                                discount?.total == null
                                    ? '${totalAmount - productDiscount} ${'br'.tr}'
                                    : '${(discount!.total - productDiscount)} ${'br'.tr}',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 18 * ffem,
                                  fontWeight: FontWeight.w500,
                                  height: 1.2125 * ffem / fem,
                                  color: const Color(0xff393f42),
                                ),
                              ),
                            ]),
                        SizedBox(height: 10),
                        CustomButton(
                          fem: fem,
                          ffem: 60,
                          title: 'continue_for_payments'.tr,
                          onPressed: () async {
                            print("clicked");
                            print("=== Payment Dialog Data ===");
                            print("Cart Items: ${cartController.cartItems.map((item) => {
                              'name': item.name,
                              'price': item.price,
                              'quantity': item.quantity,
                              'discount': item.discount,
                              'discountType': item.discountType,
                            }).toList()}");
                            print("Total Amount: ${discount?.total ?? totalAmount}");
                            print("Discount Price: ${discount?.discPrice ?? 0}");
                            print("Additional Location: ${locationTextFieldController.text}");
                            print("========================");

                            final userRef = Get.find<AuthController>().userPhone;

                            if (await InternetConnectionChecker().hasConnection) {
                              if (await Get.find<AuthController>()
                                  .isPhoneRegistered()) {
                                if (await checkUserIsActive(
                                    Get.find<AuthController>().userPhone ??
                                        '')) {
                                  Get.bottomSheet(
                                    PaymentMethodDialog(
                                      cartList: cartController.cartItems,
                                      totalAmount:
                                          discount?.total ?? totalAmount,
                                      discountPrice: discount?.discPrice ?? 0,
                                      additionalLocation:
                                          locationTextFieldController.text,
                                    ),
                                    isScrollControlled: true,
                                    isDismissible: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20)),
                                    ),
                                    backgroundColor: Colors.white,
                                  );
                                } else {
                                  Get.to(SignUpScreen());
                                }
                              } else {
                                Get.to(SignUpScreen(
                                  fromCheckout: true,
                                  paymentMethodDialog: PaymentMethodDialog(
                                    cartList: cartController.cartItems,
                                    totalAmount: discount?.total ?? totalAmount,
                                    discountPrice: discount?.discPrice ?? 0,
                                    additionalLocation:
                                        locationTextFieldController.text,
                                  ),
                                ));
                              }
                            } else {
                              showCustomSnackBar(
                                  'please check your internet connection!');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                )
              : null);
    });
  }

  MyDisc? myDiscount(double price) {
    Coupon? coupon = Get.find<CartController>().coupon;
    if (coupon == null) return null;

    double discPric = 0;
    String amount = '';
    double total = 0;

    if (coupon.discountType == 'percent') {
      double amo = (price * coupon.discountAmount) / 100;
      total = price - amo;
      discPric = price - total;
      amount = '${coupon.discountAmount} %';
    } else if (coupon.discountType == 'amount') {
      amount = '${coupon.discountAmount} birr';
      total = price - coupon.discountAmount;
      discPric = price - total;
    }

    return MyDisc(
      iniprice: price,
      discAmount: amount,
      discPrice: discPric,
      total: total,
    );
  }

  void update() {
    Get.forceAppUpdate();
  }
}

class MyDisc {
  final double iniprice;
  final double total;
  final String discAmount;
  final double discPrice;
  final bool applied;

  const MyDisc({
    required this.iniprice,
    required this.total,
    required this.discAmount,
    required this.discPrice,
    this.applied = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'iniprice': iniprice,
      'total': total,
      'discAmount': discAmount,
      'discPrice': discPrice,
      'applied': applied,
    };
  }

  factory MyDisc.fromMap(Map<String, dynamic> map) {
    return MyDisc(
      iniprice: map['iniprice'] as double,
      total: map['total'] as double,
      discAmount: map['discAmount'] as String,
      discPrice: map['discPrice'] as double,
      applied: map['applied'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory MyDisc.fromJson(String source) =>
      MyDisc.fromMap(json.decode(source) as Map<String, dynamic>);
}
