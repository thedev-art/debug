import 'package:amanuel_glass/controller/cart_controller.dart';
import 'package:amanuel_glass/controller/search_controller.dart';
import 'package:amanuel_glass/dashboard_screen.dart';
import 'package:amanuel_glass/helper/colors.dart';
import 'package:amanuel_glass/model/product_model.dart';
import 'package:amanuel_glass/view/base/product_item_widget.dart';
import 'package:amanuel_glass/view/components/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<String> _searchHistory = [];
  String _searchQuery = '';
  bool searchStarted = false;
  FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _searchFocusNode = FocusNode();

    // _productsStream = FirebaseFirestore.instance
    //     .collection('products')
    //     .where('isActive', isEqualTo: true)
    //     .where('name', isEqualTo: _searchQuery)
    //     .snapshots();
    // _searchFocusNode = FocusNode();
    // _searchFocusNode.requestFocus();
  }

  @override
  void dispose() {
    // _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  bool hasThreeIdenticalLettersInARow(String word1, String word2) {
    if (word1.length < 3 || word2.length < 3) {
      return false;
    }

    for (int i = 0; i <= word1.length - 3; i++) {
      String substring = word1.substring(i, i + 3);
      if (word2.toLowerCase().contains(substring.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leadingWidth: 30,
        leading: Padding(
          padding: const EdgeInsets.only(left: 2.0),
          child: IconButton(
            color: Colors.black,
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        title: Container(
          height: 40,
          margin: const EdgeInsets.only(right: 20),
          padding: const EdgeInsets.only(left: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey[300] ?? Colors.grey,
            ),
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            decoration: InputDecoration(
              hintText: '${"search".tr}...',
              border: InputBorder.none,
              prefixIcon: IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.grey[300],
                ),
                onPressed: () {
                  setState(() {
                    searchStarted = true;
                  });
                  if (_searchController.text.isNotEmpty) {
                    _search(_searchController.text);
                    Get.find<SearchingController>()
                        .searchProducts(_searchController.text);
                  } else {
                    showCustomSnackBar('enter what you want to search');
                  }
                },
              ),
            ),
            onSubmitted: (value) {
              setState(() {
                searchStarted = true;
                _searchQuery = value;
              });
              if (value.isNotEmpty) {
                _search(value);
                Get.find<SearchingController>().searchProducts(value);
              } else {
                showCustomSnackBar('enter what you want to search');
              }
            },
          ),
        ),
        actions: [
          GetBuilder<CartController>(builder: (controller) {
            final int cartItemCount = controller.cartItems.length;
            return Padding(
              padding: const EdgeInsets.only(right: 28.0, top: 13),
              child: GestureDetector(
                onTap: () {
                  controller.navigateToCartScreen();
                  Get.to(() => const DashboardScreen());
                },
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Image.asset(
                          'assets/icons/iconly-light-buy-9hK.png',
                          width: 30,
                          height: 30,
                          color: MyColors.primary,
                        ),
                        if (cartItemCount > 0)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                cartItemCount.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          })
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          searchStarted
              ? Expanded(
                  child: Obx(() {
                    final searchController = Get.find<SearchingController>();

                    if (searchController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (searchController.error.value.isNotEmpty) {
                      return const SizedBox();
                    }

                    final products = searchController.searchResults;

                    return products.isEmpty
                        ? Center(
                            child: Text('no_search_result'.tr),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              top: 10,
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(
                                        '${"search_results_for".tr} "$_searchQuery"',
                                        style: const TextStyle(fontSize: 17),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  GridView.builder(
                                    itemCount: products.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 0.68,
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 10,
                                    ),
                                    itemBuilder: (context, index) {
                                      return ProductItemWidget(
                                        fem: 1.2,
                                        product: products[index],
                                        ffem: 1,
                                        fromwishlist: false,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                  }),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget _buildSearchHistory() {
    return _searchHistory.isEmpty
        ? SizedBox.shrink()
        : Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: Colors.grey[300],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Search History'),
                      // FlatButton(
                      //   child: Text(
                      //     'clear_all'.tr,
                      //     style: TextStyle(color: Colors.red),
                      //   ),
                      //   onPressed: () {
                      //     setState(() {
                      //       _searchHistory.clear();
                      //     });
                      //   },
                      // ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _searchHistory.length,
                    itemBuilder: (context, index) {
                      final query = _searchHistory[index];
                      return ListTile(
                        title: Text(query),
                        onTap: () {
                          setState(() {
                            _searchQuery = query;
                          });
                        },
                        trailing: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchHistory.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }

  void _search(String query) {
    if (query.isNotEmpty) {
      setState(() {
        _searchHistory.insert(0, query);
      });
    }
  }
}
