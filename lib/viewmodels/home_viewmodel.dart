import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  Map<String, dynamic>? lastRun;
  bool isLoadingLastRun = false;
  bool isLoadingWeek = false;

  double weekDistanceKm = 0.0;
  int weekDurationSec = 0;
  double weekAvgSpeedKmh = 0.0;

  String userName = 'Koşucu';
  String? userPhotoUrl;

  Future<void> init() async {
    await Future.wait([
      fetchLastRun(),
      fetchWeeklyStats(),
      fetchUserName(),
    ]);
    notifyListeners();
  }

  Future<void> fetchLastRun() async {
    try {
      isLoadingLastRun = true;
      notifyListeners();

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        lastRun = null;
        isLoadingLastRun = false;
        notifyListeners();
        return;
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('runs')
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        lastRun = snapshot.docs.first.data();
      } else {
        lastRun = null;
      }
    } catch (_) {
      lastRun = null;
    } finally {
      isLoadingLastRun = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final data = doc.data();
      String? nameFromDb = data != null ? (data['fullName'] as String?) : null;
      String? photoFromDb = data != null ? (data['profilePicture'] as String?) : null;
      String? candidate = nameFromDb?.trim();
      candidate ??= user.displayName?.trim();
      candidate ??= (user.email != null ? user.email!.split('@').first : null);
      String? photoCandidate = (photoFromDb?.trim().isNotEmpty ?? false) ? photoFromDb : user.photoURL;

      if (candidate != null && candidate.isNotEmpty) {
        userName = candidate;
        userPhotoUrl = photoCandidate;
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> fetchWeeklyStats() async {
    try {
      isLoadingWeek = true;
      notifyListeners();

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        weekDistanceKm = 0.0;
        weekDurationSec = 0;
        weekAvgSpeedKmh = 0.0;
        isLoadingWeek = false;
        notifyListeners();
        return;
      }

      final now = DateTime.now();
      final monday = DateTime(now.year, now.month, now.day).subtract(Duration(days: (now.weekday - DateTime.monday)));
      final startOfWeek = DateTime(monday.year, monday.month, monday.day, 0, 0, 0);
      final endOfWeek = startOfWeek.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

      final snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('runs')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfWeek))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfWeek))
          .get();

      double totalDistanceMeters = 0.0;
      int totalDurationSec = 0;
      double avgSpeedSumMs = 0.0;
      int count = 0;

      for (final d in snap.docs) {
        final data = d.data();
        final distance = (data['distance'] as num?)?.toDouble() ?? 0.0;
        final duration = (data['duration'] as num?)?.toInt() ?? 0;
        final avgSpeed = (data['averageSpeed'] as num?)?.toDouble() ?? 0.0;
        totalDistanceMeters += distance;
        totalDurationSec += duration;
        if (avgSpeed > 0) {
          avgSpeedSumMs += avgSpeed;
          count += 1;
        }
      }

      weekDistanceKm = totalDistanceMeters / 1000.0;
      weekDurationSec = totalDurationSec;
      final avgMs = count > 0 ? (avgSpeedSumMs / count) : 0.0;
      weekAvgSpeedKmh = avgMs * 3.6;
    } catch (_) {
      // ignore
    } finally {
      isLoadingWeek = false;
      notifyListeners();
    }
  }
}


