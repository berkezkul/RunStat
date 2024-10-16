import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:runstat/data/repositories/auth_repo/login_with_email_and_password_failure.dart';
import 'package:runstat/data/services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _showPassword = false;

  bool get isLoading => _isLoading;
  bool get showPassword => _showPassword;

  final AuthService _authService = AuthService();
  String? errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _showPassword = !_showPassword;
    notifyListeners();
  }

  // Kullanıcı giriş fonksiyonu
  Future<bool> login(String email, String password) async {
    _setLoading(true);

    try {
      User? loggedInUser = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ).then((userCredential) => userCredential.user);

      if (loggedInUser != null) {
        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException catch (e) {
      errorMessage = LoginWithEmailAndPasswordFailure.code(e.code).message;
      return false;
    } catch (e) {
      errorMessage = "An unknown error occurred.";
      return false;
    } finally {
      _setLoading(false);
    }
  }


  Future<bool> loginWithGoogle() async {
    _setLoading(true);

    try {
      final user = await _authService.signInWithGoogle();
      if (user != null) {
        return true;
      }
      _setLoading(false);
      return false;
    } catch (e) {
      errorMessage = e.toString();
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }
}
