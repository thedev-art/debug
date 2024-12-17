// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

class Category {
  // ignore: duplicate_ignore
  // ignore: non_constant_identifier_names
  final String? category_id;
  final String? img;
  final String? name;
  final bool? status;

  Category({
    this.category_id,
    this.img,
    this.name,
    this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'category_id': category_id,
      'img': img,
      'name': name,
      'status': status,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      category_id: map['category_id'] as String?,
      img: map['img'] as String?,
      name: map['name'] as String?,
      status: map['status'] as bool?,
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source) as Map<String, dynamic>);
}
