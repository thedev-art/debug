import 'package:amanuel_glass/controller/auth_controller.dart';
import 'package:amanuel_glass/controller/cart_controller.dart';
import 'package:amanuel_glass/controller/coupon_controller.dart';
import 'package:amanuel_glass/controller/localization_controller.dart';
import 'package:amanuel_glass/controller/location_controller.dart';
import 'package:amanuel_glass/controller/order_controller.dart';
import 'package:amanuel_glass/controller/wishlist_controller.dart';
import 'package:amanuel_glass/dashboard_screen.dart';
import 'package:amanuel_glass/helper/binding.dart';
import 'package:amanuel_glass/helper/messages.dart';
import 'package:amanuel_glass/model/product_model.dart';
import 'package:amanuel_glass/services/api_services.dart';
import 'package:amanuel_glass/utils.dart';
import 'package:amanuel_glass/view/screens/cart/cart_screen.dart';
import 'package:amanuel_glass/view/screens/category/category_detail.dart';
import 'package:amanuel_glass/view/screens/homescreens/home_screen.dart';
import 'package:amanuel_glass/view/screens/order_history/order_detail.dart';
import 'package:amanuel_glass/view/screens/order_history/order_history_detail.dart';
import 'package:amanuel_glass/view/screens/prod_detail/prodcut_detail.dart';
import 'package:amanuel_glass/view/screens/profile/edit_profile.dart';
import 'package:amanuel_glass/view/screens/sign_in/sign_in_screen.dart';
import 'package:amanuel_glass/view/screens/sign_up/sign_up_screen.dart';
import 'package:amanuel_glass/view/screens/splash/animated_splash_screen.dart';
import 'package:amanuel_glass/view/screens/splash/splash_screen.dart';
import 'package:amanuel_glass/view/screens/wishlist/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helper/get_di.dart' as di;
import 'view/base/banner_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final pref = await SharedPreferences.getInstance();
  final bool isFirstOpen = pref.getBool('isFirstOpen') ?? true;
  final Map<String, Map<String, String>> languages = await di.init();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp(
    languages: languages,
    prefs: pref,
  ));
}

class MyApp extends StatefulWidget {
  final bool isFirstOpen;
  final SharedPreferences prefs;
  final Map<String, Map<String, String>> languages;

  const MyApp({
    Key? key,
    this.isFirstOpen = false,
    required this.prefs,
    required this.languages,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final CartController cartController;
  late final LocationController locationController;
  late final OrderController orderController;
  late final CouponsController couponsController;
  late final AuthController authController;
  late final WishListController wishListController;
  late final LocalizationController localizationController;
  late final APIServices apiServices;

  var logger = Logger();

  @override
  void initState() {
    super.initState();
    apiServices = Get.put(APIServices());
    authController = Get.put(AuthController());

    cartController = Get.put(CartController());
    locationController = Get.put(LocationController());
    orderController = Get.put(OrderController());
    couponsController = Get.put(CouponsController());
    wishListController = Get.put(WishListController());

    localizationController = Get.put(
      LocalizationController(sharedPreferences: Get.find()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: localizationController.locale,
      title: 'Flutter',
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      translations: Messages(languages: widget.languages),
      fallbackLocale: const Locale('en', 'US'),
      initialBinding: MyBindings(),
      initialRoute: '/',
      // initialRoute: '',
      getPages: [
        GetPage(
          name: '/',
          page: () {
            return FutureBuilder<SharedPreferences>(
              future: SharedPreferences.getInstance(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final prefs = snapshot.data!;
                  final isLoggedIn = prefs.getString("PHONE") != null;

                  logger.d('Checking login state: $isLoggedIn');
                  // If logged in, go to DashboardScreen, else SignUpScreen
                  return isLoggedIn ? DashboardScreen() : SignUpScreen();
                }
                // Show loading while checking login state
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            );
          },
        ),
        GetPage(name: '/signin', page: () => const SignInScreen()),
        GetPage(name: '/signup', page: () => const SignUpScreen()),
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/main', page: () => Home()),
        GetPage(name: '/dashboard', page: () => getRoute(widget.prefs)),
        GetPage(
          name: '/productdetail',
          page: () {
            final Product? product = Get.arguments?['prodmodel'] as Product?;
            if (product == null) {
              return const SizedBox();
            }
            return ProductDetail(productModel: product);
          },
        ),
        //     //!READ from db is firbase function

        GetPage(
          name: '/bannerdetails',
          page: () {
            final banner = Get.arguments?['banner'] as Map<String, dynamic>;
            return ReadFromDb(banner);
          },
        ),
        GetPage(
          name: '/cat_detail',
          page: () {
            final catId = Get.arguments?['cat_id'] as String?;
            final categoryName = Get.arguments?['cat_name'] as String?;
            return CategoryDetail(
              cat_id: catId ?? '',
              cat_name: categoryName ?? '',
            );
          },
        ),
        GetPage(
          name: '/cart',
          page: () => CartDetailsScreen(),
          binding: MyBindings(),
        ),
        GetPage(
          name: '/wishlist',
          page: () => const WishListScreen(),
        ),
        GetPage(
          name: '/orderdetail',
          page: () {
            final order = Get.arguments?['order'];
            final index = Get.arguments?['index'] as int?;
            return OrderDetail(order: order, index: index ?? 0);
          },
        ),
        GetPage(
          name: '/orderhistorydetail',
          page: () {
            final order = Get.arguments?['order'];
            final index = Get.arguments?['index'] as int?;
            return OrderHistoryDetail(order: order, index: index ?? 0);
          },
        ),
        GetPage(
          name: '/editprofile',
          page: () => const EditProfile(),
        ),
      ],
    );
  }

  Widget getRoute(SharedPreferences pref) {
    final String? isPhoneRegistered = pref.getString("PHONE");
    if (widget.isFirstOpen) {
      return const VideoDemo(
          isFirstOpen: true, isPhoneRegistered: false, showSignUpScreen: false);
    } else if (isPhoneRegistered != null && isPhoneRegistered.isNotEmpty) {
      return const VideoDemo(
          isFirstOpen: false, isPhoneRegistered: true, showSignUpScreen: false);
    } else {
      return const VideoDemo(
          isFirstOpen: false, isPhoneRegistered: false, showSignUpScreen: true);
    }
  }
}