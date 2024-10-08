import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<Map<String, dynamic>?> getUserData() async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId == null) {
        print("User ID is null");
        return null;
      }

      DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(userId).get();
      if (userSnapshot.exists && userSnapshot.data() != null) {
        print("User data fetched successfully: ${userSnapshot.data()}");
        return userSnapshot.data() as Map<String, dynamic>?;
      } else {
        print("User data does not exist or is null.");
        return null;
      }
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getUserRuns() async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId == null) {
        print("User ID is null");
        return [];
      }

      QuerySnapshot runsSnapshot = await _firestore.collection('users').doc(userId).collection('runs').get();
      return runsSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print("Error fetching user runs: $e");
      return [];
    }
  }

  Future<bool> logout() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      print("Error during logout: $e");
      return false;
    }
  }

  // Default profil resminin URL'sini alma
  Future<String> getDefaultProfilePictureUrl() async {
    try {
      String defaultImageUrl = await _storage
          .ref('profile_pictures/default_user.png') // Depolama yolunu belirtiyoruz
          .getDownloadURL(); // Download URL'sini alıyoruz

      return defaultImageUrl; // URL'yi geri döndürüyoruz
    } catch (e) {
      print("Error fetching default profile picture URL: $e");
      return ''; // Hata durumunda boş string döndürüyoruz
    }
  }

  Future<void> updateUserProfilePicture(String userId, String downloadUrl) async {
    if (userId.isEmpty || downloadUrl.isEmpty) {
      print("Invalid user ID or download URL");
      return;
    }
    try {
      await _firestore.collection('users').doc(userId).update({'profilePicture': downloadUrl});
    } catch (e) {
      print("Error updating profile picture: $e");
    }
  }

  Future<String> uploadProfileImage(Uint8List imageBytes, String userId) async {

    if (userId.isEmpty || imageBytes.isEmpty) {
      print("Invalid user ID or image bytes");
      return '';
    }
    try {
      Reference storageRef = _storage.ref().child('profile_pictures/$userId.jpg');
      UploadTask uploadTask = storageRef.putData(imageBytes);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Error uploading profile image: $e");
      return '';
    }
  }
}
