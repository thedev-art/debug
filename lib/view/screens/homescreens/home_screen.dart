// import 'package:amanuel_glass/view/base/top_deals_widget.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:amanuel_glass/controller/cart_controller.dart';
import 'package:amanuel_glass/controller/category_controller.dart';
import 'package:amanuel_glass/controller/product_controller.dart';
import 'package:amanuel_glass/model/category.dart';
import 'package:amanuel_glass/view/base/category_widget.dart';
import 'package:amanuel_glass/view/base/custom_button.dart';
import 'package:amanuel_glass/view/base/latest_product_widget.dart';
import 'package:amanuel_glass/view/base/product_widget.dart';
import 'package:amanuel_glass/view/base/search_widget.dart';
import 'package:amanuel_glass/view/base/top_deals_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

// import '../../../controller/auth_controller.dart';
// import '../../../controller/cart_controller.dart';
import '../../../controller/location_controller.dart';
import '../../../helper/colors.dart';
// import '../../../model/category.dart';
import '../../base/banner_widget.dart';
// import '../../base/category_widget.dart';
// import '../../base/custom_button.dart';
// import '../../base/lates_products_widget.dart';
// import '../../base/product_widget.dart';
// import '../../base/search_widget.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  RangeValues? currentRangeValue;
  @override
  void initState() {
    super.initState();
    currentRangeValue = Get.find<CartController>().costRangeValues.value;
    //!Currently,the authentication is on firebse !!
    // Get.find<AuthController>().isPhoneRegistered();
  }

  var logger = Logger();

  @override
  Widget build(BuildContext context) {
    final txtController = TextEditingController();

    //!firebase
    // CollectionReference categoriesRef =
    //     FirebaseFirestore.instance.collection('category');
    //!firebase

    bool isTaped = true;

    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          // ✔️
          Get.find<LocationController>().getLocation();
          Get.find<ProductController>().refreshProducts();
        },
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                elevation: 0,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                title: Container(
                  ///
                  ///
                  ///11!!11
                  ///wat the aht the eth awe yt tiu h oge stin teh wold of the main kin of the
                  padding: EdgeInsets.only(
                    top: 15,
                  ),
                  width: double.infinity,
                  height: 50,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 10 * fem,
                        top: 2 * fem,
                        child: InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 10),
                                    content: SizedBox(
                                      height: 100,
                                      width: 2 * fem,
                                      child: Column(children: [
                                        ListTile(
                                          onTap: () async {
                                            SharedPreferences
                                                sharedPreferences =
                                                await SharedPreferences
                                                    .getInstance();
                                            sharedPreferences.setString(
                                                'myAddress',
                                                Get.find<LocationController>()
                                                    .address
                                                    .value);
                                            Navigator.pop(context);
                                          },
                                          leading: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 0,
                                                right: 0,
                                                top: 25,
                                                bottom: 0),
                                            child: CircleAvatar(
                                                radius: 20,
                                                backgroundColor:
                                                    Colors.transparent,
                                                child: Icon(
                                                  Icons.location_on,
                                                  color: MyColors.primary,
                                                )),
                                          ),
                                          subtitle: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0, top: 0, bottom: 0),
                                            child: Text(
                                              Get.find<LocationController>()
                                                  .address
                                                  .value,
                                              overflow: TextOverflow.visible,
                                            ),
                                          ),
                                          title: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0,
                                                right: 8.0,
                                                top: 10,
                                                bottom: 15),
                                            child: Text(
                                              'Your current location',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: MyColors.primary),
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.all(1.0),
                                        ),
                                      ]),
                                    ),
                                  );
                                });
                          },
                          child: Container(
                            width: 143 * fem,
                            height: 28 * fem,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'delivery_address'.tr,
                                  style: TextStyle(
                                    fontSize: 10 * ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.2125 * ffem / fem,
                                    color: Color(0xffc7c7ca),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Obx(
                                        () => Flexible(
                                          child: Container(
                                            margin: EdgeInsets.fromLTRB(0 * fem,
                                                0 * fem, 4 * fem, 0 * fem),
                                            child: Text(
                                              // '',
                                              Get.find<LocationController>()
                                                  .address
                                                  .value,
                                              style: TextStyle(
                                                fontSize: 12 * ffem,
                                                fontWeight: FontWeight.w500,
                                                height: 1.2125 * ffem / fem,
                                                color: MyColors.primary,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 12 * fem,
                                        height: 12 * fem,
                                        child: Image.asset(
                                          'assets/icons/iconly-light-arrow-down-2-fCD.png',
                                          width: 12 * fem,
                                          height: 12 * fem,
                                          color: MyColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 328 * fem,
                        top: 2 * fem,
                        child: Align(
                          child: InkWell(
                            onTap: (() => Get.toNamed('/wishlist')),
                            child: SizedBox(
                              width: 28 * fem,
                              height: 28 * fem,
                              child: Image.asset(
                                'assets/images/iconly-light-heart.png',
                                width: 28 * fem,
                                height: 28 * fem,
                                color: MyColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.only(top: 10),
                sliver: SliverPersistentHeader(
                    pinned: true,
                    delegate: SliverDelegate(
                      child: Center(
                        child: Container(
                          color: Colors.white,
                          width: double.infinity,
                          height: 50,
                          child: GestureDetector(
                            onTap: () {
                              Get.to(SearchScreen());
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, right: 10),
                              child: Container(
                                padding: EdgeInsets.fromLTRB(
                                    12 * fem, 10 * fem, 216 * fem, 10 * fem),
                                width: 350 * fem,
                                height: 40 * fem,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xfff0f2f1)),
                                  borderRadius: BorderRadius.circular(10 * fem),
                                  color: Colors.grey[200],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          15 * fem, 0 * fem, 13 * fem, 0 * fem),
                                      width: 20 * fem,
                                      height: 20 * fem,
                                      child: Image.asset(
                                        'assets/icons/iconly-light-search-tmf.png',
                                        width: 20 * fem,
                                        height: 20 * fem,
                                        color: MyColors.primary,
                                      ),
                                    ),
                                    Text(
                                      'search_here'.tr + " ...",
                                      style: TextStyle(
                                        fontSize: 13 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.2125 * ffem / fem,
                                        color: Color(0xffc7c7ca),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    BannerWidget(fem: fem),

                    Row(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(left: 20, top: 10, bottom: 10),
                          child: Text(
                            'categories'.tr,
                            style: TextStyle(
                              fontSize: 14 * ffem,
                              fontWeight: FontWeight.w500,
                              height: 1.2 * ffem / fem,
                              color: MyColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    //     future: FirebaseFirestore.instance
                    //         .collection('category')
                    //         .where('status', isEqualTo: true)
                    //         .get(),
                    //     builder: (context,
                    //         AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                    //             snapshot) {
                    //       if (snapshot.connectionState ==
                    //           ConnectionState.waiting) {
                    //         {
                    //           return SizedBox(
                    //               width: Get.width * 0.85,
                    //               height: 30,
                    //               child: buildcatShimmerEfect());
                    //         }
                    //       }
                    //       if (snapshot.data == null) {
                    //         return Scaffold(
                    //           body: Padding(
                    //             padding: const EdgeInsets.all(16.0),
                    //             child: Center(
                    //                 child: Text(
                    //                     "No Content, Come back later. Thank you",
                    //                     style: TextStyle(color: Colors.white))),
                    //           ),
                    //         );
                    //       } else if (snapshot.data!.docs.isEmpty) {
                    //         return Scaffold(
                    //           body: Padding(
                    //             padding: const EdgeInsets.all(16.0),
                    //             child: Center(
                    //                 child: Text(
                    //               "No Content, Come back later. Thank you",
                    //               style: TextStyle(color: Colors.white),
                    //             )),
                    //           ),
                    //         );
                    //       }
                    //       if (snapshot.hasData) {
                    //         List<Category> cat = snapshot.data!.docs.map((doc) {
                    //           final data = doc.data();

                    //  Category(
                    //   category_id: data['category_id'] as String? ?? '',
                    //   name: data['name'] as String? ?? '',
                    //   img: data['img'] as String? ?? '',
                    // )
                    //         }).toList();
                    //         // List categoryList = snapshot.data.docs
                    //         //     .map((doc) => doc.data())
                    //         //     .toList();

                    Obx(() {
                      final categoryController = Get.find<CategoryController>();

                      logger.d(
                          "Building categories UI. Loading: ${categoryController.isLoading.value}, Categories count: ${categoryController.categories.length}");

                      if (categoryController.isLoading.value) {
                        return SizedBox(
                          width: Get.width * 0.85,
                          height: 30,
                          child: buildcatShimmerEfect(),
                        );
                      }

                      if (categoryController.error.value.isNotEmpty) {
                        return Center(
                          child: Text(
                            categoryController.error.value,
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }

                      if (categoryController.categories.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              "No Content, Come back later. Thank you",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        );
                      }

                      logger.d(
                          "Building GridView with ${categoryController.categories.length} categories");

                      return GridView.builder(
                        itemCount: categoryController.categories.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 0.7,
                        ),
                        itemBuilder: (context, index) {
                          final category = categoryController.categories[index];
                          logger.d(
                              "Building category at index $index: ${category.toMap()}");
                          return CategoryWidget(
                            fem: fem,
                            ffem: ffem,
                            name: category.name ?? '',
                            images: category.img ?? '',
                            category: category,
                          );
                        },
                      );
                    }),
                    //       }
                    //       return Center(
                    //           child: CircularProgressIndicator(
                    //               color: MyColors.primary));
                    //     }),
                    SizedBox(height: 10),
                    Container(
                      width: 349 * fem,
                      height: 27 * fem,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 0 * fem, 160 * fem, 0 * fem),
                            child: Text(
                              'new_arrival'.tr,
                              style: TextStyle(
                                fontSize: 14 * ffem,
                                fontWeight: FontWeight.w500,
                                height: 1.2125 * ffem / fem,
                                color: MyColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Obx(() {
                      if (Get.find<ProductController>().isLoading.value) {
                        return SizedBox(
                          height: 270,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 3, // Show 3 shimmer items
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Shimmer.fromColors(
                                  baseColor:
                                      const Color.fromARGB(255, 195, 195, 195),
                                  highlightColor:
                                      Colors.grey[300] ?? Colors.grey,
                                  child: Container(
                                    width: 156 * fem,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(16 * fem),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                      return LatestProductWidget(fem: fem, ffem: ffem);
                    }),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: 349 * fem,
                      height: 27 * fem,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 0 * fem, 160 * fem, 0 * fem),
                            child: Text(
                              'Top Deals'.tr,
                              style: TextStyle(
                                fontSize: 14 * ffem,
                                fontWeight: FontWeight.w500,
                                height: 1.2125 * ffem / fem,
                                color: MyColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Obx(() {
                      if (Get.find<ProductController>().isLoading.value) {
                        return SizedBox(
                          height: 270,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 3, // Show 3 shimmer items
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Shimmer.fromColors(
                                  baseColor:
                                      const Color.fromARGB(255, 195, 195, 195),
                                  highlightColor:
                                      Colors.grey[300] ?? Colors.grey,
                                  child: Container(
                                    width: 156 * fem,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(16 * fem),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                      return TopDeals(fem: fem, ffem: ffem);
                    }),
                    Container(
                      width: 349 * fem,
                      height: 27 * fem,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 0 * fem, 160 * fem, 0 * fem),
                            child: Text(
                              'all_products'.tr,
                              style: TextStyle(
                                fontSize: 14 * ffem,
                                fontWeight: FontWeight.w500,
                                height: 1.2125 * ffem / fem,
                                color: MyColors.primary,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(
                                8 * fem, 6 * fem, 8 * fem, 6 * fem),
                            height: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: MyColors.primary),
                              borderRadius: BorderRadius.circular(5 * fem),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GetBuilder<CartController>(
                                    builder: (controller) {
                                  return InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        IconButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            icon: Icon(
                                                              Icons.close,
                                                              color:
                                                                  Colors.grey,
                                                            )),
                                                        Text(
                                                          'sort_and_filter'.tr,
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: MyColors
                                                                  .primary),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            controller
                                                                .clearAllFilters();
                                                            controller
                                                                    .costRangeValues
                                                                    .value =
                                                                RangeValues(
                                                                    0, 20000);
                                                          },
                                                          child: Text(
                                                            'clear_all'.tr,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: MyColors
                                                                    .primary),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: fem * 10,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10),
                                                    child: GetBuilder<
                                                        CartController>(
                                                      builder: (controller) {
                                                        // return Container();
                                                        return RangeSliderExample();
                                                      },
                                                    ),
                                                  ),
                                                  Text(
                                                    'sort'.tr,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SortByCost(),
                                                  Spacer(),
                                                  CustomButton(
                                                    onPressed: () {
                                                      final controller =
                                                          Get.find<
                                                              CartController>();
                                                      if (controller
                                                              .currentRangevalue !=
                                                          null) {
                                                        controller
                                                            .updateRangeValues(
                                                                controller
                                                                    .currentRangevalue!);
                                                        Navigator.pop(context);
                                                      } else if (controller
                                                          .isAscOrd
                                                          .value
                                                          .isNotEmpty) {
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                    fem: 1.1,
                                                    title: 'apply'.tr,
                                                    ffem: 1,
                                                  )
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(
                                          0 * fem, 0 * fem, 25 * fem, 0 * fem),
                                      child: Text(
                                        'filters'.tr,
                                        style: TextStyle(
                                          fontSize: 12 * ffem,
                                          fontWeight: FontWeight.w400,
                                          height: 1.2125 * ffem / fem,
                                          color: Color(0xff393f42),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                                Container(
                                  width: 12 * fem,
                                  height: 12 * fem,
                                  child: Image.asset(
                                    'assets/icons/iconly-light-filter-2-3dK.png',
                                    width: 12 * fem,
                                    height: 12 * fem,
                                    color: MyColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GetBuilder<ProductController>(
                      builder: (productController) {
                        // Add this condition to prevent shimmer if data exists
                        if (!productController.isLoading.value &&
                            (productController.products.isNotEmpty ||
                                productController.error.value.isNotEmpty)) {
                          return ProductWidget(
                            fem: fem,
                            ffem: ffem,
                          );
                        }

                        // Show shimmer only if actually loading and no data yet
                        return productController.isLoading.value &&
                                productController.products.isEmpty
                            ? buildcatShimmerEfect()
                            : ProductWidget(
                                fem: fem,
                                ffem: ffem,
                              );
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildcatShimmerEfect() => SizedBox(
        height: 500,
        child: GridView.builder(
          itemCount: 6,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 10 / 13,
            crossAxisCount: 2,
          ),
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(5),
            child: Shimmer.fromColors(
              child: Container(
                width: 50,
                height: 50,
                color: const Color.fromARGB(255, 252, 4, 4),
              ),
              baseColor: const Color.fromARGB(255, 195, 195, 195),
              highlightColor: Colors.grey[300] ?? Colors.grey,
            ),
          ),
        ),
      );
}

class RangeSliderExample extends StatefulWidget {
  @override
  _RangeSliderExampleState createState() => _RangeSliderExampleState();
}

class _RangeSliderExampleState extends State<RangeSliderExample> {
  // late CartController cartController;

  @override
  void initState() {
    super.initState();
    // cartController = Get.find<CartController>();
  }

  @override
  Widget build(BuildContext context) {
    return RangeSlider(
      values: Get.find<CartController>().costRangeValues.value,
      max: 20000,
      min: 0,
      divisions: 300,
      activeColor: MyColors.primary,
      inactiveColor: Color.fromARGB(255, 232, 232, 232),
      labels: RangeLabels(
        Get.find<CartController>()
            .costRangeValues
            .value
            .start
            .round()
            .toString(),
        Get.find<CartController>().costRangeValues.value.end.round().toString(),
      ),
      onChanged: (RangeValues values) {
        Future.delayed(Duration(milliseconds: 100), () {
          setState(() {
            Get.find<CartController>().costRangeValues.value = values;
          });
        });
      },
      onChangeEnd: (RangeValues values) {
        Get.find<CartController>().currentRangevalue = values;
      },
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  SliverDelegate({required this.child});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;
  @override
  double get minExtent => 50;
  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 ||
        oldDelegate.minExtent != 50 ||
        child != oldDelegate.child;
  }
}

class SortByCost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          ListTile(
            title: Text(
              'ascending_order'.tr,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            trailing: Radio(
                value: 1,
                groupValue: Get.find<CartController>().groupValuAsc.value,
                activeColor: MyColors.primary,
                onChanged: (value) {
                  Get.find<CartController>().orderBy(true);
                }),
          ),
          ListTile(
            title: Text(
              'descending_order'.tr,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            trailing: Radio(
                value: 2,
                groupValue: Get.find<CartController>().groupValuAsc.value,
                activeColor: MyColors.primary,
                onChanged: (value) {
                  Get.find<CartController>().orderBy(false);
                }),
          )
        ],
      );
    });
  }
}

//
