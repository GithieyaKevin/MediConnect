
// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../services/database_service.dart';
import '../models/app_user.dart' as app;

class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  firebase_auth.User? get currentUser => _auth.currentUser;
  Stream<firebase_auth.User?> get user => _auth.authStateChanges();

  Future<firebase_auth.User?> signInWithEmail(String email, String password) async {
    try {
      _isLoading = true;
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _isLoading = false;
      return result.user;
    } catch (e) {
      _isLoading = false;
      rethrow;
    }
  }

  Future<firebase_auth.User?> signUpWithEmail(
    String email,
    String password,
    String name,
    bool isDoctor,
  ) async {
    try {
      _isLoading = true;
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;
      if (user != null) {
        final databaseService = DatabaseService(uid: user.uid);
        await databaseService.updateUserData(
          name: name,
          email: email,
          isDoctor: isDoctor,
          specialty: isDoctor ? '' : null,
          bloodType: isDoctor ? null : '',
          organDonorStatus: isDoctor ? null : '',
          allergies: [],
        );
      }
      _isLoading = false;
      return user;
    } catch (e) {
      _isLoading = false;
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
