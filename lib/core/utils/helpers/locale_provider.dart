import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  LocaleProvider() {
    _loadLocale(); // Uygulama açıldığında kayıtlı dili yükler
  }

  void setLocale(Locale locale) async {
    _locale = locale;
    notifyListeners(); // Ekranı güncelle
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode); // Dili kaydet
  }

  void _loadLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('languageCode');

    if (languageCode != null) {
      _locale = Locale(languageCode);
    } else {
      _locale = const Locale('en'); // Varsayılan dil İngilizce
    }
    notifyListeners(); // Yüklenen dili UI'da uygula
  }
}
