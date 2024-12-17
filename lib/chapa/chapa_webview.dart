import 'dart:async';

import 'package:amanuel_glass/chapa/constants/request.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:amanuel_glass/chapa/constants/requests.dart';
import 'package:amanuel_glass/helper/enums.dart';
import 'package:amanuel_glass/view/components/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class ChapaWebView extends StatefulWidget {
  final String url;
  final String transactionReference;
  final Function? successCallback;

  const ChapaWebView({
    Key? key,
    required this.url,
    required this.transactionReference,
    this.successCallback,
  }) : super(key: key);

  @override
  State<ChapaWebView> createState() => _ChapaWebViewState();
}

class _ChapaWebViewState extends State<ChapaWebView> {
  late InAppWebViewController webViewController;
  String url = "";
  double progress = 0;
  late StreamSubscription connection;
  bool isOffline = false;
  bool _isLoading = true;

  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
          useShouldOverrideUrlLoading: true,
          mediaPlaybackRequiresUserGesture: false,
          supportZoom: true),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
        useWideViewPort: false,
      ),
      ios: IOSInAppWebViewOptions(
          allowsInlineMediaPlayback: true, useOnNavigationResponse: true));

  @override
  void initState() {
    checkConnectivity();
    super.initState();
  }

  void checkConnectivity() {
    connection = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      final ConnectivityResult status = result.first;

      if (status == ConnectivityResult.none) {
        setState(() {
          isOffline = true;
        });

        showToast('Loading...');

        exitPaymentPage('Connection error');
      } else if (status == ConnectivityResult.mobile) {
        setState(() {
          isOffline = false;
        });
      } else if (status == ConnectivityResult.wifi) {
        setState(() {
          isOffline = false;
        });
      } else if (status == ConnectivityResult.ethernet) {
        setState(() {
          isOffline = false;
        });
      } else if (status == ConnectivityResult.bluetooth) {
        setState(() {
          isOffline = false;
        });
        exitPaymentPage('Connection error');
      }
    });
  }

  void exitPaymentPage(String message) {}

  @override
  void dispose() {
    super.dispose();
    connection.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(children: <Widget>[
          InAppWebView(
              key: webViewKey,
              initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
              initialOptions: options,
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              androidOnPermissionRequest:
                  (controller, origin, resources) async {
                return PermissionRequestResponse(
                    resources: resources,
                    action: PermissionRequestResponseAction.GRANT);
              },
              shouldOverrideUrlLoading:
                  (controller, shouldOverrideUrlLoadingRequest) async {
                var uri = shouldOverrideUrlLoadingRequest.request.url;

                if (uri.toString().contains(
                    'https://checkout.chapa.co/checkout/payment-receipt')) {
                  widget.successCallback?.call();
                } else if (uri
                    .toString()
                    .contains('${PaymentStatus.failed.name}')) {
                  Get.back();
                  Get.back();
                  Get.back();
                  showCustomSnackBar(
                      'Payment failed, please try again or change payment method');
                }
                return NavigationActionPolicy.ALLOW;
              },
              onLoadStop: (controller, url) async {
                setState(() {
                  _isLoading = false;
                });
              },
              onLoadError: (controller, url, code, message) {}),
          if (_isLoading)
            const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.lightGreen,
                ),
              ),
            )
        ]),
      ),
    );
  }
}
