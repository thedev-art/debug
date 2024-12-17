// import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;

  Users({
    this.id,
    this.name,
    this.email,
    this.phone,
  });

  factory Users.fromMap(Map<String, dynamic> data) {
    return Users(
      name: data['name'] as String?,
      email: data['email'] as String?,
      phone: data['phone'] as String?,
      id: data['id'] as String?,
    );
  }
}
