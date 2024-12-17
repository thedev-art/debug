import 'package:amanuel_glass/controller/auth_controller.dart';
import 'package:amanuel_glass/dashboard_screen.dart';
import 'package:amanuel_glass/helper/colors.dart';
import 'package:amanuel_glass/helper/dimension.dart';
// import 'package:amanuel_glass/helper/dimensions.dart';
import 'package:amanuel_glass/view/base/custom_textfield.dart';
// import 'package:amanuel_glass/view/otp/otp_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../components/custom_snackbar.dart';

class SignInBody extends StatefulWidget {
  const SignInBody({Key? key}) : super(key: key);

  @override
  State<SignInBody> createState() => _SignInBodyState();
}

class _SignInBodyState extends State<SignInBody> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    focusListner();
  }

  void focusListner() {
    _phoneController.addListener(() {
      AuthController.instance.stopLoader();
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => !AuthController.instance.isWaitingForOTP.value
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 35,
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Welcome Back",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Enter your phone number ",
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 80,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimensions.RADIUS_SMALL),
                            color: Theme.of(context).cardColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[200] ?? Colors.grey,
                                spreadRadius: 1,
                                blurRadius: 5,
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(width: 50),
                                    const Text('+251'),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: CustomTextField(
                                        hintText: 'Enter your phone ',
                                        controller: _phoneController,
                                        focusNode: _phoneFocus,
                                        nextFocus: _phoneFocus,
                                        inputType: TextInputType.phone,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          AuthController.instance.sendOTP(
                                            _phoneController,
                                            '+251',
                                          );
                                        },
                                        child: Container(
                                          height: 45,
                                          width: 45,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            gradient: LinearGradient(
                                              colors: [
                                                MyColors.primary,
                                                Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ],
                                            ),
                                          ),
                                          child: Obx(
                                            () => !AuthController
                                                    .instance.isLoading.value
                                                ? const Icon(
                                                    Icons.arrow_forward,
                                                    color: Colors.white,
                                                    size: 20,
                                                  )
                                                : const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child:
                                                        CircularProgressIndicator
                                                            .adaptive(
                                                      valueColor:
                                                          AlwaysStoppedAnimation(
                                                              Colors.white),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        const SizedBox(height: 80),
                        GestureDetector(
                          onTap: () async {
                            final pref = await SharedPreferences.getInstance();
                            await pref.setBool('isGuest', true);
                            // Get.to(() => DashboardScreen(pageIndex: 0));
                          },
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '${'Continue as'.tr} ',
                                  style: TextStyle(
                                      color: Theme.of(context).disabledColor),
                                ),
                                TextSpan(
                                  text: 'Guest'.tr,
                                  style: TextStyle(color: MyColors.primary),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        : const SizedBox());
  }
}
