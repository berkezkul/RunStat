import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:runstat/data/models/user_model.dart';
import '../data/services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _showPassword = false;

  bool get isLoading => _isLoading;
  bool get showPassword => _showPassword;

  // AuthService ile giriş işlemi yönetme
  final AuthService _authService = AuthService();
  String? errorMessage;

  // Şifre görünürlüğünü değiştirme fonksiyonu
  void togglePasswordVisibility() {
    _showPassword = !_showPassword;
    notifyListeners();
  }

  // Kullanıcı giriş yapma fonksiyonu
  Future<void> login(UserModel user, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      // AuthService ile kullanıcı giriş işlemi
      User? loggedInUser = await _authService.signInWithEmailAndPassword(
        user.email,
        user.password,
      );

      if (loggedInUser != null) {
        // Giriş başarılı, ana sayfaya yönlendirme yapılabilir.
        Navigator.pushNamed(context, '/home');
      } else {
        // Eğer kullanıcı null ise bir hata oluşmuş demektir.
        _showErrorSnackbar(context, 'An unknown error occurred.');
      }
    } on FirebaseAuthException catch (e) {
      // FirebaseAuthException yakalandığında ilgili hata mesajını göster
      _showErrorSnackbar(context, _getErrorMessage(e.code));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Hata mesajını SnackBar ile gösterme fonksiyonu
  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Hata kodlarına göre kullanıcıya gösterilecek mesajları hazırlayan fonksiyon
  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'User not found. Please sign up first.';
      case 'wrong-password':
        return 'Incorrect password. Try again.';
      case 'invalid-email':
        return 'Invalid email format. Please check your email.';
      default:
        return 'An unknown error occurred. Please try again.';
    }
  }
}
