import 'package:amanuel_glass/helper/colors.dart';
import 'package:amanuel_glass/helper/dimension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/localization_controller.dart';
import '../../helper/app_constants.dart';
import '../../model/language_model.dart';

class LanguageWidget extends StatelessWidget {
  final LanguageModel languageModel;
  final LocalizationController localizationController;
  final int index;
  final double fem;
  final double ffem;

  const LanguageWidget({
    Key? key,
    required this.languageModel,
    required this.localizationController,
    required this.index,
    required this.fem,
    required this.ffem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        localizationController.setSelectIndex(index);
      },
      child: Container(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        margin: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(7),
          boxShadow: [
            BoxShadow(
                color: Colors.grey[Get.isDarkMode ? 800 : 200]!,
                blurRadius: 5,
                spreadRadius: 1)
          ],
        ),
        child: Stack(children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Radio<LanguageModel>(
                    fillColor: MaterialStateProperty.all(MyColors.primary),
                    value: localizationController.languages[index],
                    groupValue: AppConstants
                        .languages[localizationController.selectedIndex],
                    onChanged: (LanguageModel? value) {
                      if (value != null) {
                        onChanged(value);
                      }
                    },
                  ),
                  SizedBox(width: 8 * fem),
                  Text(
                    languageModel.languageName,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14 * ffem,
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ]),
      ),
    );
  }

  void onChanged(LanguageModel value) {
    localizationController.setSelectIndex(index);
  }
}
