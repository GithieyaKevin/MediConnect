
// lib/services/database_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart' as app;
import '../models/patient.dart';
import '../models/vital_signs.dart';

class DatabaseService {
  final String? uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DatabaseService({this.uid});

  CollectionReference get userCollection => _firestore.collection('users');
  CollectionReference get patientCollection => _firestore.collection('patients');
  CollectionReference get vitalSignsCollection => _firestore.collection('vitalSigns');

  Future<app.UserData?> getUser(String uid) async {
    try {
      final doc = await userCollection.doc(uid).get();
      if (!doc.exists) return null;
      return app.UserData.fromDocument(doc as DocumentSnapshot<Map<String, dynamic>>);
    } catch (e) {
      rethrow;
    }
  }

  Stream<app.UserData?> getUserStream(String uid) {
    return userCollection.doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return app.UserData.fromDocument(doc as DocumentSnapshot<Map<String, dynamic>>);
    });
  }

  Future<void> updateUserData({
    required String name,
    required String email,
    required bool isDoctor,
    String? specialty,
    String? bloodType,
    String? organDonorStatus,
    List<String>? allergies,
    String? profileImageUrl,
  }) async {
    try {
      await userCollection.doc(uid).set({
        'name': name,
        'email': email,
        'isDoctor': isDoctor,
        'specialty': specialty,
        'bloodType': bloodType,
        'organDonorStatus': organDonorStatus,
        'allergies': allergies ?? [],
        'profileImageUrl': profileImageUrl,
      }, SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addPatient(Patient patient) async {
    try {
      await patientCollection.doc(patient.id).set(patient.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Patient>> getPatients() async {
    try {
      final snapshot = await patientCollection.get();
      return snapshot.docs
          .map((doc) => Patient.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addVitalSigns(VitalSigns vitalSigns) async {
    try {
      await vitalSignsCollection.doc(vitalSigns.id).set(vitalSigns.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<List<VitalSigns>> getVitalSigns(String patientId) async {
    try {
      final snapshot = await vitalSignsCollection
          .where('patientId', isEqualTo: patientId)
          .get();
      return snapshot.docs
          .map((doc) => VitalSigns.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
