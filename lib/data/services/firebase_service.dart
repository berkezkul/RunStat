import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> _getCurrentUserId() async {
    User? user = _auth.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      print("User is not logged in");
      return null;
    }
  }


  Future<Map<String, dynamic>?> getUserData() async {
    String? userId = await _getCurrentUserId(); // Kullanıcı ID'sini güvenli bir şekilde alıyoruz
    if (userId == null) {
      return null;
    }

    try {
      DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(userId).get();
      return userSnapshot.data() as Map<String, dynamic>?;
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getUserRuns() async {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) {
      print("User ID is null");
      return [];
    }

    try {
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

  Future<String> getDefaultProfilePictureUrl() async {
    try {
      return await _storage.ref('profile_pictures/default_user.png').getDownloadURL();
    } catch (e) {
      print("Error fetching default profile picture URL: $e");
      return '';
    }
  }

  Future<void> updateUserProfilePicture(String? userId, String? downloadUrl) async {
    // Kullanıcı ID'sini yine güvenli bir şekilde alıyoruz
    //userId = userId ?? await _getCurrentUserId();

    User? currentUser = FirebaseAuth.instance.currentUser;
    String? userId = currentUser?.uid;



    if (userId == null || userId.isEmpty || downloadUrl == null || downloadUrl.isEmpty) {
      print("Invalid user ID or download URL");
      return;
    }

    try {
      // Firestore'da kullanıcının profil fotoğrafı alanını güncelliyoruz
      await _firestore.collection('users').doc(userId).update({'profilePicture': downloadUrl});
      print("Profile picture updated successfully for user: $userId");
    } catch (e) {
      print("Error updating profile picture: $e");
    }
  }

  Future<String> uploadProfileImage(Uint8List imageBytes, String? userId) async {
    // Eğer userId null ise, oturum açan kullanıcı ID'sini alıyoruz
    //userId = userId ?? await _getCurrentUserId();
    User? currentUser = FirebaseAuth.instance.currentUser;
    String? userId = currentUser?.uid; // Eğer currentUser null ise, parametreyi kullan


    // Eğer userId ya da imageBytes boşsa işlemi durduruyoruz
    if (userId == null || imageBytes.isEmpty) {
      print("Invalid user ID or image bytes");
      return '';
    }

    try {
      // Firebase Storage'a resmi yüklüyoruz
      Reference storageRef = _storage.ref().child('profile_pictures/$userId.jpg');
      TaskSnapshot snapshot = await storageRef.putData(imageBytes);

      // Yükleme başarılıysa indirme URL'sini döndürüyoruz
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Error uploading profile image: $e");
      return '';
    }
  }
}
