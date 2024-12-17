import 'dart:async';

import 'package:amanuel_glass/controller/location_controller.dart';
import 'package:amanuel_glass/dashboard_screen.dart';
import 'package:amanuel_glass/helper/colors.dart';
import 'package:amanuel_glass/view/screens/sign_up/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';

class VideoDemo extends StatefulWidget {
  final bool isFirstOpen;
  final bool isPhoneRegistered;
  final bool showSignUpScreen;

  const VideoDemo({
    Key? key,
    required this.isFirstOpen,
    required this.isPhoneRegistered,
    required this.showSignUpScreen,
  }) : super(key: key);

  final String title = "Video Demo";

  @override
  VideoDemoState createState() => VideoDemoState();
}

class VideoDemoState extends State<VideoDemo> {
  Timer? _timer;
  bool _timerCompleted = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 1), () {
      setState(() {
        _timerCompleted = true;
      });
      if (widget.isFirstOpen) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignUpScreen()),
        );
      } else if (widget.isPhoneRegistered) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignUpScreen()),
        );
      }
    });
  }

  Future<void> checkForUpdate() async {
    try {
      final info = await InAppUpdate.checkForUpdate();
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        await InAppUpdate.startFlexibleUpdate();
        await InAppUpdate.completeFlexibleUpdate();
      }
    } catch (e) {
      // Handle or log error
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/amanuel-glass.jpg',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
