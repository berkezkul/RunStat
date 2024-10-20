import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/helpers/localization_helper.dart'; // Localization helper import
import 'package:runstat/core/utils/helpers/locale_provider.dart';

import '../../core/utils/theme/theme_provider.dart'; // LocaleProvider import

class SettingsPage extends StatefulWidget {
  final ValueChanged<Locale> onLocaleChange; // Locale değişimini bildirmek için bir callback ekliyoruz

  const SettingsPage({Key? key, required this.onLocaleChange}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;
  bool notificationsEnabled = true;
  String selectedLanguage = 'English'; // Varsayılan dil "English"

  @override
  void initState() {
    super.initState();
    // Mevcut dili ayarla (LocaleProvider'dan)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
      setState(() {
        selectedLanguage = localeProvider.locale?.languageCode == 'tr' ? 'Türkçe' : 'English';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context); // Localization instance
    final localeProvider = Provider.of<LocaleProvider>(context); // LocaleProvider

    final themeProvider = Provider.of<ThemeProvider>(context); // ThemeProvider erişimi
    bool isDarkMode = themeProvider.isDarkMode; // Karanlık mod kontrolü


    return Scaffold(
      appBar: AppBar(
        title: Text(localizations!.translate('rsSettings'),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.blue.shade900,
          ),), // "Settings"
        backgroundColor: Colors.transparent,

      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [Colors.black87, darkBlue]
                : [Colors.white, Colors.blue.shade100, Colors.blue.shade200],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(localizations.translate('rsDarkMode')), // "Dark Mode"
                trailing: Switch(
                  value: isDarkMode,
                  activeColor: Colors.blue.shade200,
                  hoverColor: Colors.blue.shade400,
                  focusColor: darkBlue,
                  onChanged: (value) {
                    setState(() {
                      themeProvider.toggleTheme(!isDarkMode);
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(localizations.translate('rsEnableNotifications')), // "Enable Notifications"
                trailing: Switch(
                  value: notificationsEnabled,
                  activeColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.blue.shade200
                      : Colors.blue.shade800,
                  hoverColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.blue.shade400
                      : Colors.blue.shade800,
                  focusColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.blueGrey.shade700
                      : Colors.blueGrey.shade900,
                  onChanged: (value) {
                    setState(() {
                      notificationsEnabled = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 16),
              ListTile(
                title: Text(localizations.translate('rsLanguage')), // "Language"
                subtitle: Text(selectedLanguage),
                onTap: () => _selectLanguage(context, localizations, localeProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dil seçim ekranı
  void _selectLanguage(BuildContext context, AppLocalizations localizations, LocaleProvider localeProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localizations!.translate('rsSelectLanguage')), // "Select Language"
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile(
                title: const Text('English'),
                value: 'English',
                groupValue: selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    selectedLanguage = value!;
                    localeProvider.setLocale(const Locale('en')); // Dil değişikliğini kaydet
                    widget.onLocaleChange(const Locale('en')); // Güncelle
                  });
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile(
                title: const Text('Türkçe'),
                value: 'Türkçe',
                groupValue: selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    selectedLanguage = value!;
                    localeProvider.setLocale(const Locale('tr')); // Dil değişikliğini kaydet
                    widget.onLocaleChange(const Locale('tr')); // Güncelle
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
