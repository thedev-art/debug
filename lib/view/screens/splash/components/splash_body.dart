import 'package:amanuel_glass/helper/colors.dart';
import 'package:amanuel_glass/view/base/custom_button.dart';
import 'package:amanuel_glass/view/screens/sign_in/sign_in_screen.dart';
import 'package:amanuel_glass/view/screens/sign_up/sign_up_screen.dart';
import 'package:amanuel_glass/view/screens/splash/components/splash_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashBody extends StatefulWidget {
  const SplashBody({Key? key});
  @override
  _SplashBodyState createState() => _SplashBodyState();
}

class _SplashBodyState extends State<SplashBody> {
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text": "Welcome to Das , Let's get started!",
      "image": "assets/images/4286263.jpg"
    },
    {
      "text":
          "We help people's saving get higher by modernizing the traditional Iqub",
      "image": "assets/images/4286263.jpg"
    },
    {
      "text":
          "We help people get insurances by modernizing the traditional Idir",
      "image": "assets/images/4286263.jpg"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
          width: double.infinity,
          child: Column(children: <Widget>[
            const Spacer(),
            Text(
              "ETHIO-AMAZON",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 36,
                color: MyColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
                flex: 4,
                child: PageView.builder(
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                    });
                  },
                  itemCount: splashData.length,
                  itemBuilder: (context, index) => SplashContent(
                      image: splashData[index]["image"] ?? '',
                      text: splashData[index]["text"] ?? ''),
                )),
            Expanded(
              flex: 2,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(children: <Widget>[
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                          splashData.length, (index) => buildDot(index: index)),
                    ),
                    const Spacer(flex: 2),
                    InkWell(
                      onTap: () async {
                        final pref = await SharedPreferences.getInstance();

                        pref.setBool('isFirstOpen', false);

                        Get.offAllNamed('signin');
                      },
                      child: CustomButton(
                        onPressed: () {},
                        fem: 1.2,
                        ffem: 1.3,
                        title: 'Get Started',
                      ),
                    ),
                    const Spacer(),
                  ])),
            ),
          ])),
    );
  }

  AnimatedContainer buildDot({required int index}) {
    return AnimatedContainer(
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color:
            currentPage == index ? MyColors.primary : const Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
      duration: Duration(milliseconds: 200),
    );
  }
}
