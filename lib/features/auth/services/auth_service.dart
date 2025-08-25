import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;

  // This method now returns a String? (an error message) instead of UserCredential?
  Future<String?> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // Return null on success
    } on FirebaseAuthException catch (e) {
      return e.message; // Return the specific error message on failure
    }
  }

  Future<String?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Return null on success
    } on FirebaseAuthException catch (e) {
      return e.message; // Return the specific error message on failure
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
