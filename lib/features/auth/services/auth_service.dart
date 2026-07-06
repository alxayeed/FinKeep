import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Stream of user authentication state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Get currently signed-in user
  User? get currentUser => _firebaseAuth.currentUser;

  /// Sign in using email and password
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Sign out current user
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
