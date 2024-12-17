import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:amanuel_glass/controller/payment_controller.dart';
import 'package:amanuel_glass/helper/dimension.dart';
import 'package:amanuel_glass/helper/txt_reference_generator.dart';
import 'package:amanuel_glass/model/order_model.dart';
import 'package:amanuel_glass/view/screens/order_history/history_item_list.dart';
import 'package:clipboard/clipboard.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:amanuel_glass/chapa/chapa_webview.dart';
import 'package:amanuel_glass/chapa/model/data.dart';
import 'package:amanuel_glass/controller/auth_controller.dart';
import 'package:amanuel_glass/controller/cart_controller.dart';
import 'package:amanuel_glass/controller/location_controller.dart';
import 'package:amanuel_glass/controller/order_controller.dart';
import 'package:amanuel_glass/helper/colors.dart';
// import 'package:amanuel_glass/helper/dimensions.dart';
// import 'package:amanuel_glass/helper/tx_reference_generator.dart';
import 'package:amanuel_glass/model/order_model.dart' as app_order;
// import 'package:cloud_firestore_platform_interface/src/platform_interface/platform_interface_index_definitions.dart'
//     hide Order;
import 'package:amanuel_glass/model/product_model.dart';
import 'package:amanuel_glass/model/user_model.dart';
import 'package:amanuel_glass/view/base/custom_alert_dialog.dart';
import 'package:amanuel_glass/view/base/custom_button.dart';
import 'package:amanuel_glass/view/components/custom_appbar.dart';
import 'package:amanuel_glass/view/components/custom_snackbar.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../base/custom_textfield.dart';
import 'package:logger/logger.dart';

class PaymentMethodDialog extends StatefulWidget {
  final List<Product> cartList;
  final double totalAmount;
  final double discountPrice;
  final String additionalLocation;

  const PaymentMethodDialog({
    Key? key,
    required this.cartList,
    required this.totalAmount,
    required this.discountPrice,
    required this.additionalLocation,
  }) : super(key: key);

  @override
  State<PaymentMethodDialog> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethodDialog> {
  late int value = 1;
  bool isLoading = false;
  late SharedPreferences preferences;
  String? userName;
  final logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 75,
      colors: true,
      printEmojis: true,
    ),
  );

  final LocationController locationController = Get.find<LocationController>();

  @override
  void initState() {
    super.initState();
    getUserName();
  }

  Future<void> getUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name');
    });
  }

  @override
  Widget build(BuildContext context) {
    logger.i("Building PaymentDialog");
    logger.d("User Phone: ${Get.find<AuthController>().userPhone}");
    logger.d("User Name: ${Get.find<AuthController>().userName}");

    return Container(
        height: 415,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10,
                        left: Dimensions.PADDING_SIZE_SMALL * 13,
                        bottom: 10),
                    child: Center(
                        child: Text(
                      "payment_method".tr,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    )),
                  ),
                  InkWell(
                    onTap: () => Get.back(),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                          right: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      child: Icon(Icons.close,
                          color: Theme.of(context).disabledColor),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: value == 1
                        ? MyColors.primary
                        : Colors.grey, // Border color
                    width: 1.0, // Border width
                  ),
                ),
                child: RadioListTile(
                    title: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: Dimensions.PADDING_SIZE_DEFAULT),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.moneyCheckDollar,
                                color:
                                    value == 1 ? MyColors.primary : Colors.grey,
                              ),
                              SizedBox(
                                width: Dimensions.PADDING_SIZE_SMALL,
                              ),
                              SizedBox(width: Dimensions.PADDING_SIZE_LARGE),
                              Text(
                                'cash_on_delivery'.tr,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: value == 1
                                      ? MyColors.primary
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    activeColor: MyColors.primary,
                    value: 1,
                    groupValue: value,
                    controlAffinity: ListTileControlAffinity.trailing,
                    onChanged: (val) {
                      setState(() {
                        value = int.parse(val.toString());
                      });
                    }),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: value == 2 ? MyColors.primary : Colors.grey,
                    width: 1.0, // Border width
                  ),
                ),
                child: RadioListTile(
                    title: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: Dimensions.PADDING_SIZE_DEFAULT),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.bank,
                                color:
                                    value == 2 ? MyColors.primary : Colors.grey,
                              ),
                              SizedBox(
                                width: Dimensions.PADDING_SIZE_SMALL,
                              ),
                              SizedBox(width: Dimensions.PADDING_SIZE_LARGE),
                              Text(
                                'bank_transfer'.tr,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: value == 2
                                        ? MyColors.primary
                                        : Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    activeColor: MyColors.primary,
                    value: 2,
                    groupValue: value,
                    controlAffinity: ListTileControlAffinity.trailing,
                    onChanged: (val) {
                      setState(() {
                        value = int.parse(val.toString());
                      });
                    }),
              ),
            ),
            // SizedBox(
            //   height: 15,
            // ),
            // Padding(
            //   padding: EdgeInsets.only(left: 15, right: 15),
            //   child: Container(
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(15),
            //         border: Border.all(
            //           color: value == 3 ? MyColors.primary : Colors.grey,
            //           width: 1.0, // Border width
            //         ),
            //       ),
            //       child: RadioListTile(
            //         contentPadding: EdgeInsets.symmetric(
            //             horizontal: 16.0,
            //             vertical: 0), // Minimize vertical padding
            //         title: Row(
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           children: [
            //             Row(
            //               mainAxisSize: MainAxisSize.min,
            //               children: [
            //                 Padding(
            //                   padding: const EdgeInsets.only(
            //                       top: 8.0), // Reduce top padding
            //                   child: Image.asset(
            //                     "assets/images/chapa_logo_2.png",
            //                     height: 40,
            //                     width: 40,
            //                   ),
            //                 ),
            //                 SizedBox(width: Dimensions.PADDING_SIZE_LARGE),
            //                 Text(
            //                   'digital_payment'.tr,
            //                   style: TextStyle(
            //                     fontSize: 14, // Reduce font size if needed
            //                     fontWeight: FontWeight.bold,
            //                     color:
            //                         value == 3 ? MyColors.primary : Colors.grey,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ],
            //         ),
            //         subtitle: Padding(
            //           padding: const EdgeInsets.only(
            //               left: 60, bottom: 0), // Reduce bottom padding
            //           child: Text(
            //             'you_can_pay_with_many_gateways'.tr,
            //             style: TextStyle(fontSize: 10),
            //           ),
            //         ),
            //         activeColor: MyColors.primary,
            //         value: 3,
            //         groupValue: value,
            //         controlAffinity: ListTileControlAffinity.trailing,
            //         onChanged: (val) {
            //           setState(() {
            //             value = int.parse(val.toString());
            //           });
            //         },
            //       )),
            // ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: [
                GetBuilder<OrderController>(builder: (orderController) {
                  Users user = Users(
                      id: Get.find<AuthController>().userPhone,
                      name: Get.find<AuthController>().userName,
                      phone: Get.find<AuthController>().userPhone);
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: isLoading ||
                            Get.find<AuthController>().userPhone == '' ||
                            Get.find<AuthController>().userPhone == null
                        ? CircularProgressIndicator(
                            color: MyColors.primary,
                          )
                        : CustomButton(
                            fem: 1,
                            ffem: 1,
                            title: 'Continue',
                            onPressed: () async {
                              if (await InternetConnectionChecker()
                                  .hasConnection) {
                                setState(() {
                                  isLoading = true;
                                });
                                if (value == 1) {
                                  Order order = new Order(
                                      id: 0,
                                      date: DateTime.now(),
                                      totalPrice: widget.totalAmount,
                                      deliveryAddress:
                                          Get.find<LocationController>()
                                              .addressModel,
                                      status: 'Pending',
                                      items:
                                          Get.find<CartController>().cartItems,
                                      coupon: Get.find<CartController>().coupon,
                                      discount: widget.discountPrice,
                                      userPhone:
                                          Get.find<AuthController>().userPhone,
                                      user: user,
                                      paymentMethodString: 'cash_on_delivery',
                                      paymentMethod: PaymentMethod(
                                          paymentType: 'cash_on_delivery',
                                          receiptPhoto: ''),
                                      additionalLocation:
                                          widget.additionalLocation != null &&
                                                  widget.additionalLocation
                                                      .isNotEmpty
                                              ? widget.additionalLocation
                                              : '');

                                  orderController
                                      .placeOrder(order)
                                      .then((value) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    Get.back();
                                    Get.find<CartController>().clearCartList();
                                    Get.dialog(
                                      CustomAlertDialog(
                                          description:
                                              'your_order_is_placed_successfully'
                                                  .tr,
                                          onOkPressed: () {
                                            Get.back();
                                            Get.find<CartController>()
                                                .navigateToCartScreen(index: 2);
                                          }),
                                      barrierDismissible: false,
                                    );
                                  }).catchError((error) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    throw (error);
                                  });
                                } else if (value == 2) {
                                  Get.back();
                                  Get.to(EnterBankInfo(
                                    totalAmount: widget.totalAmount,
                                    cartList: widget.cartList,
                                    user: user,
                                    discountPrice: widget.discountPrice,
                                    additionalLocation:
                                        widget.additionalLocation,
                                  ));
                                } else if (value == 3) {
                                  String transactionReference =
                                      generateTransactionReference();

                                  try {
                                    String baseUrl =
                                        "https://api.chapa.co/v1/transaction/initialize";
                                    final http.Response response =
                                        await http.post(
                                      Uri.parse(baseUrl),
                                      headers: {
                                        'Authorization':
                                            'Bearer CHASECK-Rx7zszCXghiUnLuRwUcpDMcVDu9TxsUn',
                                      },
                                      body: {
                                        'phone_number': user.phone.toString(),
                                        'amount': widget.totalAmount.toString(),
                                        'currency': 'ETB',
                                        'first_name': user.name,
                                        'last_name': "",
                                        'tx_ref': transactionReference,
                                        'customization[title]': "Kiosk Payment",
                                        'customization[description]':
                                            "The items are ..."
                                      },
                                    );
                                    var jsonResponse =
                                        json.decode(response.body);
                                    if (response.statusCode == 400) {
                                      showCustomSnackBar(
                                          'an error occured, please try again');
                                      setState(() {
                                        isLoading = false;
                                      });
                                    } else if (response.statusCode == 200) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      ResponseData res =
                                          ResponseData.fromJson(jsonResponse);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChapaWebView(
                                                    url: res.data.checkoutUrl
                                                        .toString(),
                                                    transactionReference:
                                                        transactionReference,
                                                    successCallback: () {
                                                      Order order = Order(
                                                          id: int.parse(""),
                                                          date: DateTime.now(),
                                                          totalPrice: widget
                                                              .totalAmount,
                                                          deliveryAddress:
                                                              Get.find<LocationController>()
                                                                  .addressModel,
                                                          status: 'Pending',
                                                          items: Get.find<CartController>()
                                                              .cartItems,
                                                          coupon:
                                                              Get.find<CartController>()
                                                                  .coupon,
                                                          discount: widget
                                                              .discountPrice,
                                                          userPhone:
                                                              Get.find<AuthController>()
                                                                  .userPhone,
                                                          user: user,
                                                          paymentMethodString:
                                                              'chapa',
                                                          paymentMethod: PaymentMethod(
                                                              paymentType:
                                                                  'chapa',
                                                              receiptPhoto: '',
                                                              transactionReference:
                                                                  transactionReference),
                                                          additionalLocation: widget
                                                                          .additionalLocation !=
                                                                      null &&
                                                                  widget
                                                                      .additionalLocation
                                                                      .isNotEmpty
                                                              ? widget.additionalLocation
                                                              : '');
                                                      orderController
                                                          .placeOrder(order)
                                                          .then((value) {
                                                        setState(() {
                                                          isLoading = false;
                                                        });
                                                        Get.back();
                                                        Get.back();
                                                        Get.find<
                                                                CartController>()
                                                            .clearCartList();
                                                        Get.dialog(
                                                          CustomAlertDialog(
                                                              description:
                                                                  'your_order_is_placed_successfully'
                                                                      .tr,
                                                              onOkPressed: () {
                                                                Get.back();
                                                                Get.find<
                                                                        CartController>()
                                                                    .navigateToCartScreen(
                                                                        index:
                                                                            2);
                                                              }),
                                                          barrierDismissible:
                                                              false,
                                                        );
                                                      }).catchError((error) {
                                                        setState(() {
                                                          isLoading = false;
                                                        });
                                                        throw (error);
                                                      });
                                                    },
                                                  )));
                                    } else {
                                      setState(() {
                                        isLoading = true;
                                      });
                                    }
                                  } catch (e) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                  }
                                }
                              } else {
                                showCustomSnackBar(
                                    'please check your internet connection!');
                              }
                            }),
                  );
                }),
              ],
            ),
          ],
        ));
  }
}

class EnterBankInfo extends StatefulWidget {
  final double totalAmount;
  final double discountPrice;
  final List<Product> cartList;
  final Users user;
  final String additionalLocation;

  const EnterBankInfo({
    Key? key,
    required this.totalAmount,
    required this.discountPrice,
    required this.cartList,
    required this.user,
    required this.additionalLocation,
  }) : super(key: key);

  @override
  State<EnterBankInfo> createState() => _EnterBankInfoState();
}

class _EnterBankInfoState extends State<EnterBankInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'bank_transfer'.tr,
        isBackButtonExist: true,
        onBackPressed: () {
          Get.back();
          Get.bottomSheet(PaymentMethodDialog(
              cartList: widget.cartList,
              totalAmount: widget.totalAmount,
              discountPrice: widget.discountPrice,
              additionalLocation: widget.additionalLocation));
        },
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
        ),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [SizedBox()],
          ),
          Expanded(
            child: BankAccountDropdown(
              totalAmount: widget.totalAmount,
              cartList: widget.cartList,
              discountPrice: widget.discountPrice,
              user: widget.user,
              additionalLocation: widget.additionalLocation,
            ),
          ),
        ]),
      ),
    );
  }
}

class BankAccountDropdown extends StatefulWidget {
  final double totalAmount;
  final double discountPrice;
  final List<Product> cartList;
  final Users user;
  final String additionalLocation;

  const BankAccountDropdown({
    Key? key,
    required this.totalAmount,
    required this.discountPrice,
    required this.cartList,
    required this.user,
    required this.additionalLocation,
  }) : super(key: key);

  @override
  _BankAccountDropdownState createState() => _BankAccountDropdownState();
}

class _BankAccountDropdownState extends State<BankAccountDropdown> {
  String? _selectedBank;
  String? _selectedAccountNumber;
  String? _selectedAccountName;
  bool _isCopied = false;
  XFile? _pickedImage;
  bool isPickImageLoading = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noController = TextEditingController();
  final TextEditingController _addressControllers = TextEditingController();
  final FocusNode _name = FocusNode();
  final FocusNode _no = FocusNode();
  final FocusNode _amount = FocusNode();
  bool _isLoading = false;
  final PaymentController _paymentController = Get.find<PaymentController>();

  @override
  void dispose() {
    _nameController.dispose();
    _noController.dispose();
    _addressControllers.dispose();
    _name.dispose();
    _no.dispose();
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Scrollbar(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("${"select_bank_to_deposit".tr}:"),
                  ),
                  Obx(() {
                    if (_paymentController.isLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final businessInfo = _paymentController.businessInfo.value;
                    if (businessInfo == null) {
                      return Center(child: Text('No bank accounts available'));
                    }

                    List<String> bankNames =
                        businessInfo.accounts.map((acc) => acc.bank).toList();
                    Map<String, String> bankAccountNumbers = {
                      for (var acc in businessInfo.accounts)
                        acc.bank: acc.accountNumber
                    };
                    Map<String, String> bankAccountNames = {
                      for (var acc in businessInfo.accounts)
                        acc.bank: acc.accountHolderName
                    };

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<String>(
                        value: _selectedBank,
                        items: bankNames.map((String bankName) {
                          return DropdownMenuItem<String>(
                            value: bankName,
                            child: Text(bankName.tr),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedBank = newValue;
                            _selectedAccountNumber =
                                bankAccountNumbers[newValue];
                            _selectedAccountName = bankAccountNames[newValue];
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "select_bank".tr,
                        ),
                      ),
                    );
                  }),
                  SizedBox(height: 10),
                  if (_selectedBank != null)
                    Center(
                      child: Text(
                        "bank_account_details".tr,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: MyColors.primary),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  SizedBox(
                    width: 25,
                  ),
                  if (_selectedBank != null)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Text(
                            "${"account_name".tr}:       ",
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          Text(_selectedAccountName?.tr ?? '',
                              style: TextStyle(
                                  fontSize: 16, color: MyColors.primary))
                        ],
                      ),
                    ),
                  if (_selectedBank != null)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Text("${"account_number".tr}:   ",
                              style: TextStyle(fontSize: 16)),
                          SizedBox(
                            width: 25,
                          ),
                          Row(
                            children: [
                              Text(_selectedAccountNumber ?? "",
                                  style: TextStyle(
                                      fontSize: 16, color: MyColors.primary)),
                              IconButton(
                                  onPressed: () {
                                    FlutterClipboard.copy(
                                            _selectedAccountNumber ?? "")
                                        .then((value) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              backgroundColor: Colors.green,
                                              content: Text(
                                                "Bank account copied to clipboard"
                                                    .tr,
                                                textAlign: TextAlign.center,
                                              )));
                                    });
                                    setState(() {
                                      _isCopied = true;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.copy,
                                    size: 20,
                                    color: _isCopied
                                        ? Colors.grey
                                        : MyColors.primary,
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  if (_selectedBank != null)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Text(
                            '${"total_deposited_amount".tr}:',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Text(
                            widget.totalAmount.toString() + ' ' + "br".tr,
                            style: TextStyle(
                                color: MyColors.primary, fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  Divider(
                    height: 10,
                    thickness: 4,
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'delivery_details'.tr,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: MyColors.primary
                          ),
                        ),
                        SizedBox(height: 15),
                        CustomTextField(
                          controller: _nameController,
                          focusNode: _name,
                          nextFocus: _no,
                          hintText: 'enter_full_name'.tr,
                          inputType: TextInputType.name,
                          divider: true,
                        ),
                        SizedBox(height: 10),
                        CustomTextField(
                          controller: _addressControllers,
                          focusNode: _amount,
                          nextFocus: _name,
                          hintText: 'enter_delivery_address'.tr,
                          inputType: TextInputType.streetAddress,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton.icon(
                          onPressed: isPickImageLoading ? null : pickImage,
                          icon: Icon(Icons.upload_file),
                          label: Text(
                            isPickImageLoading 
                              ? 'uploading'.tr 
                              : 'upload_receipt'.tr
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyColors.primary,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  _pickedImage != null
                      ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                              height: 100, child: _buildImagePreview()),
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: _isLoading
                ? CircularProgressIndicator(
                    color: MyColors.primary,
                  )
                : CustomButton(
                    fem: 1,
                    ffem: 1,
                    title: 'confirm_order'.tr,
                    onPressed: () async {
                      if (await InternetConnectionChecker().hasConnection) {
                        setState(() {
                          _isLoading = true;
                        });

                        String imgurl = await uploadImageToStorage(
                                'payment', _pickedImage) ??
                            '';
                        PaymentMethod paymentMethodDetails = PaymentMethod(
                            paymentType: 'bank_transfer',
                            fullName: _nameController.text.trim(),
                            address: _addressControllers.text.trim(),
                            receiptPhoto: imgurl != null ? imgurl : '');
                        Order order = new Order(
                            id: 0,
                            date: DateTime.now(),
                            totalPrice: widget.totalAmount,
                            deliveryAddress:
                                Get.find<LocationController>().addressModel,
                            status: 'Pending',
                            items: widget.cartList,
                            coupon: Get.find<CartController>().coupon,
                            discount: widget.discountPrice,
                            userPhone: Get.find<AuthController>().userPhone,
                            user: widget.user,
                            paymentMethodString: 'bank_transfer',
                            paymentMethod: paymentMethodDetails,
                            additionalLocation:
                                widget.additionalLocation != null &&
                                        widget.additionalLocation.isNotEmpty
                                    ? widget.additionalLocation
                                    : '');

                        if (_selectedBank == null) {
                          setState(() {
                            _isLoading = false;
                          });
                          showCustomSnackBar('Please select a bank',
                              isError: true);
                        } else if (_addressControllers.text.isEmpty) {
                          setState(() {
                            _isLoading = false;
                          });
                          showCustomSnackBar(
                              'Please enter the address the product will be sent to',
                              isError: true);
                        } else if (_nameController.text.isEmpty) {
                          setState(() {
                            _isLoading = false;
                          });
                          showCustomSnackBar(
                              'Please enter the name the product will be sent to',
                              isError: true);
                        } else {
                          setState(() {
                            _isLoading = true;
                          });

                          Get.find<OrderController>()
                              .placeOrder(order)
                              .then((value) {
                            setState(() {
                              _isLoading = false;
                            });
                            Get.back();
                            Get.find<CartController>().clearCartList();
                            Get.dialog(
                              CustomAlertDialog(
                                  description:
                                      'your_order_is_placed_successfully'.tr,
                                  onOkPressed: () {
                                    Get.back();
                                    Get.find<CartController>()
                                        .navigateToCartScreen(index: 2);
                                  }),
                              barrierDismissible: false,
                            );
                          }).catchError((error) {
                            setState(() {
                              _isLoading = false;
                            });
                            Get.dialog(
                              CustomAlertDialog(
                                description: 'Order Failed Please try again',
                                onOkPressed: () {
                                  Get.back();
                                },
                                isSuccess: false,
                              ),
                              barrierDismissible: false,
                            );
                          });
                        }
                      } else {
                        showCustomSnackBar(
                            'please check your internet connection!');
                      }
                    }),
          ),
        )
      ],
    );
  }

  Future<String?> uploadImageToStorage(String childName, XFile? file) async {
    if (file == null) return null;
    // Return a dummy image path from assets
    return 'assets/images/dummy_receipt.png';
  }

  Widget _buildImagePreview() {
    if (_pickedImage != null) {
      return Stack(
        children: [
          Image.file(
            File(_pickedImage?.path ?? ''),
          ),
          Align(
            child: IconButton(
                onPressed: () {
                  setState(() {
                    _pickedImage = null;
                  });
                },
                icon: Icon(Icons.delete)),
          )
        ],
      );
    } else {
      return Placeholder(
        fallbackHeight: 100,
        fallbackWidth: 100,
      );
    }
  }

  Future pickImage() async {
    setState(() {
      isPickImageLoading = true;
    });
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _pickedImage = pickedImage;
        isPickImageLoading = false;
      });
    } else {
      setState(() {
        isPickImageLoading = false;
        showCustomSnackBar('Please try to upload again');
      });
    }
  }
}
