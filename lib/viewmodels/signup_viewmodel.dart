import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:runstat/data/repositories/auth_repo/signup_with_email_and_password_failure.dart';

class SignupViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? errorMessage;


  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> registerUser(String email, String password, String fullName, String phoneNo) async {
    try {
      _setLoading(true);

      // Create user with email and password
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Save additional user info to Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'fullName': fullName,
          'email': email,
          'phoneNo': phoneNo,
          'signupDate': DateTime.now().toIso8601String(), // Store signup date
        });
        return true;
      }

      return false;
    }  on FirebaseAuthException catch (e) {
      errorMessage = SignUpWithEmailAndPasswordFailure.code(e.code).message;
      return false;
    } catch (e) {
      errorMessage = "An unknown error occurred.";
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
