// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:amanuel_glass/controller/auth_controller.dart';
import 'package:amanuel_glass/controller/payment_controller.dart';
import 'package:amanuel_glass/helper/colors.dart';
import 'package:amanuel_glass/helper/dimension.dart';

import 'package:amanuel_glass/view/base/custom_button.dart';
import 'package:amanuel_glass/view/components/custom_appbar.dart';
import 'package:amanuel_glass/view/components/custom_snackbar.dart';
import 'package:amanuel_glass/view/components/socail_icon.dart';

import 'package:amanuel_glass/view/screens/profile/support_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpCenterScreen extends StatefulWidget {
  final String? userName;

  const HelpCenterScreen({
    Key? key,
    this.userName,
  }) : super(key: key);

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  bool _isLoading = false;
  Map<String, dynamic>? _documentData;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    getBusinessInfo();
    super.initState();
  }

  Future<void> getBusinessInfo() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final businessInfo = Get.find<PaymentController>().businessInfo.value;
      if (businessInfo != null) {
        setState(() {
          _documentData = {
            'address': businessInfo.address,
            'phone': businessInfo.phone,
            'email': businessInfo.email,
            'telegram': businessInfo.telegram,
            'facebook': businessInfo.facebook,
            'instagram': businessInfo.instagram,
            'tiktok': businessInfo.tiktok,
            'youtube': businessInfo.youtube,
          };
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching business info: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'help_center'.tr,
        onBackPressed: () {
          Get.back();
        },
        isBackButtonExist: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        width: 1170,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Column(children: [
                  if (_documentData != null)
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'contact_us'.tr,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        SupportButton(
                          icon: Icons.location_on,
                          title: 'address'.tr,
                          color: Colors.blue,
                          info: _documentData?['address'] ?? 'no data found',
                          onTap: () {},
                        ),
                        const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        SupportButton(
                          icon: Icons.phone_android,
                          title: 'call'.tr,
                          color: Colors.red,
                          info: _documentData?['phone'] ?? 'no data found',
                          onTap: () async {
                            final phone = _documentData?['phone'];
                            if (phone != null) {
                              final url = 'tel:$phone';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                showCustomSnackBar(
                                    '${'can_not_launch'.tr} $phone');
                              }
                            }
                          },
                        ),
                        const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        SupportButton(
                          icon: Icons.mail,
                          title: 'email'.tr,
                          color: Colors.green,
                          info: _documentData?['email'] ?? 'no data found',
                          onTap: () {
                            final email = _documentData?['email'];
                            if (email != null) {
                              final Uri emailLaunchUri = Uri(
                                scheme: 'mailto',
                                path: email,
                              );
                              launch(emailLaunchUri.toString());
                            }
                          },
                        ),
                        const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                      ],
                    ),
                  Row(
                    children: [
                      Text(
                        'our_social'.tr,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  SocialMediaAccountsRow(),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
