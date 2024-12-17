import 'package:amanuel_glass/helper/dimension.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:amanuel_glass/controller/auth_controller.dart';
import 'package:amanuel_glass/dashboard_screen.dart';
import 'package:amanuel_glass/helper/colors.dart';
// import 'package:amanuel_glass/helper/dimensions.dart';
import 'package:amanuel_glass/view/base/custom_button.dart';
import 'package:amanuel_glass/view/base/custom_textfield.dart';
import 'package:amanuel_glass/view/components/custom_snackbar.dart';
import 'package:amanuel_glass/view/screens/cart/payment_dialog.dart';
// import 'package:amanuel_glass/view/screens/cart/payment_metod_dialog.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controller/localization_controller.dart';
// import '../../../helper/app_constants.dart';

class SignUpScreen extends StatefulWidget {
  final String? phone;
  final bool fromCheckout;
  final PaymentMethodDialog? paymentMethodDialog;
  const SignUpScreen({
    super.key,
    this.phone,
    this.fromCheckout = false,
    this.paymentMethodDialog,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isLoading = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _nameFocus.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.fromCheckout
          ? AppBar(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
            )
          : null,
      body: GetBuilder<AuthController>(builder: (authController) {
        return isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0, right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            PopupMenuButton(
                              child: Row(
                                children: [
                                  Icon(Icons.language, color: MyColors.primary),
                                  const SizedBox(width: 5),
                                  Text('language'.tr),
                                ],
                              ),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  onTap: () {
                                    Get.find<LocalizationController>()
                                        .setLanguage(const Locale('am', 'ET'));
                                  },
                                  value: 3,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Icon(
                                          Icons.g_translate,
                                          size: 20,
                                          color: MyColors.primary,
                                        ),
                                      ),
                                      const Text("አማርኛ"),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  onTap: () {
                                    Get.find<LocalizationController>()
                                        .setLanguage(const Locale('en', 'US'));
                                  },
                                  value: 4,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Icon(
                                          Icons.g_translate,
                                          size: 20,
                                          color: MyColors.primary,
                                        ),
                                      ),
                                      const Text("English"),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      widget.fromCheckout
                          ? const SizedBox(height: 20)
                          : const SizedBox(),
                      widget.fromCheckout
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.all(10),
                              child: Image.asset(
                                'assets/images/amanuel-glass.jpg',
                                height: 200,
                                width: 500,
                                //color: MyColors.primary,
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                widget.fromCheckout
                                    ? "fill_info".tr
                                    : 'welcome'.tr,
                                style: const TextStyle(fontSize: 15),
                              ),
                              const SizedBox(height: 30),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.RADIUS_SMALL),
                                  color: Colors.white,
                                  // color: Theme.of(context).cardColor,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey[200] ?? Colors.grey,
                                        spreadRadius: 1,
                                        blurRadius: 5)
                                  ],
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 5),
                                  child: Column(
                                    children: [
                                      const SizedBox(width: 50),
                                      CustomTextField(
                                        hintText: 'enter_name'.tr,
                                        controller: _nameController,
                                        focusNode: _nameFocus,
                                        nextFocus: _phoneFocus,
                                        inputType: TextInputType.name,
                                      ),
                                      const SizedBox(
                                        height: 30,
                                        child: Divider(color: Colors.grey),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: CustomTextField(
                                              hintText: 'enter_phone'.tr,
                                              controller: _phoneController,
                                              focusNode: _phoneFocus,
                                              nextFocus: _phoneFocus,
                                              inputType: TextInputType.phone,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 60),
                                child: CustomButton(
                                  fem: 1,
                                  ffem: 1,
                                  title: isLoading ? 'Loading...' : 'continue'.tr,
                                  onPressed: () async {
                                    //!
                                    var logger = Logger();
                                    logger.d(
                                        'phone number: ${_phoneController.text.trim()}');
                                    String _numberWithCountryCode =
                                        '+251' + _phoneController.text.trim();
                                    bool _isValid = Get.find<AuthController>()
                                            .isValidPhoneNumber(
                                                _phoneController.text.trim()) &&
                                        _phoneController.text.trim().length == 10;

                                    if (_numberWithCountryCode.isEmpty) {
                                      showCustomSnackBar('enter_phone'.tr);
                                    } else if (!_isValid) {
                                      showCustomSnackBar(
                                          'Invalid phone number please start with 09 ,07,or check your phone number'
                                              .tr);
                                    } else {
                                      setState(() {
                                        isLoading = true;
                                      });

                                      final pref =
                                          await SharedPreferences.getInstance();

                                      pref.setBool('isFirstOpen', false);

                                      await AuthController.instance
                                          .storeUser(_nameController.text,
                                              _phoneController.text)
                                          .then((value) async {
                                        if (widget.fromCheckout) {
                                          Get.back();
                                          // if (widget.paymentMethodDialog != null){}
                                          // Get.bottomSheet(PaymentMethodDialog(
                                          //   cartList: widget
                                          //       .paymentMethodDialog!.cartList,
                                          //   totalAmount: widget
                                          //       .paymentMethodDialog!.totalAmount,
                                          //   discountPrice: widget
                                          //       .paymentMethodDialog!
                                          //       .discountPrice,
                                          //   additionalLocation: widget
                                          //       .paymentMethodDialog!
                                          //       .additionalLocation,
                                          // ));
                                        } else {
                                          Get.offAll(const DashboardScreen());
                                        }

                                        setState(() {
                                          isLoading = false;
                                        });
                                      }).catchError((error) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        showCustomSnackBar(error);
                                      });
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(height: 50),
                              widget.fromCheckout
                                  ? const SizedBox()
                                  : GestureDetector(
                                      onTap: () async {
                                        final pref =
                                            await SharedPreferences.getInstance();

                                        Get.to(() => const DashboardScreen(
                                              pageIndex: 0,
                                            ));
                                      },
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '${'continue_as'.tr} ',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .disabledColor),
                                            ),
                                            TextSpan(
                                              text: 'guest'.tr,
                                              style: TextStyle(
                                                  color: MyColors.primary),
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
                ),
              );
      }),
    );
  }

  // Future<bool> checkUserIsActive(String phone) async {
  //   final userDoc = FirebaseFirestore.instance.collection('users').doc(phone);
  //   final snapshot = await userDoc.get();

  //   if (snapshot.exists) {
  //     final data = snapshot.data();
  //     return data?['is_active'] ?? false;
  //   }
  //   return false;
  // }
}
