import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../data/models/activity_model.dart';

class ActivityViewModel extends ChangeNotifier {
  List<Activity> activities = [];
  bool isLoading = true;

  final String userId;

  ActivityViewModel({required this.userId}) {
    fetchActivities();
  }

  Future<void> fetchActivities() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('runs')
          .get();

      for (var doc in snapshot.docs) {
        print('Document Data: ${doc.data()}');
        activities.add(Activity.fromFirestore(doc.data() as Map<String, dynamic>));
      }

      activities = snapshot.docs
          .map((doc) => Activity.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching activities: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
