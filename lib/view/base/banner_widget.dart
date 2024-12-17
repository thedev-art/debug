import 'package:amanuel_glass/controller/banner_controller.dart';
import 'package:amanuel_glass/view/screens/prod_detail/prodcut_detail.dart';
import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:amanuel_glass/controller/cart_controller.dart';
import 'package:amanuel_glass/helper/images.dart';
import 'package:amanuel_glass/view/base/product_item_widget.dart';
// import 'package:amanuel_glass/view/screens/prod_detaile/detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:logger/logger.dart';

import '../../helper/colors.dart';
import '../../model/product_model.dart';

class BannerWidget extends StatelessWidget {
  // var logger =Logger
  BannerWidget({
    Key? key,
    required this.fem,
  }) : super(key: key);

  final double fem;
  final BannerController bannerController = Get.find<BannerController>();
  final logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 75,
      colors: true,
      printEmojis: true,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Obx(() {
        // Loading State
        if (bannerController.isLoading.value) {
          return SizedBox(
            width: 620 * fem,
            height: 144 * fem,
            child: buildShimmerEfect(),
          );
        }

        // Error State
        if (bannerController.error.value.isNotEmpty) {
          return const Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Unable to get the data"),
                ],
              ),
            ],
          );
        }

        // Empty State
        if (bannerController.banners.isEmpty) {
          return const Center(child: SizedBox());
        }

        // Success State
        return Padding(
          padding:
              const EdgeInsets.only(top: 20, bottom: 20, left: 13, right: 0),
          child: SizedBox(
            height: 144 * fem,
            width: 650 * fem,
            child: CarouselSlider.builder(
                options: CarouselOptions(
                  autoPlay: bannerController.banners.length > 1 ? true : false,
                  enlargeCenterPage: false,
                  disableCenter: true,
                  padEnds: false,
                  viewportFraction: 0.8,
                  autoPlayInterval: Duration(seconds: 3),
                  onPageChanged: (index, reason) {},
                ),
                itemCount: bannerController.banners.length,
                itemBuilder: (context, index, _) {
                  final banner = bannerController.banners[index];
                  return Container(
                    child: GestureDetector(
                      onTap: () {
                        logger.i("Banner clicked: ${banner.title}");
                        logger
                            .d("Banner data being passed: ${banner.toJson()}");

                        Get.toNamed('/bannerdetails', arguments: {
                          'banner': {
                            'id': banner.id,
                            'title': banner.title,
                            'description': banner.description,
                            'image': banner.image,
                            'category': banner.category,
                            'is_active': banner.isActive,
                            'banner_type': 'promotional',
                            'product_id': '',
                            'category_id': banner.category?.toString() ?? '',
                            'img': banner.image,
                            'isActive': banner.isActive,
                            'description': banner.description,
                          },
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(
                            0 * fem, 0 * fem, 12 * fem, 0 * fem),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8 * fem),
                          color: Colors.white,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CachedNetworkImage(
                              imageUrl: banner.image,
                              placeholder: (context, url) => Image.asset(
                                  Images.placeholder,
                                  fit: BoxFit.fill),
                              errorWidget: (context, url, error) => Image.asset(
                                  Images.placeholder,
                                  fit: BoxFit.fill),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        );
      }),
    );
  }

  Widget buildShimmerEfect() => Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 0, left: 13, right: 0),
        child: SizedBox(
          child: ListView.separated(
            itemCount: 3,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => SizedBox(width: 12),
            itemBuilder: (context, index) => Shimmer.fromColors(
                child: Container(
                  width: 300,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color.fromARGB(255, 252, 4, 4),
                  ),
                ),
                baseColor: Color.fromARGB(255, 195, 195, 195),
                highlightColor: Colors.grey[200] ??
                    const Color.fromARGB(255, 243, 243, 243)),
          ),
        ),
      );
}

Widget ReadFromDb(Map<String, dynamic> banner) {
  final logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 75,
      colors: true,
      printEmojis: true,
    ),
  );
  logger.i("ReadFromDb called with banner data:");
  logger.d(banner);

  double baseWidth = 390;
  double fem = Get.width / baseWidth;
  double ffem = fem * 0.97;

  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back),
          color: Colors.black),
      title: Text(
        'banner_details'.tr,
        style: TextStyle(color: Colors.black),
      ),
      centerTitle: true,
      toolbarHeight: 70,
    ),
    body: SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            SizedBox(
              height: 300,
              child: CachedNetworkImage(
                  imageUrl: banner['image'] ?? banner['img'] ?? '',
                  placeholder: (context, url) =>
                      Image.asset(Images.placeholder, fit: BoxFit.fill),
                  errorWidget: (context, url, error) =>
                      Image.asset(Images.placeholder, fit: BoxFit.fill),
                  fit: BoxFit.fill),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'description'.tr,
                  style: TextStyle(
                    color: Color.fromARGB(255, 73, 73, 73),
                    fontSize: 18 * ffem,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10 * fem),
            banner['description'].isEmpty
                ? Text(
                    'No description found for this product',
                    style: TextStyle(color: Colors.red),
                  )
                : Text(banner['description'],
                    style: TextStyle(
                      color: Color.fromARGB(255, 114, 114, 114),
                      fontSize: 18 * ffem,
                      wordSpacing: 3,
                    ))
          ]),
        ),
      ),
    ),
  );
}
