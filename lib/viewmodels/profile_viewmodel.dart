import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier {
  Map<String, dynamic>? _userData;
  List<Map<String, dynamic>> _runsData = [];
  bool _isLoading = true;

  Map<String, dynamic>? get userData => _userData;
  List<Map<String, dynamic>> get runsData => _runsData;
  bool get isLoading => _isLoading;

  ProfileViewModel() {
    _fetchUserDataAndRuns();
  }

  Future<void> _fetchUserDataAndRuns() async {
    try {
      // Kullanıcı bilgilerini users koleksiyonundan al
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();
      _userData = userSnapshot.data() as Map<String, dynamic>?;

      // Kullanıcının aktivitelerini runs koleksiyonundan al
      QuerySnapshot runsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('runs')
          .get();

      // runs verilerini bir listeye dönüştür
      _runsData = runsSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Error fetching user data or runs: $e");
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
