import 'package:flutter/material.dart';
import 'package:runstat/data/services/goal_service.dart';

class DashboardViewModel extends ChangeNotifier {
  final GoalService _goalService;

  double _goalDistance = 0.0; // Günlük hedef mesafe
  double _completedDistance = 0.0; // Tamamlanan mesafe
  double _percentage = 0.0; // Tamamlama yüzdesi

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
}
