import 'package:amanuel_glass/model/language_model.dart';
import 'package:amanuel_glass/model/product_model.dart';

class AppConstants {
  static const String LANGUAGE_CODE = 'language_code';
  static const String COUNTRY_CODE = 'en';
  static List<LanguageModel> languages = [
    LanguageModel(
        languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel(languageName: 'አማርኛ', countryCode: 'ET', languageCode: 'am'),
  ];

  static final List<Product> products = [
    Product(
      id: 1,
      name: 'Glass Window',
      description: 'High quality glass window',
      price: 1500,
      coverImage: 'https://picsum.photos/200/300',
      // images: [
      //   'https://picsum.photos/200/300',
      //   'https://picsum.photos/200/300'
      // ],
      // categoryId: 'cat1',
      isActive: true,
      discount: 10,
      discountType: 'percentage',
    ),
    Product(
      id: 1,
      name: 'Glass Window',
      description: 'High quality glass window',
      price: 1500,
      coverImage: 'https://picsum.photos/200/300',
      // images: [
      //   'https://picsum.photos/200/300',
      //   'https://picsum.photos/200/300'
      // ],
      // categoryId: 'cat1',
      isActive: true,
      discount: 10,
      discountType: 'percentage',
    ),
  ];
}
