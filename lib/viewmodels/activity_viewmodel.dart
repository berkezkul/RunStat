import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../data/models/activity_model.dart';

class ActivityViewModel extends ChangeNotifier {
  List<Activity> activities = [];
  List<Activity> filteredActivities = [];
  bool isLoading = true;
  final String userId;
  String selectedCriterion = 'Date';
  bool ascendingOrder = true;

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

      activities = snapshot.docs
          .map((doc) => Activity.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
      filteredActivities = activities;
    } catch (e) {
      print('Error fetching activities: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void filterActivities(String searchText) {
    if (searchText.isEmpty) {
      filteredActivities = activities;
    } else {
      filteredActivities = activities.where((activity) {
        final formattedDate = DateFormat('dd.MM.yyyy').format(DateTime.parse(activity.date));
        final distanceString = activity.distance.toString();

        // that matches exactly (e.g., '45' in '450' or '145')
        final bool distanceMatch = distanceString.contains(RegExp(r'\b' + RegExp.escape(searchText)));

        return distanceMatch || formattedDate.contains(searchText);
      }).toList();
    }
    notifyListeners();
  }

  void sortByDate(bool ascending) {
    filteredActivities.sort((a, b) => ascending ? a.date.compareTo(b.date) : b.date.compareTo(a.date));
    notifyListeners();
  }

  void sortByDistance(bool ascending) {
    filteredActivities.sort((a, b) => ascending ? a.distance.compareTo(b.distance) : b.distance.compareTo(a.distance));
    notifyListeners();
  }
}
