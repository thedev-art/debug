import 'package:amanuel_glass/helper/dimension.dart';
// import 'package:amanuel_glass/helper/dimensions.dart';
import 'package:amanuel_glass/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAlertDialog extends StatelessWidget {
  final String description;
  final VoidCallback onOkPressed;
  final bool isSuccess;
  const CustomAlertDialog({
    super.key,
    required this.description,
    required this.onOkPressed,
    this.isSuccess = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_LARGE)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.PADDING_SIZE_LARGE,
            vertical: Dimensions.PADDING_SIZE_SMALL),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(isSuccess ? Icons.check_circle : Icons.warning_amber_rounded,
                  color: isSuccess ? Colors.green : Colors.red, size: 80),
              Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: isSuccess
                      ? Text(
                          'you_placed_the_order_successfully'.tr,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 23),
                        )
                      : Text(
                          'order_failed'.tr,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 23),
                        )),
              Padding(
                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: Dimensions.FONT_SIZE_LARGE),
                ),
              ),
              isSuccess
                  ? TextButton(
                      onPressed: onOkPressed,
                      child: CustomButton(
                        onPressed: onOkPressed,
                        fem: 1.1,
                        ffem: 1,
                        title: 'go_to_history'.tr,
                      ),
                    )
                  : TextButton(
                      onPressed: () => Get.back(),
                      child: CustomButton(
                        onPressed: onOkPressed,
                        fem: 1.1,
                        ffem: 1,
                        title: 'Ok',
                      ),
                    )
            ]),
      ),
    );
  }
}
