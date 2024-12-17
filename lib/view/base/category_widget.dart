import 'package:cached_network_image/cached_network_image.dart';
import 'package:amanuel_glass/helper/images.dart';
import 'package:amanuel_glass/model/category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    super.key,
    required this.fem,
    required this.ffem,
    required this.name,
    required this.images,
    required this.category,
    this.catagories = const [],
  });

  final double fem;
  final double ffem;
  final String name;
  final String images;
  final Category category;
  final List<String> catagories;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed('cat_detail', arguments: {
          'cat_id': category.category_id,
          'cat_name': category.name
        });
      },
      child: Column(
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: images.isNotEmpty
                    ? images
                    : 'https://picsum.photos/100/100',
                placeholder: (context, url) =>
                    Image.asset(Images.placeholder, fit: BoxFit.cover),
                errorWidget: (context, url, error) =>
                    Image.asset(Images.placeholder, fit: BoxFit.cover),
                fit: BoxFit.cover,
                width: 100,
                height: 100,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            name,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              fontSize: 14 * ffem,
              fontWeight: FontWeight.w400,
              height: 1.2125 * ffem / fem,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
