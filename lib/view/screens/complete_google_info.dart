import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'bottom_navigation_bar.dart';

class CompleteUserInfoPage extends StatefulWidget {
  final User user;

  const CompleteUserInfoPage({Key? key, required this.user}) : super(key: key);

  @override
  _CompleteUserInfoPageState createState() => _CompleteUserInfoPageState();
}

class _CompleteUserInfoPageState extends State<CompleteUserInfoPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fullNameController.text = widget.user.displayName ?? '';
    _phoneNumberController.text = widget.user.phoneNumber ?? '';
  }

  Future<void> _saveProfile() async {
    String fullName = _fullNameController.text.trim();
    String phoneNumber = _phoneNumberController.text.trim();

    if (fullName.isEmpty || phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("All fields are required.")),
      );
      return;
    }

    try {
      // Firestore'daki user collection'ına verileri kaydetme
      await _firestore.collection('users').doc(widget.user.uid).set({
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'email': widget.user.email,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const BottomNavigationPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving profile information: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complete Your Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveProfile,
              child: Text('Save Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
