import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../data/services/firebase_service.dart';
import 'dart:typed_data';

class UpdateProfileViewModel extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  Map<String, dynamic>? _userData;
  List<Map<String, dynamic>> _runsData = [];
  bool _isLoading = true;

  Map<String, dynamic>? get userData => _userData;
  List<Map<String, dynamic>> get runsData => _runsData;
  bool get isLoading => _isLoading;

  Uint8List? profileImage;
  String? profileImageUrl;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  UpdateProfileViewModel() {
    _loadUserData();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void selectImage() async {
    Uint8List? img = await ImagePicker().pickImage(source: ImageSource.gallery).then((xfile) => xfile?.readAsBytes());
    if (img != null) {
      profileImage = img;
      notifyListeners();
    }
  }

  Future<void> _loadUserData() async {
    var userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      var snapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      var userData = snapshot.data();

      fullNameController.text = userData?['fullName'] ?? '';
      emailController.text = userData?['email'] ?? '';
      phoneController.text = userData?['phoneNo'] ?? '';

      // Mevcut profil resmini al
      profileImageUrl = userData?['profilePicture'];

      // Eğer bir profil resmi varsa, Storage'dan indirip profileImage değişkenine ata
      if (profileImageUrl != null && profileImageUrl!.isNotEmpty) {
        profileImage = await _firebaseService.downloadProfileImage(profileImageUrl!);
      }

      notifyListeners(); // Güncellemeleri dinleyiciye ilet
    }
  }

  Future<void> updateProfile(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      var userId = FirebaseAuth.instance.currentUser?.uid;
      try {
        // Profil bilgilerini güncelleme
        await FirebaseFirestore.instance.collection('users').doc(userId).update({
          'fullName': fullNameController.text,
          'email': emailController.text,
          'phoneNo': phoneController.text,
        });

        // Eğer yeni bir profil resmi seçildiyse güncelle
        if (profileImage != null) {
          String downloadUrl = await _firebaseService.uploadProfileImage(profileImage!, userId!);
          await _firebaseService.updateUserProfilePicture(userId, downloadUrl);
        }
        Navigator.of(context).pop(); // Önceki sayfaya dön
        notifyListeners();
      } catch (e) {
        // Hata durumunda bir mesaj gösterebiliriz
        print("Error updating profile: $e");
      }
    }
  }
}
