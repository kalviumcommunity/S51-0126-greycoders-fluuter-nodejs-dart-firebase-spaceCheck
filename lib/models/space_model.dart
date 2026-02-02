import 'package:cloud_firestore/cloud_firestore.dart';

class SpaceModel {
  final String id;
  final String name;
  final String type; // gym, pool, hall, etc.
  final String status; // available, occupied, closed
  final String? occupiedBy; // userId
  final DateTime? occupiedSince;
  final String? openTime; // "05:00"
  final String? closeTime; // "22:00"
  final DateTime? lastUpdatedAt;

  SpaceModel({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    this.occupiedBy,
    this.occupiedSince,
    this.openTime,
    this.closeTime,
    this.lastUpdatedAt,
  });

  // Factory to read from Firestore
  factory SpaceModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return SpaceModel(
      id: doc.id,
      name: data['name'] ?? '',
      type: data['type'] ?? 'general',
      status: data['status'] ?? 'available',
      occupiedBy: data['occupiedBy'],
      occupiedSince: data['occupiedSince'] != null
          ? (data['occupiedSince'] as Timestamp).toDate()
          : null,
      openTime: data['openTime'],
      closeTime: data['closeTime'],
      lastUpdatedAt: data['lastUpdatedAt'] != null
          ? (data['lastUpdatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  // To Map for writing
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'status': status,
      'occupiedBy': occupiedBy,
      'occupiedSince': occupiedSince,
      'openTime': openTime,
      'closeTime': closeTime,
      'lastUpdatedAt': lastUpdatedAt ?? FieldValue.serverTimestamp(),
    };
  }
}
