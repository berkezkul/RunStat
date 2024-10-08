import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:runstat/data/repositories/auth_repo/login_with_email_and_password_failure.dart';
import 'package:runstat/data/repositories/auth_repo/login_with_email_and_password_failure.dart';
import 'package:runstat/data/repositories/auth_repo/signup_google_failure.dart';

import '../repositories/auth_repo/signup_with_email_and_password_failure.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Login
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      print('Login Error: $e');
      throw LoginWithEmailAndPasswordFailure.code(e.code);
    } catch (e) {
      print('Login Error: $e');
      throw const LoginWithEmailAndPasswordFailure();
    }
  }

  //Sign up
  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      print('Login Error: $e');
      throw SignUpWithEmailAndPasswordFailure.code(e.code);
    } catch (e) {
      print('Login Error: $e');
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  //Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Sign Out Error: $e');
    }
  }

  //Google sign in
  Future<User?> signInWithGoogle() async {
    try {
      // Kullanıcıyı Google ile kimlik doğrulama penceresine yönlendirme
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // Kullanıcı giriş işlemini iptal etti
        return null;
      }

      // Google'dan doğrulama bilgilerini alma
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // Google kimlik bilgilerini Firebase'e gönderip oturum açma
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase'de oturum aç ve kullanıcıyı döndür
      UserCredential userCredential =
      await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print('Google Sign-In Error: $e');
      throw const SignupGoogleFailure();
    }
  }

  User? getCurrentUser() {
    try {
      return _auth.currentUser;
    } catch (e) {
      print('Get Current User Error: $e');
      return null;
    }
  }
}
