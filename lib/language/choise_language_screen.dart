import 'package:amanuel_glass/helper/dimension.dart';
import 'package:amanuel_glass/view/base/custom_button.dart';
import 'package:amanuel_glass/view/components/custom_snackbar.dart';
import 'package:amanuel_glass/view/components/language_widget.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../controller/localization_controller.dart';
import '../../../helper/app_constants.dart';

class ChooseLanguageScreen extends StatelessWidget {
  final bool fromMenu;
  const ChooseLanguageScreen({super.key, this.fromMenu = false});

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return GetBuilder<LocalizationController>(
        builder: (localizationController) {
      return Scaffold(
        body: SafeArea(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
              child: Scrollbar(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: Center(
                  child: SizedBox(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                Dimensions.PADDING_SIZE_EXTRA_SMALL * 3),
                        child: Text(
                            localizationController.selectedIndex == 0
                                ? "Select language"
                                : localizationController.selectedIndex == 1
                                    ? "ቋንቋ ይምረጡ"
                                    : "选择语言",
                            style: TextStyle(
                                fontSize: 18 * ffem,
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                      ListView.builder(
                        itemCount: localizationController.languages.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => LanguageWidget(
                          languageModel:
                              localizationController.languages[index],
                          localizationController: localizationController,
                          index: index,
                          fem: fem,
                          ffem: ffem,
                        ),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                    ]),
              )),
            ),
          )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
              fem: 1.1 * fem,
              ffem: ffem,
              title: localizationController.selectedIndex == 0
                  ? "Save & Continue"
                  : "መዝግብ እና ቀጥል",
              onPressed: () async {
                if (localizationController.languages.length > 0 &&
                    localizationController.selectedIndex != -1) {
                  localizationController.setLanguage(Locale(
                    AppConstants.languages[localizationController.selectedIndex]
                        .languageCode,
                    AppConstants.languages[localizationController.selectedIndex]
                        .countryCode,
                  ));
                  Get.back();
                } else {
                  showCustomSnackBar('select_a_language'.tr);
                }
              },
            ),
          ),
          SizedBox(
            height: 30,
          )
        ])),
      );
    });
  }
}
