import 'package:flutter/material.dart';

class SplashContent extends StatelessWidget {
  // ignore: use_super_parameters
  const SplashContent({
    key,
    required this.text,
    required this.image,
  }) : super(key: key);
  final String text, image;
  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      const SizedBox(
        height: 30,
      ),
      const Padding(padding: EdgeInsets.only(top: 10)),
      Image.asset(
        image,
        height: 380,
        width: 380,
      )
    ]);
  }
}
