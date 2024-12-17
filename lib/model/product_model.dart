import 'dart:convert';

List<Product> productFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  final int? id;
  final String? name;
  double? price;
  int? quantity;
  String? coverImage;
  String? description;
  double? discount;
  String? discountType;
  bool? isActive;
  DateTime? createdAt;

  Product({
    this.id,
    this.name,
    this.price,
    this.quantity,
    this.coverImage,
    this.description,
    this.discount,
    this.discountType,
    this.isActive,
    this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Parse id as int
    int? productId;
    if (json['id'] != null) {
      if (json['id'] is int) {
        productId = json['id'];
      } else if (json['id'] is double) {
        productId = (json['id'] as double).toInt();
      } else {
        productId = int.tryParse(json['id'].toString());
      }
    }

    return Product(
      id: productId,
      name: json['name'],
      price: json['price'] != null 
          ? double.tryParse(json['price'].toString()) ?? 0.0
          : 0.0,
      quantity: json['quantity'] != null 
          ? int.tryParse(json['quantity'].toString()) ?? 1
          : 1,
      coverImage: json['cover_image'] ?? json['coverImage'],
      description: json['description'],
      discount: json['discount'] != null 
          ? double.tryParse(json['discount'].toString()) ?? 0.0
          : 0.0,
      discountType: json['discount_type'] ?? json['discountType'],
      isActive: json['is_active'] ?? json['isActive'] ?? true,
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price?.toString(),
      'quantity': quantity?.toString(),
      'cover_image': coverImage,
      'description': description,
      'discount': discount?.toString(),
      'discount_type': discountType,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
