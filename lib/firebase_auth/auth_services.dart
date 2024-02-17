import 'package:firebase_auth/firebase_auth.dart';
import 'package:logging/logging.dart';

class FirebaseAuthService {

  final Logger _logger = Logger('FirebaseAuthService');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Send email verification
      await credential.user?.sendEmailVerification();
      _logger.info('Verification email sent to ${credential.user?.email}');

      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        _logger.warning('The email address is already in use.');
      } else {
        _logger.severe('An error occurred: ${e.code}');
      }
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential =
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        _logger.warning('Invalid email or password.');
      } else {
        _logger.severe('An error occurred: ${e.code}');
      }
    }
    return null;
  }
}