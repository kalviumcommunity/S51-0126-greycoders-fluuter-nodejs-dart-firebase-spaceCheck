import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  // Singleton pattern
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  // Firestore instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Collection References
  CollectionReference get usersCollection => _db.collection('users');
  CollectionReference get spacesCollection => _db.collection('spaces');

  // Test Connection method
  Future<void> logConnection() async {
    print("DatabaseService connected to Firestore instance");
  }
}
