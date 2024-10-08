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
    _setLoading(true);
    try {
      _userData = await _firebaseService.getUserData();

      if (_userData != null && !_hasValidProfilePicture(_userData!['profilePicture'])) {
        String defaultProfilePictureUrl = await _firebaseService.getDefaultProfilePictureUrl();
        _userData!['profilePicture'] = defaultProfilePictureUrl;
      }
      _runsData = await _firebaseService.getUserRuns();
    } catch (e) {
      print("Error fetching user data or runs: $e");
    } finally {
      _setLoading(false);
    }
  }

  bool _hasValidProfilePicture(String? profilePicture) {
    return profilePicture != null && profilePicture is String && profilePicture.isNotEmpty;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> logout(BuildContext context) async {
    return await _firebaseService.logout();
  }

  Future<void> saveProfileImage(Uint8List imageBytes, String userId) async {
    if (_userData == null) {
      print("User data is not available to update profile picture.");
      return;
    }

    _setLoading(true);
    try {
      String downloadUrl = await _firebaseService.uploadProfileImage(imageBytes, userId);
      if (downloadUrl.isNotEmpty) {
        await _firebaseService.updateUserProfilePicture(userId, downloadUrl);
        _userData!['profilePicture'] = downloadUrl;
      }
    } catch (e) {
      print("Error saving profile picture: $e");
    } finally {
      _setLoading(false);
    }
  }
}
