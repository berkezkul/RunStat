import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

class LanguagePreferences {
  static const String prefKey = "selected_language";

  // Dil tercihlerini kaydetme
  Future<void> setLanguage(Locale locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(prefKey, locale.languageCode);
  }

  // Dil tercihlerini yükleme
  Future<Locale> getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString(prefKey);

    // Eğer daha önce bir dil seçilmediyse varsayılan dil İngilizce olacaktır
    if (languageCode == null) {
      return Locale('en');
    }

    return Locale(languageCode);
  }
}
