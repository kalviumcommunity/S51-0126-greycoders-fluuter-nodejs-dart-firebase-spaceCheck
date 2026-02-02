import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final String apartmentNumber;
  final String role;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.apartmentNumber,
    required this.role,
    this.createdAt,
  });

  // Factory constructor to create a UserModel from Firestore DocumentSnapshot
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      apartmentNumber: data['apartmentNumber'] ?? '',
      role: data['role'] ?? 'resident',
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  // Method to convert UserModel to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'apartmentNumber': apartmentNumber,
      'role': role,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}
