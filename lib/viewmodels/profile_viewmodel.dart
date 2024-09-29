import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  Map<String, dynamic>? get userData => _userData;
  bool get isLoading => _isLoading;

  ProfileViewModel() {
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();
      _userData = snapshot.data() as Map<String, dynamic>?;
    } catch (e) {
      print("Error fetching user data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      return true; // Çıkış işlemi başarılı
    } catch (e) {
      print("Error during logout: $e");
      return false; // Çıkış işlemi başarısız
    }
  }
}
