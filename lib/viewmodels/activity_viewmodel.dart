import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../data/models/activity_model.dart';

class ActivityViewModel extends ChangeNotifier {
  List<Activity> activities = [];
  bool isLoading = true;

  final String userId; // Kullanıcı ID'si eklendi

  ActivityViewModel({required this.userId}) {
    fetchActivities();
  }

  Future<void> fetchActivities() async {
    try {
      // 'users' koleksiyonundaki belirli bir kullanıcıyı buluyoruz
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId) // Belirli bir kullanıcı ID'sini kullanıyoruz
          .collection('runs') // Kullanıcının 'runs' koleksiyonuna ulaşıyoruz
          .get();
      for (var doc in snapshot.docs) {
        print('Document Data: ${doc.data()}'); // Veriyi kontrol et
        activities.add(Activity.fromFirestore(doc.data() as Map<String, dynamic>));
      }

      // Gelen veriyi `Activity` modeline dönüştürüyoruz
      activities = snapshot.docs
          .map((doc) => Activity.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Hata yönetimi
      print('Error fetching activities: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
