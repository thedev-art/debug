import 'package:amanuel_glass/helper/colors.dart';
import 'package:amanuel_glass/helper/dimension.dart';
// import 'package:amanuel_glass/helper/dimensions.dart';
import 'package:amanuel_glass/helper/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileBgWidget extends StatelessWidget {
  final Widget headerSection;
  final Widget mainWidget;
  final bool backButton;
  final bool editButton;
  ProfileBgWidget(
      {required this.mainWidget,
      required this.headerSection,
      required this.backButton,
      required this.editButton});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Stack(clipBehavior: Clip.none, children: [
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 260,
            color: Color(0xFFF5F5F5),
          ),
        ),
        Positioned(
            bottom: 10,
            left: -6,
            child: Image.asset(Images.ellipse1,
                color: MyColors.primary.withOpacity(0.7))),
        Positioned(
            right: -2,
            child: Image.asset(
              Images.ellipse2,
              color: MyColors.primary.withOpacity(0.7),
            )),
        backButton
            ? Positioned(
                top: MediaQuery.of(context).padding.top,
                left: 10,
                child: IconButton(
                  icon:
                      Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
                  onPressed: () => Get.back(),
                ),
              )
            : SizedBox(),
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.only(top: Dimensions.PADDING_SIZE_LARGE),
            child: headerSection,
          ),
        ),
      ]),
      Expanded(
        child: mainWidget,
      ),
    ]);
  }
}
