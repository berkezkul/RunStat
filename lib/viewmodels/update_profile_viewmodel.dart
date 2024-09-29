import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdateProfileViewModel extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  UpdateProfileViewModel() {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    var userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      var snapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      var userData = snapshot.data();

      fullNameController.text = userData?['fullName'] ?? '';
      emailController.text = userData?['email'] ?? '';
      phoneController.text = userData?['phone'] ?? '';
    }
  }

  Future<void> updateProfile() async {
    if (formKey.currentState?.validate() ?? false) {
      var userId = FirebaseAuth.instance.currentUser?.uid;
      try {
        await FirebaseFirestore.instance.collection('users').doc(userId).update({
          'fullName': fullNameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          // Şifre güncelleme işlemi eklenebilir
        });
        // Başarılı güncelleme sonrası bir mesaj gösterebiliriz
        notifyListeners();
      } catch (e) {
        // Hata durumunda bir hata mesajı gösterebilirsiniz
      }
    }
  }
}
