import 'dart:convert';

class WishList {
  final String? userId;
  final List<String> productId;

  WishList({
    this.userId,
    this.productId = const [],
  });

  factory WishList.fromMap(Map<String, dynamic> map) {
    return WishList(
      userId: map['userId'] as String?,
      productId: List<String>.from(map['productId'] as List<dynamic>? ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'productId': productId,
    };
  }

  String toJson() => json.encode(toMap());

  factory WishList.fromJson(String source) =>
      WishList.fromMap(json.decode(source) as Map<String, dynamic>);
}
