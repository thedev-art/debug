import 'package:amanuel_glass/controller/auth_controller.dart';
import 'package:amanuel_glass/controller/localization_controller.dart';
import 'package:amanuel_glass/helper/colors.dart';
import 'package:amanuel_glass/helper/dimension.dart';
// import 'package:amanuel_glass/helper/dimensions.dart';
import 'package:amanuel_glass/helper/images.dart';
import 'package:amanuel_glass/language/choise_language_screen.dart';
import 'package:amanuel_glass/view/base/custom_button.dart';
import 'package:amanuel_glass/view/screens/profile/help_center.dart';
// import 'package:amanuel_glass/view/screens/language/choose_language_screen.dart';
// import 'package:amanuel_glass/view/screens/profile/help_center_screen.dart';
import 'package:amanuel_glass/view/screens/profile/list_item.dart';
import 'package:amanuel_glass/view/screens/profile/profile_background_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controller/location_controller.dart';
import 'package:amanuel_glass/helper/size_config.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String myAddress = '';
  bool isGuest = false;
  bool isLoading = false;
  String? userName;

  @override
  void initState() {
    super.initState();
    getCurrentAddress();
    isUserSignin();
  }

  Future<bool> isUserSignin() async {
    return await Get.find<AuthController>().isPhoneRegistered();
  }

  void getCurrentAddress() {
    myAddress = Get.find<LocationController>().address.value;
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double baseHeight = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    double hfem = MediaQuery.of(context).size.height / baseHeight;
    double hffem = hfem * 0.97;
    String? phoneNumber = Get.find<AuthController>().userPhone;

    return Scaffold(
      backgroundColor: Colors.white,
      body: ProfileBgWidget(
        backButton: false,
        editButton: true,
        headerSection: !Get.find<AuthController>().isLoggedIn
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    width: 300,
                    child: CustomButton(
                      fem: fem * 0.6,
                      ffem: ffem * 0.2,
                      title: 'sign_in'.tr,
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                ],
              )
            : Text("NotloGGEDIN"),
        // : StreamBuilder<DocumentSnapshot>(
        //     stream: FirebaseFirestore.instance
        //         .collection('users')
        //         .doc(phoneNumber)
        //         .snapshots(),
        //     builder: (BuildContext context,
        //         AsyncSnapshot<DocumentSnapshot> snapshot) {
        //       if (snapshot.connectionState == ConnectionState.waiting) {
        //         return Center(
        //           child: CircularbanncargressIndicator(
        //             color: MyColors.primary,
        //           ),
        //         );
        //       }
        //       if (!snapshot.hasData || !snapshot.data!.exists) {
        //         return Padding(
        //           padding: const EdgeInsets.only(left: 30),
        //           child: ClipOval(
        //             child: Column(
        //               children: [
        //                 FadeInImage.assetNetwork(
        //                   placeholder: Images.placeholder,
        //                   image: '',
        //                   height: 120,
        //                   width: 120,
        //                   fit: BoxFit.cover,
        //                   imageErrorBuilder: (c, o, s) => Image.asset(
        //                     Images.placeholder,
        //                     height: 120,
        //                     width: 120,
        //                     fit: BoxFit.cover,
        //                   ),
        //                 ),
        //                 ElevatedButton(
        //                   onPressed: () {
        //                     Get.toNamed('editprofile');
        //                   },
        //                   child: Text('edit'.tr),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         );
        //       }

        //       final userData =
        //           snapshot.data!.data() as Map<String, dynamic>?;
        //       if (userData != null) {
        //         userName = userData['name'] as String?;
        //       }

        //       return Padding(
        //         padding: const EdgeInsets.all(20),
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             Stack(
        //               children: [
        //                 Align(
        //                   alignment: Alignment.center,
        //                   child: ClipOval(
        //                     child: FadeInImage.assetNetwork(
        //                       placeholder: Images.placeholder,
        //                       image: userData?['profile_url'] ?? '',
        //                       height: 100,
        //                       width: 100,
        //                       fit: BoxFit.cover,
        //                       imageErrorBuilder: (c, o, s) => Image.asset(
        //                         Images.placeholder,
        //                         height: 100,
        //                         width: 100,
        //                         fit: BoxFit.cover,
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //                 Positioned(
        //                   right: 30,
        //                   top: 36,
        //                   child: IconButton(
        //                     icon: Image.asset(
        //                       Images.edit,
        //                       color: MyColors.primary,
        //                     ),
        //                     onPressed: () => Get.toNamed('editprofile'),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //             const SizedBox(height: 15),
        //             Text(
        //               userData?['name'] ?? '',
        //               style: const TextStyle(
        //                 fontWeight: FontWeight.w600,
        //                 fontSize: 24,
        //               ),
        //             ),
        //             const SizedBox(height: 5),
        //             Text(
        //               userData?['phone_number'] ?? '',
        //               style: const TextStyle(
        //                 fontWeight: FontWeight.w400,
        //                 fontSize: 16,
        //               ),
        //             ),
        //             const SizedBox(height: 5),
        //           ],
        //         ),
        //       );
        //     },
        //   ),
        mainWidget: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: Column(
                children: [
                  ListItem(
                    title: 'address'.tr,
                    iconColor: MyColors.primary,
                    subTitle: Get.find<LocationController>().address.value,
                    onTap: () {},
                    icons: Icons.location_on,
                    showArrow: false,
                  ),
                  ListItem(
                    title: 'language'.tr,
                    iconColor: MyColors.primary,
                    onTap: () {
                      Get.to(() => ChooseLanguageScreen(fromMenu: true));
                    },
                    icons: Icons.translate_outlined,
                    showArrow: true,
                  ),
                  ListItem(
                    title: 'help_center'.tr,
                    iconColor: MyColors.primary,
                    onTap: () {
                      Get.to(() => HelpCenterScreen(userName: userName));
                    },
                    icons: Icons.help_center_rounded,
                    showArrow: true,
                  ),
                ],
              ),
            ),
            if (phoneNumber != null && phoneNumber.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                child: ListItem(
                  title: 'log_out'.tr,
                  iconColor: Colors.red,
                  onTap: () => _showLogoutDialog(context),
                  icons: Icons.logout,
                  showArrow: true,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'want_to_logout'.tr,
                style: const TextStyle(fontSize: 17),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        minimumSize: const Size(80, 35),
                        backgroundColor: MyColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: Text('no'.tr),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        // Navigator.pop(context);
                        // await Get.find<AuthController>().clearSharedData();
                        // Get.offAllNamed('/');
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: Text('yes'.tr),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
