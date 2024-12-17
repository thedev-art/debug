// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:amanuel_glass/controller/location_controller.dart';
import 'package:amanuel_glass/model/address_model.dart';
import 'package:amanuel_glass/model/coupon_model.dart';
import 'package:amanuel_glass/model/product_model.dart';
import 'package:amanuel_glass/model/user_model.dart';
import 'package:get/get.dart';

class Order {
  // String? id;
  int? id;
  String? orderid;
  DateTime? date;
  dynamic totalPrice;
  AddressModel? deliveryAddress;
  String? status;
  List<Product>? items;
  Coupon? coupon;
  Review? reviews;
  dynamic discount;
  String? userPhone;
  Users? user;
  PaymentMethod? paymentMethod;
  String? paymentMethodString;
  String? additionalLocation;

  Order({
    this.id,
    this.orderid,
    this.date,
    this.totalPrice,
    this.deliveryAddress,
    this.status,
    this.items,
    this.coupon,
    this.reviews,
    this.discount,
    this.userPhone,
    this.user,
    this.paymentMethod,
    this.paymentMethodString,
    this.additionalLocation,
  });

  Map<String, dynamic> toJson() {
    print('=== Serializing Order ===');
    
    // Format products as a simple array of objects
    final productsJson = items?.map((item) => {
      'id': item.id.toString(),  // Convert to string
      'quantity': item.quantity.toString(),  // Convert to string
      'price': item.price.toString()  // Convert to string
    }).toList() ?? [];
    
    LocationController locationController = Get.find<LocationController>();
    
    return {
      'name': user?.name ?? '',
      'phone': user?.phone ?? '',
      'products': productsJson,
      'total_price': totalPrice?.toString() ?? '0',  // Convert to string
      'coupon_title': coupon?.code ?? '',
      'payment_method': paymentMethodString ?? 'cash_on_delivery',
      'payment_method_details': {
        'payment_type': paymentMethod?.paymentType ?? 'cash_on_delivery',
        'full_name': user?.name ?? '',
        'address': paymentMethod?.address ?? '',
        'receipt_photo': paymentMethod?.receiptPhoto ?? '',
        'transaction_reference': paymentMethod?.transactionReference ?? ''
      },
      'delivery_address': {
        'street_address': locationController.addressModel.street ?? '',
        'city': locationController.addressModel.subLocality ?? '',
        'state': locationController.addressModel.locality ?? '',
        'country': 'Ethiopia',
        'latitude': locationController.latitude.value.toString(),  // Convert to string
        'longtude': locationController.longitude.value.toString()  // Convert to string
      },
      'additional_address': additionalLocation ?? ''
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as int?,
      orderid: map['order_id'] as String?,
      date: map['date']?.toDate(),
      totalPrice: map['total_price'],
      deliveryAddress: map['deliveryAddress'] != null
          ? AddressModel.fromJson(
              map['deliveryAddress'] as Map<String, dynamic>)
          : null,
      status: map['status'] as String?,
      items: map['items'] != null
          ? List<Product>.from(
              (map['items'] as List).map<Product>(
                (x) => Product.fromJson(x as Map<String, dynamic>),
              ),
            )
          : null,
      coupon: map['coupon'] != null
          ? Coupon.fromSnapshot(map['coupon'] as Map<String, dynamic>)
          : null,
      reviews: map['reviews'] != null
          ? Review.fromMap(map['reviews'] as Map<String, dynamic>)
          : null,
      discount: map['discount'],
      user: map['user'] != null
          ? Users.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      userPhone: map['user_phone'] as String?,
      paymentMethodString: map['payment_method'] as String?,
      paymentMethod: map['payment_method_details'] != null
          ? PaymentMethod.fromMap(
              map['payment_method_details'] as Map<String, dynamic>)
          : null,
      additionalLocation: map['additional_location'] as String?,
    );
  }

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Review {
  String? userId;
  String? comment;
  dynamic rating;

  Review({
    this.userId,
    this.comment,
    this.rating,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'comment': comment,
      'rating': rating,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      userId: map['userId'] as String?,
      comment: map['comment'] as String?,
      rating: map['rating'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Review.fromJson(String source) =>
      Review.fromMap(json.decode(source) as Map<String, dynamic>);
}

class PaymentMethod {
  final String? paymentType;
  final String? receiptPhoto;
  final String? transactionReference;
  final String? fullName;
  final String? address;

  PaymentMethod({
    this.paymentType,
    this.fullName,
    this.address,
    this.receiptPhoto,
    this.transactionReference,
  });

  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    return PaymentMethod(
      paymentType: map['payment_type'] as String?,
      fullName: map['full_name'] as String?,
      address: map['address'] as String?,
      receiptPhoto: map['receipt_photo'] as String?,
      transactionReference: map['transaction_reference'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'payment_type': paymentType,
      'full_name': fullName,
      'address': address,
      'receipt_photo': receiptPhoto,
      'transaction_reference': transactionReference
    };
  }
}
