// activity_view_model.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/activity_model.dart';

class ActivityViewModel extends ChangeNotifier {
  List<Activity> activities = [];
  bool isLoading = true;

  ActivityViewModel() {
    fetchActivities();
  }

  Future<void> fetchActivities() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('runs').get();
      activities = snapshot.docs.map((doc) => Activity.fromFirestore(doc.data())).toList();
    } catch (e) {
      // Hata yönetimi
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
