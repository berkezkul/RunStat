import 'package:flutter/material.dart';
import '../data/services/info_service.dart';

class InformationViewModel extends ChangeNotifier {
  bool _isLoading = true;
  Map<String, String>? _informationData;

  bool get isLoading => _isLoading;
  Map<String, String>? get informationData => _informationData;

  final InformationService _informationService = InformationService();

  InformationViewModel() {
    fetchInformation();
  }

  Future<void> fetchInformation() async {
    try {
      _isLoading = true;
      notifyListeners();

      _informationData = await _informationService.fetchInformation();
    } catch (e) {
      print("Error fetching information: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUpdatedInformation() async {
    await fetchInformation();
  }
}
