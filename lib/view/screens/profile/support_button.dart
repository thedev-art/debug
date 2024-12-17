import 'package:amanuel_glass/helper/colors.dart';
import 'package:amanuel_glass/helper/dimension.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupportButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String info;
  final Color color;
  final Function onTap;
  final bool isFeedback;
  SupportButton(
      {required this.icon,
      required this.title,
      required this.info,
      required this.color,
      required this.onTap,
      this.isFeedback = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            height: 40,
            width: 40,
            child: Icon(
              icon,
              size: 25,
              color: MyColors.primary,
            ),
          ),
          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                isFeedback
                    ? Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(title,
                                  style: TextStyle(
                                      fontSize: Dimensions.FONT_SIZE_SMALL,
                                      color: MyColors.primary)),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: MyColors.primary,
                              )
                            ]))
                    : Text(title,
                        style: TextStyle(
                            fontSize: Dimensions.FONT_SIZE_DEFAULT,
                            color: MyColors.primary)),
                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                !isFeedback
                    ? Text(info, maxLines: 1, overflow: TextOverflow.ellipsis)
                    : SizedBox(),
              ])),
        ]),
      ),
    );
  }
}
