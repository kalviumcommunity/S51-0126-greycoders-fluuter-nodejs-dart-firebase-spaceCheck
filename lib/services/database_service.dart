import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../models/space_model.dart';

class DatabaseService {
  // Singleton pattern
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  // Firestore instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection References
  CollectionReference get usersCollection => _db.collection('users');
  CollectionReference get spacesCollection => _db.collection('spaces');

  // Spaces Stream
  Stream<List<SpaceModel>> getSpaces() {
    return spacesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => SpaceModel.fromFirestore(doc)).toList();
    });
  }

  // Check In Transaction
  Future<void> checkIn(String spaceId, String userId) async {
    return _db.runTransaction((transaction) async {
      DocumentReference spaceRef = spacesCollection.doc(spaceId);
      DocumentSnapshot spaceSnapshot = await transaction.get(spaceRef);

      if (!spaceSnapshot.exists) {
        throw Exception("Space does not exist!");
      }

      SpaceModel space = SpaceModel.fromFirestore(spaceSnapshot);

      if (space.status == 'closed') {
        throw Exception("Space is closed currently.");
      }

      if (space.currentOccupancy >= space.maxCapacity) {
        throw Exception("Space is at full capacity!");
      }

      // Check if user is already checked in? (Basic logic for now)
      // Ideally we'd check a logs collection, but for this PR we update the Space doc.
      
      int newOccupancy = space.currentOccupancy + 1;
      String newStatus = space.status;
      if (newOccupancy >= space.maxCapacity) {
        newStatus = 'occupied'; // Full
      }

      transaction.update(spaceRef, {
        'currentOccupancy': newOccupancy,
        'status': newStatus,
        'lastUpdatedAt': FieldValue.serverTimestamp(),
        // Only set occupiedBy if it's a single-user space or tracked logic requires it
        // For simple shared spaces, we might skip overwriting occupiedBy unless appropriate
        if (space.maxCapacity == 1) 'occupiedBy': userId,
        if (newOccupancy == 1) 'occupiedSince': FieldValue.serverTimestamp(),
      });
    });
  }

  // Create User
  Future<void> createUser({
    required String name,
    required String email,
    required String password,
    required String apartmentNumber,
  }) async {
    try {
      // 1. Create Auth User
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Create Firestore User Document
      if (cred.user != null) {
        UserModel user = UserModel(
          id: cred.user!.uid,
          email: email,
          name: name,
          apartmentNumber: apartmentNumber,
          role: 'resident', // Default role
          // createdAt handled by toMap() if null
        );

        await usersCollection.doc(user.id).set(user.toMap());
      }
    } catch (e) {
      rethrow; // Pass error to UI
    }
  }

  // Test Connection method
  Future<void> logConnection() async {
    print("DatabaseService connected to Firestore instance");
  }
}
