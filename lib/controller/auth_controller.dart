import 'dart:io';

import 'package:amanuel_glass/controller/cart_controller.dart';
import 'package:amanuel_glass/services/api_services.dart';
import 'package:dio/dio.dart' as dio;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dashboard_screen.dart';
import '../view/components/custom_snackbar.dart';
// import '../view/screens/sign_up/sign_up_screen.dart';
// Dio

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  var logger = Logger();
  // final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  late SharedPreferences prefs;
  // late Rx<User?> _user;
  var isLoading = false.obs;
  var isWaitingForOTP = false.obs;
  bool isLoggedIn = false;
  bool _notification = true;
  bool _acceptTerms = true;
  late String _verificationId;
  RxString filepath = RxString('');
  // XFile? file;
  String? _userPhone;
  String? _userName;

  bool get notification => _notification;
  bool get acceptTerms => _acceptTerms;
  String get verificationId => _verificationId;
  String? get userPhone => _userPhone;
  String? get userName => _userName;

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onInit() async {
    super.onInit();
    logger.i("AuthController initializing...");

    // Initialize user data from SharedPreferences
    prefs = await SharedPreferences.getInstance();
    _userPhone = prefs.getString("PHONE");
    _userName = prefs.getString("user_name");

    logger.d("Initialized user data from SharedPreferences:");
    logger.d("Phone: $_userPhone");
    logger.d("Name: $_userName");

    update(); // Notify listeners of the update
  }

  void stopLoader() {
    isLoading.value = false;
  }

  void setVerificationId(String verificationId) {
    _verificationId = verificationId;
    update();
  }

  void sendOTP(
      TextEditingController phoneController, String countryDialCode) async {
    isLoading.value = true;
    update();
    String _phone = phoneController.text.trim();
    String _numberWithCountryCode = countryDialCode + _phone;
    bool _isValid = false;

    if (_numberWithCountryCode.length == 13 ||
        _numberWithCountryCode.length == 14) {
      _isValid = true;
    } else {
      isLoading.value = false;
      update();
    }
    if (_phone.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    } else if (!_isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    } else {
      // verifyNumber(_numberWithCountryCode);
    }
  }

  bool isValidPhoneNumber(String phoneNumber) {
    RegExp regExp = RegExp(r'^(09|07)');
    return regExp.hasMatch(phoneNumber);
  }

  // verifyNumber(String phonenumber) async {
  //   final pref = await SharedPreferences.getInstance();
  //   pref.setString('myPhonenum', phonenumber);
  //   await FirebaseAuth.instance
  //       .verifyPhoneNumber(
  //     phoneNumber: phonenumber,
  //     verificationCompleted: (PhoneAuthCredential credential) async {
  //       try {
  //         await FirebaseAuth.instance.signInWithCredential(credential);
  //         final userDoc = await FirebaseFirestore.instance
  //             .collection('users')
  //             .doc(FirebaseAuth.instance.currentUser?.uid)
  //             .get();

  //         if (!userDoc.exists) {
  //           Get.to(() => SignUpScreen(phone: phonenumber));
  //         } else {
  //           pref.setBool('isGuest', false);
  //           Get.offAll(() => DashboardScreen());
  //         }
  //         isLoading.value = false;
  //         isWaitingForOTP.value = false;
  //       } catch (e) {
  //         isLoading.value = false;
  //       }
  //     },
  //     verificationFailed: (FirebaseAuthException e) {
  //       isLoading.value = false;
  //       showCustomSnackBar(e.toString());
  //     },
  //     codeSent: (String verificationId, int? resendToken) {
  //       isLoading.value = false;
  //       setVerificationId(verificationId);
  //       isWaitingForOTP.value = true;
  //     },
  //     codeAutoRetrievalTimeout: (String verificationId) {},
  //   )
  //       .onError((error, stackTrace) {
  //     isLoading.value = false;
  //     showCustomSnackBar(error.toString());
  //   });
  // }

  // void verifyOTP(String pin, String phone) async {
  //   isLoading.value = true;
  //   update();

  //   PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //       verificationId: verificationId, smsCode: pin);

  //   FirebaseAuth.instance
  //       .signInWithCredential(credential)
  //       .then((authResult) async {
  //     User? user = authResult.user;
  //     if (user != null) {
  //       final CollectionReference usersCollection =
  //           FirebaseFirestore.instance.collection('users');
  //       final DocumentSnapshot userSnapshot =
  //           await usersCollection.doc(user.uid).get();

  //       if (userSnapshot.exists) {
  //         Get.offAll(() => DashboardScreen());
  //       } else {
  //         Get.offAll(() => SignUpScreen(phone: phone));
  //       }
  //     }

  //     isWaitingForOTP.value = false;
  //     isLoading.value = false;
  //   }).onError((error, stackTrace) {
  //     isWaitingForOTP.value = false;
  //     isLoading.value = false;
  //     showCustomSnackBar('invalid_otp'.tr);
  //     update();
  //   });
  // }

  // Future<void> storeUser(String name, String phoneNumber) async {
  //   prefs = await SharedPreferences.getInstance();

  //   try {
  //     // CollectionReference users =
  //     //     FirebaseFirestore.instance.collection('users');

  //     // await users.doc(phoneNumber).set({
  //     //   'phone_number': phoneNumber,
  //     //   'name': name,
  //     //   'profile_url': '',
  //     //   'is_active': true,
  //     //   'role': 'customer',
  //     // });
  //     prefs.setString("USER_NAME", name);
  //     prefs.setString("PHONE", phoneNumber);
  //     isLoggedIn = true;
  //   } on Exception catch (e) {
  //     // Handle error
  //   }
  //   update();
  // }
  Future<void> storeUser(String name, String phoneNumber) async {
    logger.i("Registration Started");
    prefs = await SharedPreferences.getInstance();

    try {
      // Create user via REST API
      final apiservice = Get.find<APIServices>();

      final response = await apiservice.postRequest('customers/', payload: {
        'phone_number': phoneNumber,
        'name': name,
      }).timeout(Duration(seconds: 10));
      logger.i("Registration Response : ${response.data}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Store locally after successful API call
        prefs.setString("USER_NAME", name);
        prefs.setString("PHONE", phoneNumber);
        isLoggedIn = true;

        // Store user data from response if needed
        if (response.data != null) {
          final userData = response.data;
          // Store additional user data if needed
          prefs.setString("USER_ID", userData['id'].toString());
        }
      } else {
        logger.i("Registration Failed : ${response.statusCode}");
        throw Exception('Failed to create user: ${response.statusCode}');
      }
    } catch (e) {
      logger.i("Registration Error : ${e.toString()}");
      showCustomSnackBar('Error creating user: ${e.toString()}');
      throw e;
    } finally {
      update();
    }
  }

  // Future<void> updateUser(
  //     String name, String phoneNumber, String? imageUrl) async {
  //   prefs = await SharedPreferences.getInstance();

  //   try {
  //     final docUser =
  //         FirebaseFirestore.instance.collection('users').doc(userPhone);
  //     if (imageUrl != null) {
  //       await docUser.update({
  //         'name': name,
  //         'phone_number': phoneNumber,
  //         'profile_url': imageUrl
  //       });
  //       Get.back();
  //       Get.back();
  //     } else {
  //       await docUser.update({
  //         'name': name,
  //         'phone_number': phoneNumber,
  //       });
  //       Get.back();
  //       Get.back();
  //     }
  //     prefs.setString("USER_NAME", name);
  //     prefs.setString("PHONE", phoneNumber);
  //   } on Exception catch (e) {
  //     // Handle error
  //   }
  // }

  Future<bool> isPhoneRegistered() async {
    final prefs = await SharedPreferences.getInstance();
    final phone = prefs.getString("PHONE");
    return phone != null && phone.isNotEmpty;
  }

  Future<void> clearData() async {
    prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    // await logout();
    Get.find<CartController>().changeIndex(0);
    Get.offAllNamed('signup');
  }

  // Future<bool> isUserNameSaved() async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user == null) return false;

  //   String uid = user.uid;
  //   CollectionReference users = FirebaseFirestore.instance.collection('users');
  //   DocumentSnapshot documentSnapshot = await users.doc(uid).get();

  //   final data = documentSnapshot.data() as Map<String, dynamic>?;
  //   return documentSnapshot.exists && data?.containsKey('name') == true;
  // }

  // Future<void> logout() async {
  //   await FirebaseAuth.instance.signOut();
  //   isLoggedIn = false;
  //   prefs = await SharedPreferences.getInstance();
  //   await prefs.clear();
  //   update();
  // }

  // Future<bool> isUserLoggedIn() async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     await user.reload();
  //     user = FirebaseAuth.instance.currentUser;
  //     if (user != null &&
  //         user.phoneNumber != null &&
  //         user.phoneNumber!.isNotEmpty) {
  //       isLoggedIn = true;
  //       return true;
  //     }
  //   }
  //   update();
  //   return false;
  // }

  Future<void> login(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("PHONE", phone);
    await prefs.setBool('isGuest', false);

    // After successful login, redirect to home
    Get.offAll(() => DashboardScreen());
  }
}
