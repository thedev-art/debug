import 'package:amanuel_glass/helper/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedbackDialog extends StatelessWidget {
  final TextEditingController controller;
  final bool isEmpty;

  const FeedbackDialog({
    Key? key,
    required this.controller,
    this.isEmpty = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          hintText: 'Enter your feedback (አስተያየትዎን ያስቀምጡ)'.tr,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyColors.primary),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
        ),
        maxLines: 5,
        maxLength: 4096,
        textInputAction: TextInputAction.done,
        validator: (String? text) {
          if (text == null || text.isEmpty) {
            return 'Enter';
          }
          return null;
        },
      ),
    );
  }
}
