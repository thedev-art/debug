import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Messages extends Translations {
  final Map<String, Map<String, String>> languages;

  Messages({required this.languages}) : assert(languages != null);

  @override
  Map<String, Map<String, String>> get keys => languages;
}
