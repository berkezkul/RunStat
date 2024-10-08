import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../data/services/firebase_service.dart';

class ProfileViewModel extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

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
      _isLoading = true;
      notifyListeners();

      _userData = await _firebaseService.getUserData();

      // Kullanıcı verisi null değilse ve profil resmi yoksa, varsayılan resim atanıyor
      if (_userData != null) {
        if (_userData!['profilePicture'] == null || _userData!['profilePicture'] is! String || _userData!['profilePicture'].isEmpty) {
          String defaultProfilePictureUrl = await _firebaseService.getDefaultProfilePictureUrl();
          _userData!['profilePicture'] = defaultProfilePictureUrl;
        }
      } else {
        print("User data is null.");
      }

      print("User Data: $_userData");
      _runsData = await _firebaseService.getUserRuns();
    } catch (e) {
      print("Error fetching user data or runs: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> logout(BuildContext context) async {
    bool success = await _firebaseService.logout();
    return success;
  }

  Future<void> saveProfileImage(Uint8List imageBytes, String userId) async {
    try {
      if (_userData == null) {
        print("User data is not available to update profile picture.");
        return;
      }

      _isLoading = true;
      notifyListeners();



      // Resmi Firebase Storage'a yükle
      String downloadUrl = await _firebaseService.uploadProfileImage(imageBytes, userId);

      // Kullanıcı profil resmini Firestore'da güncelle
      if (downloadUrl.isNotEmpty) {
        await _firebaseService.updateUserProfilePicture(userId, downloadUrl);

        // Güncellenen URL'i local olarak güncelle
        _userData!['profilePicture'] = downloadUrl;
      }
    } catch (e) {
      print("Error saving profile picture: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
