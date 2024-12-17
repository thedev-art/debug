import 'package:amanuel_glass/helper/colors.dart';
import 'package:amanuel_glass/helper/dimension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustomSnackBar(String message, {bool isError = true}) {
  if (message != null && message.isNotEmpty) {
    GetSnackBar snackbar = GetSnackBar(
      backgroundColor: isError ? Colors.red : MyColors.primary,
      message: message,
      maxWidth: 500,
      duration: Duration(seconds: 2),
      snackStyle: SnackStyle.FLOATING,
      margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      borderRadius: Dimensions.RADIUS_SMALL,
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutQuad,
      reverseAnimationCurve: Curves.easeInQuad,
    );

    if (Get.isSnackbarOpen) {
      Get.back();
      Future.delayed(Duration(milliseconds: 300), () {
        Get.showSnackbar(snackbar);
      });
    } else {
      Get.showSnackbar(snackbar);
    }
  }
}
