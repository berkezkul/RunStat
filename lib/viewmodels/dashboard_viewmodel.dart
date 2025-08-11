import 'package:flutter/material.dart';
import 'package:runstat/data/services/goal_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardViewModel extends ChangeNotifier {
  final GoalService _goalService;

  double _goalDistance = 0.0; // Günlük hedef mesafe
  double _completedDistance = 0.0; // Tamamlanan mesafe
  double _percentage = 0.0; // Tamamlama yüzdesi

  // Weekly summary
  double weeklyDistanceKm = 0.0;
  int weeklyDurationSec = 0;
  double weeklyAvgSpeedKmh = 0.0;

  // Trend 7 gün (Pazartesi -> Pazar)
  List<double> dailyKm = List<double>.filled(7, 0.0);

  // Haftanın en'leri
  double bestLongestDistanceKm = 0.0;
  String bestLongestRouteName = '';
  double bestFastestKmh = 0.0;
  String bestFastestRouteName = '';
  String mostFrequentRouteName = '';
  int mostFrequentRouteCount = 0;

  // Streak (ardışık gün)
  int streakDays = 0;

  // Last run summary
  String lastRouteName = '';
  double lastDistanceKm = 0.0;
  int lastDurationSec = 0;
  DateTime? lastDate;

  double get goalDistance => _goalDistance;
  double get completedDistance => _completedDistance;
  double get percentage => _percentage;

  DashboardViewModel() : _goalService = GoalService();

  // Günlük tamamlanan mesafeyi getirir
  Future<void> fetchDailyDistance() async {
    _completedDistance = await _goalService.getDailyDistance();
    _goalDistance = await _goalService.getGoalDistance(); // Burada hedef mesafeyi alıyoruz
    _updatePercentage();
    notifyListeners();
  }

  // Kullanıcı tarafından girilen hedef mesafeyi ayarlar
  void setGoalDistance(double value) {
    _goalDistance = value;
    _updatePercentage();
    notifyListeners();
  }

  // Tamamlama yüzdesini günceller
  void _updatePercentage() {
    if (_goalDistance > 0) {
      _percentage = (_completedDistance / _goalDistance).clamp(0.0, 1.0);
    } else {
      _percentage = 0.0;
    }
  }

  // Hedefi kaydetmek için kullanılan metot
  Future<void> saveGoal() async {
    await _goalService.saveGoal(_goalDistance, _completedDistance, _percentage);
    notifyListeners(); // Değişiklikleri UI'a bildirir
  }

  Future<void> init() async {
    await fetchDailyDistance();
    await Future.wait([
      fetchWeeklyStats(),
      fetchTrend7Days(),
      fetchBestsOfWeek(),
      fetchStreak(),
      fetchLastRun(),
    ]);
    notifyListeners();
  }

  DateTime _startOfWeek(DateTime now) {
    final monday = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: (now.weekday - DateTime.monday)));
    return DateTime(monday.year, monday.month, monday.day, 0, 0, 0);
  }

  DateTime _endOfWeek(DateTime start) {
    return start.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
  }

  Future<QuerySnapshot<Map<String, dynamic>>> _weeklyRunsSnapshot() {
    final user = FirebaseAuth.instance.currentUser;
    final start = _startOfWeek(DateTime.now());
    final end = _endOfWeek(start);
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('runs')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .get();
  }

  Future<void> fetchWeeklyStats() async {
    try {
      final snap = await _weeklyRunsSnapshot();
      double totalDistanceMeters = 0.0;
      int totalDuration = 0;
      double avgSpeedSum = 0.0;
      int cnt = 0;
      for (final d in snap.docs) {
        final data = d.data();
        totalDistanceMeters += (data['distance'] as num?)?.toDouble() ?? 0.0;
        totalDuration += (data['duration'] as num?)?.toInt() ?? 0;
        final avg = (data['averageSpeed'] as num?)?.toDouble() ?? 0.0; // m/s
        if (avg > 0) {
          avgSpeedSum += avg;
          cnt += 1;
        }
      }
      weeklyDistanceKm = totalDistanceMeters / 1000.0;
      weeklyDurationSec = totalDuration;
      weeklyAvgSpeedKmh = (cnt > 0 ? (avgSpeedSum / cnt) : 0.0) * 3.6;
    } catch (e) {
      // ignore
    }
    notifyListeners();
  }

  Future<void> fetchTrend7Days() async {
    try {
      final snap = await _weeklyRunsSnapshot();
      final start = _startOfWeek(DateTime.now());
      dailyKm = List<double>.filled(7, 0.0);
      for (final d in snap.docs) {
        final data = d.data();
        final ts = data['date'];
        DateTime? dateTime;
        if (ts is Timestamp) dateTime = ts.toDate();
        if (ts is String) dateTime = DateTime.tryParse(ts);
        if (dateTime == null) continue;
        final dayIndex = dateTime.difference(start).inDays;
        if (dayIndex >= 0 && dayIndex < 7) {
          dailyKm[dayIndex] += ((data['distance'] as num?)?.toDouble() ?? 0.0) / 1000.0;
        }
      }
    } catch (e) {
      // ignore
    }
    notifyListeners();
  }

  Future<void> fetchBestsOfWeek() async {
    try {
      final snap = await _weeklyRunsSnapshot();
      double longestMeters = 0.0;
      String longestName = '';
      double fastestMs = 0.0;
      String fastestName = '';
      final Map<String, int> routeCount = {};

      for (final d in snap.docs) {
        final data = d.data();
        final dist = (data['distance'] as num?)?.toDouble() ?? 0.0;
        final avg = (data['averageSpeed'] as num?)?.toDouble() ?? 0.0;
        final name = (data['route_name'] as String?) ?? (data['routeName'] as String?) ?? '';
        if (dist > longestMeters) {
          longestMeters = dist;
          longestName = name;
        }
        if (avg > fastestMs) {
          fastestMs = avg;
          fastestName = name;
        }
        if (name.isNotEmpty) {
          routeCount[name] = (routeCount[name] ?? 0) + 1;
        }
      }

      bestLongestDistanceKm = longestMeters / 1000.0;
      bestLongestRouteName = longestName;
      bestFastestKmh = fastestMs * 3.6;
      bestFastestRouteName = fastestName;

      if (routeCount.isNotEmpty) {
        final sorted = routeCount.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        mostFrequentRouteName = sorted.first.key;
        mostFrequentRouteCount = sorted.first.value;
      } else {
        mostFrequentRouteName = '';
        mostFrequentRouteCount = 0;
      }
    } catch (e) {
      // ignore
    }
    notifyListeners();
  }

  Future<void> fetchStreak() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      // Son 30 gün içinde her gün koşu var mı kontrol ederek streak hesapla
      final now = DateTime.now();
      final start = DateTime(now.year, now.month, now.day, 0, 0, 0)
          .subtract(const Duration(days: 30));
      final snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('runs')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .orderBy('date', descending: true)
          .get();
      final Set<String> days = {};
      for (final d in snap.docs) {
        final ts = d['date'];
        DateTime? dt;
        if (ts is Timestamp) dt = ts.toDate();
        if (ts is String) dt = DateTime.tryParse(ts);
        if (dt == null) continue;
        days.add(DateTime(dt.year, dt.month, dt.day).toIso8601String());
      }

      int streak = 0;
      for (int i = 0; i < 30; i++) {
        final day = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
        final key = DateTime(day.year, day.month, day.day).toIso8601String();
        if (days.contains(key)) {
          streak += 1;
        } else {
          break;
        }
      }
      streakDays = streak;
    } catch (e) {
      // ignore
    }
    notifyListeners();
  }

  Future<void> fetchLastRun() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      final snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('runs')
          .orderBy('date', descending: true)
          .limit(1)
          .get();
      if (snap.docs.isNotEmpty) {
        final data = snap.docs.first.data();
        lastRouteName = (data['route_name'] as String?) ?? (data['routeName'] as String?) ?? '';
        lastDistanceKm = ((data['distance'] as num?)?.toDouble() ?? 0.0) / 1000.0;
        lastDurationSec = (data['duration'] as num?)?.toInt() ?? 0;
        final dt = data['date'];
        if (dt is Timestamp) {
          lastDate = dt.toDate();
        } else if (dt is String) {
          lastDate = DateTime.tryParse(dt);
        }
      }
    } catch (e) {
      // ignore
    }
    notifyListeners();
  }
}
